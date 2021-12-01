import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/dtos/appointment/fetch_available_slots/fetch_available_slots.dto.dart';
import 'package:varenya_mobile/exceptions/server.exception.dart';
import 'package:varenya_mobile/models/doctor/doctor.model.dart';
import 'package:varenya_mobile/services/appointment.service.dart';
import 'package:varenya_mobile/services/appointment.service.dart';
import 'package:varenya_mobile/services/doctor.service.dart';
import 'package:varenya_mobile/widgets/appointments/timing_slot.widget.dart';

class SlotList extends StatefulWidget {
  final DateTime dateTime;
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
  late final AppointmentService _appointmentService;

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
            new FetchAvailableSlotsDto(
              date: widget.dateTime,
              doctorId: widget.doctor.id,
            ),
          ),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<DateTime>> snapshot,
      ) {
        if (snapshot.hasError) {
          switch (snapshot.error.runtimeType) {
            case ServerException:
              {
                ServerException exception = snapshot.error as ServerException;
                return Text(exception.message);
              }
            default:
              {
                print(snapshot.error);
                return Text("Something went wrong, please try again later");
              }
          }
        }

        if (snapshot.connectionState == ConnectionState.done) {
          List<DateTime> dateTimeList = snapshot.data!;

          return Wrap(
            children: dateTimeList
                .map(
                  (dateTime) => TimingSlot(
                    slotTiming: dateTime,
                    doctor: widget.doctor,
                  ),
                )
                .toList(),
          );
        }

        return Column(
          children: [
            CircularProgressIndicator(),
          ],
        );
      },
    );
  }
}
