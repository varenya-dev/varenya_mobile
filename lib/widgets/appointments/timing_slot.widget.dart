import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:varenya_mobile/models/doctor/doctor.model.dart';
import 'package:varenya_mobile/utils/palette.util.dart';

class TimingSlot extends StatelessWidget {
  // Slot Timing.
  final DateTime slotTiming;

  // Doctor details.
  final Doctor doctor;
  final VoidCallback bookAppointment;
  final bool selected;

  const TimingSlot({
    Key? key,
    required this.slotTiming,
    required this.doctor,
    required this.bookAppointment,
    required this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(
        MediaQuery.of(context).size.width * 0.01,
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: selected
              ? MaterialStateProperty.all(
                  Palette.primary,
                )
              : MaterialStateProperty.all(
                  Palette.secondary,
                ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              // Change your radius here
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
        ),
        onPressed: this.bookAppointment,
        child: Text(
          '${DateFormat.jm().format(this.slotTiming).toString()} - ${DateFormat.jm().format(this.slotTiming.add(new Duration(hours: 1))).toString()}',
          style: TextStyle(
            color: selected ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }
}
