import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/exceptions/server.exception.dart';
import 'package:varenya_mobile/models/appointments/appointment/appointment.model.dart';
import 'package:varenya_mobile/services/appointment.service.dart';
import 'package:varenya_mobile/utils/logger.util.dart';
import 'package:varenya_mobile/utils/snackbar.dart';

class AppointmentCard extends StatefulWidget {
  // Appointment details.
  final Appointment appointment;

  // Method to refresh the page and appointments.
  final Function refreshAppointments;

  AppointmentCard({
    Key? key,
    required this.appointment,
    required this.refreshAppointments,
  }) : super(key: key);

  @override
  _AppointmentCardState createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  // Appointment service.
  late final AppointmentService _appointmentService;

  @override
  void initState() {
    super.initState();

    // Injecting appointment service from global state.
    this._appointmentService =
        Provider.of<AppointmentService>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
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
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
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
                    'Dr ${widget.appointment.doctorUser.fullName}',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.03,
                    ),
                  ),
                  Text(
                    this.widget.appointment.doctorUser.jobTitle,
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                    ),
                    Text(
                      DateFormat.yMd().format(
                        this.widget.appointment.scheduledFor,
                      ),
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.023,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.1,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                    ),
                    Text(
                      DateFormat.jm().format(
                        this.widget.appointment.scheduledFor,
                      ),
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.023,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                )
              ],
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.015,
                ),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.grey[900],
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.03,
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onPressed: this._onDeleteAppointment,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /*
   * Method to delete/cancel an appointment.
   */
  void _onDeleteAppointment() async {
    try {
      // Sending request to the server to delete appointment.
      await this._appointmentService.deleteAppointment(widget.appointment);

      // Refresh appointments on page
      widget.refreshAppointments();

      // Display confirmation to user.
      displaySnackbar(
        'Appointment Cancelled!',
        context,
      );
    }
    // Handling errors gracefully.
    on ServerException catch (error) {
      displaySnackbar(error.message, context);
    } catch (error, stackTrace) {
      log.e("AppointmentCard:_onDeleteAppointment", error, stackTrace);
      displaySnackbar(
        'Something went wrong, please try again later.',
        context,
      );
    }
  }
}
