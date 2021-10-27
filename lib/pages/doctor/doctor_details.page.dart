import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/dtos/appointment/create_appointment/create_appointment.dto.dart';
import 'package:varenya_mobile/models/doctor/doctor.model.dart';
import 'package:varenya_mobile/pages/chat/chat_page.dart';
import 'package:varenya_mobile/services/appointment.service.dart';
import 'package:varenya_mobile/services/chat_service.dart';
import 'package:varenya_mobile/widgets/doctor/doctor_card.widget.dart';

class DoctorDetails extends StatefulWidget {
  const DoctorDetails({Key? key}) : super(key: key);

  static const routeName = "/doctor-details";

  @override
  _DoctorDetailsState createState() => _DoctorDetailsState();
}

class _DoctorDetailsState extends State<DoctorDetails> {
  late final ChatService _chatService;
  late final AppointmentService _appointmentService;

  @override
  void initState() {
    super.initState();

    this._chatService = Provider.of<ChatService>(context, listen: false);
    this._appointmentService = Provider.of<AppointmentService>(
      context,
      listen: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    Doctor doctorDetails = ModalRoute.of(context)!.settings.arguments as Doctor;
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Details'),
      ),
      body: Column(
        children: [
          DoctorCard(
            doctor: doctorDetails,
          ),
          ElevatedButton(
            onPressed: () async {
              String threadId =
                  await this._chatService.createNewThread(doctorDetails.id);

              Navigator.of(context).pushNamed(
                ChatPage.routeName,
                arguments: threadId,
              );
            },
            child: Text('Start Chatting'),
          ),
          ElevatedButton(
            onPressed: () async {
              await this._appointmentService.fetchScheduledAppointments();
            },
            child: Text('Book Appointment'),
          ),
        ],
      ),
    );
  }
}
