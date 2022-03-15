import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/dtos/appointment/create_appointment/create_appointment.dto.dart';
import 'package:varenya_mobile/exceptions/server.exception.dart';
import 'package:varenya_mobile/models/doctor/doctor.model.dart';
import 'package:varenya_mobile/services/appointment.service.dart';
import 'package:varenya_mobile/services/daily_questionnaire.service.dart';
import 'package:varenya_mobile/utils/logger.util.dart';
import 'package:varenya_mobile/utils/palette.util.dart';
import 'package:varenya_mobile/utils/snackbar.dart';
import 'package:varenya_mobile/widgets/appointments/appointment_button.widget.dart';
import 'package:varenya_mobile/widgets/appointments/appointment_day.widget.dart';
import 'package:varenya_mobile/widgets/appointments/available_slots.widget.dart';

class AppointmentSlotList extends StatefulWidget {
  final Doctor doctor;

  const AppointmentSlotList({
    Key? key,
    required this.doctor,
  }) : super(key: key);

  @override
  _AppointmentSlotListState createState() => _AppointmentSlotListState();
}

class _AppointmentSlotListState extends State<AppointmentSlotList> {
  List<DateTime> nextWeekDateList = [];
  DateTime? _selectedDate;
  DateTime _selectedSlot = DateTime.now();

  late final AppointmentService _appointmentService;
  late final DailyQuestionnaireService _dailyQuestionnaireService;

  bool _loading = false;

  @override
  void initState() {
    super.initState();

    DateTime dateTime = DateTime.now();

    // Store next week's dates in the list.
    for (int i = 0; i <= 6; i++) {
      DateTime newDateTime = dateTime.add(Duration(days: i));

      nextWeekDateList.add(newDateTime);
    }

    this._selectedDate = nextWeekDateList[0];

    this._appointmentService = Provider.of<AppointmentService>(
      context,
      listen: false,
    );

    this._dailyQuestionnaireService = Provider.of<DailyQuestionnaireService>(
      context,
      listen: false,
    );
  }

  void _selectSlot(DateTime slot) {
    setState(() {
      this._selectedSlot = slot;
    });
  }

  Future<void> _onConfirm() async {
    setState(() {
      this._loading = true;
    });
    try {
      // Send request to server to book appointment.
      await this._appointmentService.bookAppointment(
            CreateAppointmentDto(
              doctorId: this.widget.doctor.id,
              timing: this._selectedSlot,
            ),
          );

      // Confirm appointment booking.
      displaySnackbar(
        "Appointment has been booked!",
        context,
      );

      bool check = await this
          ._dailyQuestionnaireService
          .checkIfDoctorHasAccess(this.widget.doctor.user!.firebaseId);

      if (!check) {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Confirmation'),
            content:
                Text('Do you want to share your mood data with this doctor?'),
            actions: [
              TextButton(
                onPressed: () async {
                  await this._dailyQuestionnaireService.toggleShareMood(
                        this.widget.doctor.user!.firebaseId,
                      );

                  Navigator.of(context).pop();
                },
                child: Text('Yes'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('No'),
              ),
            ],
          ),
        );
      }

      setState(() {});
    }
    // Handle errors gracefully.
    on ServerException catch (error) {
      displaySnackbar(error.message, context);
    } catch (error, stackTrace) {
      log.e("AppointmentSlotList:_onConfirm", error, stackTrace);
      displaySnackbar(
        "Something went wrong, please try again later.",
        context,
      );
    }

    setState(() {
      this._loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Palette.black,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: this
                .nextWeekDateList
                .map(
                  (date) => AppointmentDay(
                    selected: this._selectedDate!.compareTo(date) == 0,
                    dateTime: date,
                    onSelected: () {
                      setState(() {
                        this._selectedDate = date;
                      });
                    },
                  ),
                )
                .toList(),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.05,
          ),
          child: AvailableSlots(
            selectedSlot: this._selectedSlot,
            dateTime: this._selectedDate!,
            doctor: this.widget.doctor,
            onSelectSlot: this._selectSlot,
          ),
        ),
        AppointmentButton(
          onConfirm: this._onConfirm,
          loading: this._loading,
        )
      ],
    );
  }
}
