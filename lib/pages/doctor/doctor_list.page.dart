import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/dtos/doctor_filter/doctor_filter.dto.dart';
import 'package:varenya_mobile/exceptions/server.exception.dart';
import 'package:varenya_mobile/models/doctor/doctor.model.dart';
import 'package:varenya_mobile/models/specialization/specialization.model.dart';
import 'package:varenya_mobile/services/doctor.service.dart';
import 'package:varenya_mobile/utils/logger.util.dart';
import 'package:varenya_mobile/utils/modal_bottom_sheet.dart';
import 'package:varenya_mobile/widgets/doctor/doctor_card.widget.dart';

class DoctorList extends StatefulWidget {
  const DoctorList({Key? key}) : super(key: key);

  static const routeName = "/doctor-list";

  @override
  _DoctorListState createState() => _DoctorListState();
}

class _DoctorListState extends State<DoctorList> {
  late final DoctorService _doctorService;

  String _jobFilter = 'EMPTY';
  List<String> _specializationsFilter = ['', ''];
  List<Doctor> _doctors = [];

  @override
  void initState() {
    super.initState();

    this._doctorService = Provider.of<DoctorService>(context, listen: false);
  }

  void _openSpecializationFilters(BuildContext context) {
    displayBottomSheet(
      context,
      StatefulBuilder(
        builder: (context, setStateInner) => Wrap(
          children: [
            FutureBuilder(
              future: this._doctorService.fetchSpecializations(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Specialization>> snapshot) {
                if (snapshot.hasError) {
                  switch (snapshot.error.runtimeType) {
                    case ServerException:
                      {
                        ServerException exception =
                            snapshot.error as ServerException;
                        return Text(exception.message);
                      }
                    default:
                      {
                        log.e(
                          "DoctorList:_openSpecializationFilters Error",
                          snapshot.error,
                          snapshot.stackTrace,
                        );
                        return Text(
                            "Something went wrong, please try again later");
                      }
                  }
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  List<Specialization> specializations = snapshot.data!;
                  return ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: specializations
                        .map(
                          (s) => ListTile(
                            title: Text(
                              s.specialization,
                            ),
                            leading: Checkbox(
                              value: this
                                  ._specializationsFilter
                                  .contains(s.specialization),
                              onChanged: (bool? value) {
                                if (value == true) {
                                  setState(() {
                                    this
                                        ._specializationsFilter
                                        .add(s.specialization);
                                  });
                                } else {
                                  setState(() {
                                    this
                                        ._specializationsFilter
                                        .remove(s.specialization);
                                  });
                                }
                                setStateInner(() {});
                              },
                            ),
                          ),
                        )
                        .toList(),
                  );
                }

                return Column(
                  children: [
                    CircularProgressIndicator(),
                  ],
                );
              },
            ),
            Center(
              child: TextButton(
                child: Text('Clear Filters'),
                onPressed: () {
                  setState(() {
                    this._specializationsFilter.clear();
                    this._specializationsFilter.add('');
                    this._specializationsFilter.add('');
                  });

                  setStateInner(() {});
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void _openJobFilters(BuildContext context) {
    displayBottomSheet(
      context,
      StatefulBuilder(
        builder: (context, setStateInner) => Wrap(
          children: [
            FutureBuilder(
              future: this._doctorService.fetchJobTitles(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                if (snapshot.hasError) {
                  switch (snapshot.error.runtimeType) {
                    case ServerException:
                      {
                        ServerException exception =
                            snapshot.error as ServerException;
                        return Text(exception.message);
                      }
                    default:
                      {
                        log.e(
                          "DoctorList:_openJobFilters Error",
                          snapshot.error,
                          snapshot.stackTrace,
                        );
                        return Text(
                            "Something went wrong, please try again later");
                      }
                  }
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  List<String> jobTitles = snapshot.data!;
                  return ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: jobTitles
                        .map(
                          (job) => ListTile(
                            title: Text(
                              job,
                            ),
                            leading: Radio(
                              value: job,
                              groupValue: this._jobFilter,
                              onChanged: (String? jobValue) {
                                if (jobValue != null) {
                                  setState(() {
                                    this._jobFilter = jobValue;
                                  });
                                  setStateInner(() {});
                                }
                              },
                            ),
                          ),
                        )
                        .toList(),
                  );
                }

                return Column(
                  children: [
                    CircularProgressIndicator(),
                  ],
                );
              },
            ),
            Center(
              child: TextButton(
                child: Text('Clear Filters'),
                onPressed: () {
                  setState(() {
                    this._jobFilter = 'EMPTY';
                  });

                  setStateInner(() {});
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctors'),
      ),
      body: Column(
        children: [
          _buildFilterMain(),
          FutureBuilder(
            future: this._doctorService.fetchDoctorsWithFiltering(
                  new DoctorFilterDto(
                    jobTitle: this._jobFilter,
                    specializations: this._specializationsFilter,
                  ),
                ),
            builder: (
              BuildContext context,
              AsyncSnapshot<List<Doctor>> snapshot,
            ) {
              if (snapshot.hasError) {
                switch (snapshot.error.runtimeType) {
                  case ServerException:
                    {
                      ServerException exception =
                          snapshot.error as ServerException;
                      return Text(exception.message);
                    }
                  default:
                    {
                      log.e(
                        "DoctorList Error",
                        snapshot.error,
                        snapshot.stackTrace,
                      );
                      return Text(
                          "Something went wrong, please try again later");
                    }
                }
              }

              if (snapshot.connectionState == ConnectionState.done) {
                this._doctors = snapshot.data!;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: this._doctors.length,
                  itemBuilder: (BuildContext context, int index) {
                    Doctor doctor = this._doctors[index];

                    return DoctorCard(
                      doctor: doctor,
                    );
                  },
                );
              }

              return Column(
                children: [
                  CircularProgressIndicator(),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterMain() {
    return ExpandableNotifier(
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: <Widget>[
            ScrollOnExpand(
              scrollOnExpand: true,
              scrollOnCollapse: false,
              child: ExpandablePanel(
                theme: const ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToCollapse: true,
                ),
                header: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30.0,
                  ),
                  child: Text(
                    "Filter Options",
                  ),
                ),
                collapsed: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30.0,
                    vertical: 20.0,
                  ),
                  child: Text(
                    "Tap To Show Filter Options",
                  ),
                ),
                expanded: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildJobFilter(),
                    _buildSpecializationFilter(),
                  ],
                ),
                builder: (_, collapsed, expanded) {
                  return Expandable(
                    collapsed: collapsed,
                    expanded: expanded,
                    theme: const ExpandableThemeData(
                      crossFadePoint: 0,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecializationFilter() {
    return ListTile(
      title: Text('Select Specialization Filter'),
      onTap: () {
        this._openSpecializationFilters(context);
      },
    );
  }

  Widget _buildJobFilter() {
    return ListTile(
      title: Text('Select Job Filter'),
      onTap: () {
        this._openJobFilters(context);
      },
    );
  }
}
