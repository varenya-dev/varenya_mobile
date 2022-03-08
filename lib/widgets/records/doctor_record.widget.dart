import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/exceptions/server.exception.dart';
import 'package:varenya_mobile/models/doctor/doctor.model.dart';
import 'package:varenya_mobile/services/daily_questionnaire.service.dart';
import 'package:varenya_mobile/utils/logger.util.dart';
import 'package:varenya_mobile/utils/responsive_config.util.dart';
import 'package:varenya_mobile/utils/snackbar.dart';
import 'package:varenya_mobile/widgets/doctor/display_doctor.widget.dart';

class DoctorRecord extends StatefulWidget {
  // Appointment details.
  final Doctor doctor;

  DoctorRecord({
    Key? key,
    required this.doctor,
  }) : super(key: key);

  @override
  _DoctorRecordState createState() => _DoctorRecordState();
}

class _DoctorRecordState extends State<DoctorRecord> {
  late final DailyQuestionnaireService _dailyQuestionnaireService;

  bool _sharedMood = false;

  @override
  void initState() {
    super.initState();

    this._dailyQuestionnaireService =
        Provider.of<DailyQuestionnaireService>(context, listen: false);

    this
        ._dailyQuestionnaireService
        .checkIfDoctorHasAccess(this.widget.doctor.user!.firebaseId)
        .then((value) {
      setState(() {
        this._sharedMood = value;
      });
    });
  }

  void _displayDoctor() {
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
        doctor: this.widget.doctor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this._displayDoctor,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            15.0,
          ),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05,
          vertical: MediaQuery.of(context).size.height * 0.015,
        ),
        child: Padding(
          padding: EdgeInsets.all(
            responsiveConfig(
              context: context,
              large: MediaQuery.of(context).size.width * 0.025,
              medium: MediaQuery.of(context).size.width * 0.025,
              small: MediaQuery.of(context).size.width * 0.05,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.017,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dr ${this.widget.doctor.fullName}',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.03,
                      ),
                    ),
                    Text(
                      this.widget.doctor.jobTitle,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Share Moods?'),
                  Switch(
                    value: this._sharedMood,
                    onChanged: this._onToggleMood,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /*
   * Method to share/restrict mood data share.
   */
  void _onToggleMood(_) async {
    try {
      // Sending request to the server to delete appointment.
      await this._dailyQuestionnaireService.toggleShareMood(
            this.widget.doctor.user!.firebaseId,
          );

      bool check = await this._dailyQuestionnaireService.checkIfDoctorHasAccess(
            this.widget.doctor.user!.firebaseId,
          );

      setState(() {
        this._sharedMood = check;
      });
    }
    // Handling errors gracefully.
    on ServerException catch (error) {
      displaySnackbar(error.message, context);
    } catch (error, stackTrace) {
      log.e("DoctorRecord:_onShareMood", error, stackTrace);
      displaySnackbar(
        'Something went wrong, please try again later.',
        context,
      );
    }
  }
}
