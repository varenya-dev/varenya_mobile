import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/dtos/appointment/fetch_available_slots/fetch_available_slots.dto.dart';
import 'package:varenya_mobile/exceptions/server.exception.dart';
import 'package:varenya_mobile/models/doctor/doctor.model.dart';
import 'package:varenya_mobile/services/appointment.service.dart';
import 'package:varenya_mobile/utils/logger.util.dart';
import 'package:varenya_mobile/widgets/appointments/timing_slot.widget.dart';

class AvailableSlots extends StatefulWidget {
  final DateTime dateTime;
  final DateTime selectedSlot;
  final Doctor doctor;
  final Function onSelectSlot;

  const AvailableSlots({
    Key? key,
    required this.dateTime,
    required this.selectedSlot,
    required this.doctor,
    required this.onSelectSlot,
  }) : super(key: key);

  @override
  _AvailableSlotsState createState() => _AvailableSlotsState();
}

class _AvailableSlotsState extends State<AvailableSlots> {
  late final AppointmentService _appointmentService;

  List<DateTime>? _dateTimeList;

  @override
  void initState() {
    super.initState();

    this._appointmentService =
        Provider.of<AppointmentService>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: this._appointmentService.fetchAvailableSlots(
            FetchAvailableSlotsDto(
              date: this.widget.dateTime,
              doctorId: this.widget.doctor.id,
            ),
          ),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<DateTime>> snapshot,
      ) {
        // Check for errors
        if (snapshot.hasError) {
          // Check for error type and handle them accordingly
          switch (snapshot.error.runtimeType) {
            case ServerException:
              {
                ServerException exception = snapshot.error as ServerException;
                return Text(exception.message);
              }
            default:
              {
                log.e("SlotList Error", snapshot.error, snapshot.stackTrace);
                return Text("Something went wrong, please try again later");
              }
          }
        }

        // Check if data has loaded or not.
        if (snapshot.connectionState == ConnectionState.done) {
          // Save data in local state.
          this._dateTimeList = snapshot.data!;

          // Return and build time slot page.
          return _buildTimeSlots();
        }

        // If previously fetched time slots,
        // display them or display loading indicator.
        return this._dateTimeList == null
            ? Column(
                children: [
                  CircularProgressIndicator(),
                ],
              )
            : _buildTimeSlots();
      },
    );
  }

  Wrap _buildTimeSlots() {
    return Wrap(
      children: this
          ._dateTimeList!
          .map(
            (dateTime) => TimingSlot(
              selected: this.widget.selectedSlot.isAtSameMomentAs(dateTime),
              slotTiming: dateTime,
              doctor: widget.doctor,
              bookAppointment: () {
                this.widget.onSelectSlot(dateTime);
              },
            ),
          )
          .toList(),
    );
  }
}
