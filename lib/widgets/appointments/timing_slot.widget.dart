import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/dtos/appointment/create_appointment/create_appointment.dto.dart';
import 'package:varenya_mobile/exceptions/server.exception.dart';
import 'package:varenya_mobile/models/doctor/doctor.model.dart';
import 'package:varenya_mobile/services/appointment.service.dart';
import 'package:varenya_mobile/utils/logger.util.dart';
import 'package:varenya_mobile/utils/snackbar.dart';

class TimingSlot extends StatefulWidget {
  final DateTime slotTiming;
  final Doctor doctor;

  const TimingSlot({
    Key? key,
    required this.slotTiming,
    required this.doctor,
  }) : super(key: key);

  @override
  State<TimingSlot> createState() => _TimingSlotState();
}

class _TimingSlotState extends State<TimingSlot> {
  late final AppointmentService _appointmentService;

  @override
  void initState() {
    super.initState();

    this._appointmentService =
        Provider.of<AppointmentService>(context, listen: false);
  }

  Future<void> _bookAppointment() async {
    try {
      await this._appointmentService.bookAppointment(
            CreateAppointmentDto(
                doctorId: this.widget.doctor.id,
                timing: this.widget.slotTiming),
          );

      displaySnackbar(
        "Appointment has been booked!",
        context,
      );

      Navigator.of(context).pop();
    } on ServerException catch (error) {
      displaySnackbar(error.message, context);
    } catch (error, stackTrace) {
      log.e("TimingSlot:_bookAppointment", error, stackTrace);
      displaySnackbar(
        "Something went wrong, please try again later.",
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
      child: ElevatedButton(
        onPressed: this._bookAppointment,
        child: Text(
          '${DateFormat.jm().format(widget.slotTiming).toString()} - ${DateFormat.jm().format(widget.slotTiming.add(new Duration(hours: 1))).toString()}',
        ),
      ),
    );
  }
}
