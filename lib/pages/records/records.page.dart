import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/animations/error.animation.dart';
import 'package:varenya_mobile/animations/loading.animation.dart';
import 'package:varenya_mobile/animations/no_data.animation.dart';
import 'package:varenya_mobile/exceptions/server.exception.dart';
import 'package:varenya_mobile/models/doctor/doctor.model.dart';
import 'package:varenya_mobile/services/records.service.dart';
import 'package:varenya_mobile/utils/logger.util.dart';
import 'package:varenya_mobile/utils/palette.util.dart';
import 'package:varenya_mobile/utils/responsive_config.util.dart';
import 'package:varenya_mobile/widgets/records/doctor_record.widget.dart';

class Records extends StatefulWidget {
  const Records({Key? key}) : super(key: key);

  // Page Route Name
  static const routeName = "/records";

  @override
  _RecordsState createState() => _RecordsState();
}

class _RecordsState extends State<Records> {
  late final RecordsService _recordsService;
  List<Doctor>? _doctors;

  @override
  void initState() {
    super.initState();

    this._recordsService = Provider.of<RecordsService>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: responsiveConfig(
                context: context,
                large: MediaQuery.of(context).size.width * 0.25,
                medium: MediaQuery.of(context).size.width * 0.25,
                small: 0,
              ),
            ),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Palette.black,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(
                      responsiveConfig(
                        context: context,
                        large: MediaQuery.of(context).size.width * 0.03,
                        medium: MediaQuery.of(context).size.width * 0.03,
                        small: MediaQuery.of(context).size.width * 0.05,
                      ),
                    ),
                    child: Text(
                      'Doctors\nIn Contact',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.05,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  FutureBuilder(
                    future: this._recordsService.fetchDoctorRecords(),
                    builder: _handleRecordsFuture,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _handleRecordsFuture(
    BuildContext buildContext,
    AsyncSnapshot<List<Doctor>> snapshot,
  ) {
    // Check for errors.
    if (snapshot.hasError) {
      // Checking type of error and handling them.
      switch (snapshot.error.runtimeType) {
        case ServerException:
          {
            ServerException exception = snapshot.error as ServerException;
            return Error(message: exception.message);
          }
        default:
          {
            log.e(
              "Records Error",
              snapshot.error,
              snapshot.stackTrace,
            );
            return Error(message: "Something went wrong, please try again later");
          }
      }
    }

    // Check if data has been loaded
    if (snapshot.connectionState == ConnectionState.done) {
      this._doctors = snapshot.data!;

      // Return and build main page.
      return _buildRecordsBody();
    }

    // If previously fetched doctors exists,
    // display them or loading indicator.
    return this._doctors == null
        ? Loading(message: 'Loading doctor details for you')
        : this._buildRecordsBody();
  }

  Widget _buildRecordsBody() {
    return this._doctors!.length != 0 ? ListView.builder(
      itemCount: this._doctors!.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        Doctor doctor = this._doctors![index];

        return DoctorRecord(
          doctor: doctor,
        );
      },
    ) : NoData(message: 'No doctor details to display');
  }
}
