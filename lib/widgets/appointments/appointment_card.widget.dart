import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/exceptions/server.exception.dart';
import 'package:varenya_mobile/models/appointments/appointment/appointment.model.dart';
import 'package:varenya_mobile/services/appointment.service.dart';
import 'package:varenya_mobile/utils/logger.util.dart';
import 'package:varenya_mobile/utils/snackbar.dart';

class AppointmentCard extends StatefulWidget {
  final Appointment appointment;
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
  late final AppointmentService _appointmentService;

  @override
  void initState() {
    super.initState();

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

  void _onDeleteAppointment(int? value) async {
    try {
      await this._appointmentService.deleteAppointment(widget.appointment);

      widget.refreshAppointments();

      displaySnackbar(
        'Appointment Cancelled!',
        context,
      );
    } on ServerException catch (error) {
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
