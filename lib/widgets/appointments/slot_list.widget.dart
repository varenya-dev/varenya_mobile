import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/dtos/appointment/fetch_available_slots/fetch_available_slots.dto.dart';
import 'package:varenya_mobile/exceptions/server.exception.dart';
import 'package:varenya_mobile/models/doctor/doctor.model.dart';
import 'package:varenya_mobile/services/appointment.service.dart';
import 'package:varenya_mobile/utils/logger.util.dart';
import 'package:varenya_mobile/widgets/appointments/timing_slot.widget.dart';

class SlotList extends StatefulWidget {
  // Date data
  final DateTime dateTime;

  // Doctor's data.
  final Doctor doctor;

  const SlotList({
    Key? key,
    required this.dateTime,
    required this.doctor,
  }) : super(key: key);

  @override
  State<SlotList> createState() => _SlotListState();
}

class _SlotListState extends State<SlotList> {
  // Appointment Service.
  late final AppointmentService _appointmentService;

  // List of available appointment slots.
  List<DateTime>? _dateTimeList;

  @override
  void initState() {
    super.initState();

    // Injecting Appointment service from global state.
    this._appointmentService =
        Provider.of<AppointmentService>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: this._appointmentService.fetchAvailableSlots(
            new FetchAvailableSlotsDto(
              date: widget.dateTime,
              doctorId: widget.doctor.id,
            ),
          ),
      builder: _handleTimeSlotsFuture,
    );
  }

  /*
   * Method to handle consuming future and build page body.
   */
  Widget _handleTimeSlotsFuture(
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
  }

  /*
   * Method to build time slots data.
   */
  Wrap _buildTimeSlots() {
    return Wrap(
      children: this
          ._dateTimeList!
          .map(
            (dateTime) => TimingSlot(
              slotTiming: dateTime,
              doctor: widget.doctor,
            ),
          )
          .toList(),
    );
  }
}
