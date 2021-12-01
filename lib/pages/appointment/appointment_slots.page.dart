import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:varenya_mobile/models/doctor/doctor.model.dart';
import 'package:varenya_mobile/widgets/appointments/slot_list.widget.dart';

class AppointmentSlots extends StatefulWidget {
  const AppointmentSlots({Key? key}) : super(key: key);

  static const routeName = "/appointment-slots";

  @override
  _AppointmentSlotsState createState() => _AppointmentSlotsState();
}

class _AppointmentSlotsState extends State<AppointmentSlots> {
  List<DateTime> nextWeekDateList = [];
  Doctor? doctorDetails;

  @override
  void initState() {
    super.initState();

    DateTime dateTime = DateTime.now();

    for (int i = 0; i <= 6; i++) {
      DateTime newDateTime = dateTime.add(Duration(days: i));

      nextWeekDateList.add(newDateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (this.doctorDetails == null) {
      this.doctorDetails = ModalRoute.of(context)!.settings.arguments as Doctor;
    }

    return DefaultTabController(
      length: nextWeekDateList.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Select A Slot'),
          bottom: TabBar(
            isScrollable: true,
            tabs: this
                .nextWeekDateList
                .map(
                  (dateTime) => Tab(
                    text: DateFormat.yMMMd().format(dateTime).toString(),
                  ),
                )
                .toList(),
          ),
        ),
        body: TabBarView(
          children: this
              .nextWeekDateList
              .map(
                (dateTime) => SlotList(
                  dateTime: dateTime,
                  doctor: this.doctorDetails!,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
