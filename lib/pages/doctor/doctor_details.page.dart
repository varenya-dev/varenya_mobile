import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/models/doctor/doctor.model.dart';
import 'package:varenya_mobile/pages/chat/chat_page.dart';
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

  @override
  void initState() {
    super.initState();

    this._chatService = Provider.of<ChatService>(context, listen: false);
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
            onPressed: () {},
            child: Text('Book Appointment'),
          ),
        ],
      ),
    );
  }
}
