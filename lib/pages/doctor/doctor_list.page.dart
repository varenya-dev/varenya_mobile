import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/animations/error.animation.dart';
import 'package:varenya_mobile/animations/loading.animation.dart';
import 'package:varenya_mobile/animations/no_data.animation.dart';
import 'package:varenya_mobile/dtos/doctor_filter/doctor_filter.dto.dart';
import 'package:varenya_mobile/exceptions/server.exception.dart';
import 'package:varenya_mobile/models/doctor/doctor.model.dart';
import 'package:varenya_mobile/models/specialization/specialization.model.dart';
import 'package:varenya_mobile/services/doctor.service.dart';
import 'package:varenya_mobile/utils/logger.util.dart';
import 'package:varenya_mobile/utils/responsive_config.util.dart';
import 'package:varenya_mobile/widgets/doctor/display_doctor.widget.dart';
import 'package:varenya_mobile/widgets/doctor/doctor_card.widget.dart';
import 'package:varenya_mobile/widgets/doctor/doctor_filter.widget.dart';

class DoctorList extends StatefulWidget {
  const DoctorList({Key? key}) : super(key: key);

  static const routeName = "/doctor-list";

  @override
  _DoctorListState createState() => _DoctorListState();
}

class _DoctorListState extends State<DoctorList> {
  late final DoctorService _doctorService;

  String _jobFilter = 'EMPTY';
  List<Specialization> _specializationsFilter = [
    new Specialization(
      id: '',
      specialization: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    new Specialization(
      id: '',
      specialization: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];
  List<Doctor>? _doctors;

  @override
  void initState() {
    super.initState();

    this._doctorService = Provider.of<DoctorService>(context, listen: false);
  }

  void _addOrRemoveSpecializationFilter(Specialization specialization) {
    if (this
        ._specializationsFilter
        .where((element) => element.id == specialization.id)
        .isEmpty) {
      setState(() {
        this._specializationsFilter.add(specialization);
      });
    } else {
      setState(() {
        this
            ._specializationsFilter
            .removeWhere((element) => element.id == specialization.id);
      });
    }
  }

  void _addOrRemoveJob(String jobValue) {
    if (this._jobFilter == jobValue)
      setState(() {
        this._jobFilter = 'EMPTY';
      });
    else
      setState(() {
        this._jobFilter = jobValue;
      });
  }

  void _openDoctorFilters() {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            15.0,
          ),
          topRight: Radius.circular(
            15.0,
          ),
        ),
      ),
      backgroundColor: kIsWeb
          ? Colors.transparent
          : Theme.of(context).scaffoldBackgroundColor,
      context: context,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (context, setStateInner) => DoctorFilter(
          selectedSpecializations: this._specializationsFilter,
          selectedJob: this._jobFilter,
          addOrRemoveSpecialization: (Specialization specialization) {
            _addOrRemoveSpecializationFilter(specialization);

            setStateInner(() {});
          },
          addOrRemoveJob: (String job) {
            _addOrRemoveJob(job);

            setStateInner(() {});
          },
        ),
      ),
    );
  }

  void _displayDoctor(Doctor doctor) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            15.0,
          ),
          topRight: Radius.circular(
            15.0,
          ),
        ),
      ),
      backgroundColor: kIsWeb
          ? Colors.transparent
          : Theme.of(context).scaffoldBackgroundColor,
      context: context,
      builder: (BuildContext context) => DisplayDoctor(
        doctor: doctor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: responsiveConfig(
              context: context,
              large: MediaQuery.of(context).size.width * 0.25,
              medium: MediaQuery.of(context).size.width * 0.2,
              small: 0,
            ),
          ),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Container(
                  height: responsiveConfig(
                    context: context,
                    large: MediaQuery.of(context).size.height * 0.2,
                    medium: MediaQuery.of(context).size.height * 0.2,
                    small: MediaQuery.of(context).size.height * 0.2,
                  ),
                  width: MediaQuery.of(context).size.width,
                  color: Colors.black54,
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05,
                    vertical: MediaQuery.of(context).size.height * 0.05,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Doctors',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.06,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        iconSize: MediaQuery.of(context).size.height * 0.055,
                        onPressed: this._openDoctorFilters,
                        icon: Icon(
                          Icons.filter_list_outlined,
                        ),
                      ),
                    ],
                  ),
                ),
                FutureBuilder(
                  future: this._doctorService.fetchDoctorsWithFiltering(
                        new DoctorFilterDto(
                          jobTitle: this._jobFilter,
                          specializations: this
                              ._specializationsFilter
                              .map((specialization) =>
                                  specialization.specialization)
                              .toList(),
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
                            return Error(message: exception.message);
                          }
                        default:
                          {
                            log.e(
                              "DoctorList Error",
                              snapshot.error,
                              snapshot.stackTrace,
                            );
                            return Error(message: "Something went wrong, please try again later");
                          }
                      }
                    }

                    if (snapshot.connectionState == ConnectionState.done) {
                      this._doctors = snapshot.data!;

                      return _buildDoctorsList();
                    }

                    return this._doctors == null
                        ? Loading(message: "Loading doctor details")
                        : this._buildDoctorsList();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorsList() {
    return this._doctors!.length != 0 ? GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: this._doctors!.length,
      itemBuilder: (BuildContext context, int index) {
        Doctor doctor = this._doctors![index];

        return DoctorCard(
          doctor: doctor,
          onPressDoctor: () {
            this._displayDoctor(doctor);
          },
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: responsiveConfig(
          context: context,
          large: 2,
          medium: 1,
          small: 1,
        ).toInt(),
        childAspectRatio: responsiveConfig(
          context: context,
          large: 8 / 8,
          medium: 10 / 5,
          small: kIsWeb ? 10 / 11 : 10 / 8,
        ),
      ),
    ) : NoData(message: "No doctor details to display");
  }
}
