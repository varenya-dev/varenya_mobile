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
      child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dr ${widget.appointment.doctorUser.fullName}',
                    ),
                  ],
                ),
                PopupMenuButton(
                  elevation: 40,
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text("Cancel Appointment"),
                      value: 1,
                    ),
                  ],
                  onSelected: _onDeleteAppointment,
                ),
              ],
            ),
            Text(
                'Booked for: ${DateFormat.yMd().add_jm().format(this.widget.appointment.scheduledFor).toString()}')
          ],
        ),
      ),
    );
  }

  /*
   * Method to delete/cancel an appointment.
   */
  void _onDeleteAppointment(_) async {
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
