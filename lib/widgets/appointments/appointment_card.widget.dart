import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:varenya_mobile/enum/confirmation_status.enum.dart';
import 'package:varenya_mobile/models/appointments/patient_appointment_response/patient_appointment_response.model.dart';

class AppointmentCard extends StatefulWidget {
  final PatientAppointmentResponse appointment;

  AppointmentCard({
    Key? key,
    required this.appointment,
  }) : super(key: key);

  @override
  _AppointmentCardState createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dr ${widget.appointment.doctor.fullName}',
            ),
            if (widget.appointment.appointment.status ==
                ConfirmationStatus.PENDING)
              Text(
                widget.appointment.appointment.status.toString().split('.')[1],
                textAlign: TextAlign.left,
              ),
            if (widget.appointment.appointment.status ==
                ConfirmationStatus.CONFIRMED)
              Text(
                'Confirmed for: ${DateFormat.yMd().add_jm().format(
                      widget.appointment.appointment.scheduledFor.toLocal(),
                    ).toString()}',
                textAlign: TextAlign.left,
              ),
          ],
        ),
      ),
    );
  }
}
