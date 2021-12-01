import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:varenya_mobile/models/doctor/doctor.model.dart';

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
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
      child: ElevatedButton(
        onPressed: () {},
        child: Text(
          '${DateFormat.jm().format(widget.slotTiming).toString()} - ${DateFormat.jm().format(widget.slotTiming.add(new Duration(hours: 1))).toString()}',
        ),
      ),
    );
  }
}
