import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/animations/error.animation.dart';
import 'package:varenya_mobile/animations/loading.animation.dart';
import 'package:varenya_mobile/animations/no_data.animation.dart';
import 'package:varenya_mobile/exceptions/server.exception.dart';
import 'package:varenya_mobile/services/doctor.service.dart';
import 'package:varenya_mobile/utils/logger.util.dart';
import 'package:varenya_mobile/utils/palette.util.dart';
import 'package:varenya_mobile/utils/responsive_config.util.dart';

class DisplaySelectedJobs extends StatefulWidget {
  final String selectedJob;
  final Function addOrRemoveJob;

  const DisplaySelectedJobs({
    Key? key,
    required this.selectedJob,
    required this.addOrRemoveJob,
  }) : super(key: key);

  @override
  _DisplaySelectedJobsState createState() => _DisplaySelectedJobsState();
}

class _DisplaySelectedJobsState extends State<DisplaySelectedJobs> {
  late final DoctorService _doctorService;

  List<String>? fetchedJobs;

  @override
  void initState() {
    super.initState();

    this._doctorService = Provider.of<DoctorService>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: this._doctorService.fetchJobTitles(),
        builder: (
          BuildContext context,
          AsyncSnapshot<List<String>> snapshot,
        ) {
          if (snapshot.hasError) {
            switch (snapshot.error.runtimeType) {
              case ServerException:
                {
                  ServerException exception = snapshot.error as ServerException;
                  return Error(message: exception.message);
                }
              default:
                {
                  log.e(
                    "DisplaySelectedJobs Error",
                    snapshot.error,
                    snapshot.stackTrace,
                  );
                  return Error(
                      message: "Something went wrong, please try again later");
                }
            }
          }

          if (snapshot.connectionState == ConnectionState.done) {
            this.fetchedJobs = snapshot.data!;

            return _buildSpecializationsList();
          }

          return this.fetchedJobs == null
              ? Loading(message: "Loading job filters")
              : _buildSpecializationsList();
        },
      ),
    );
  }

  Widget _buildSpecializationsList() {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: responsiveConfig(
          context: context,
          large: MediaQuery.of(context).size.height * 0.05,
          medium: MediaQuery.of(context).size.height * 0.05,
          small: 0,
        ),
      ),
      child: this.fetchedJobs!.length != 0
          ? Wrap(
              alignment: WrapAlignment.center,
              children: this.fetchedJobs!.map(
                (job) {
                  bool checkSelected = this.widget.selectedJob == job;

                  return GestureDetector(
                    onTap: () {
                      this.widget.addOrRemoveJob(job);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: !checkSelected
                            ? Palette.secondary
                            : Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(
                          15.0,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.02,
                        horizontal: MediaQuery.of(context).size.width * 0.05,
                      ),
                      margin: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.01,
                        horizontal: MediaQuery.of(context).size.width * 0.015,
                      ),
                      child: Text(
                        job,
                        style: TextStyle(
                          color: checkSelected ? Colors.black : Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ).toList(),
            )
          : NoData(message: "No job filters to display"),
    );
  }
}
