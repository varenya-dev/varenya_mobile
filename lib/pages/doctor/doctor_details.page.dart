import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/models/doctor/doctor.model.dart';
import 'package:varenya_mobile/pages/appointment/appointment_slots.page.dart';
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
          OfflineBuilder(
            connectivityBuilder:
                (BuildContext context, ConnectivityResult result, _) {
              final bool connected = result != ConnectivityResult.none;

              return ElevatedButton(
                onPressed: connected
                    ? () async {
                        String threadId = await this
                            ._chatService
                            .createNewThread(doctorDetails.id);

                        Navigator.of(context).pushNamed(
                          ChatPage.routeName,
                          arguments: threadId,
                        );
                      }
                    : null,
                child: Text(
                  connected ? 'Start Chatting' : 'You Are Offline',
                ),
              );
            },
            child: SizedBox(),
          ),
          OfflineBuilder(
            connectivityBuilder:
                (BuildContext context, ConnectivityResult result, _) {
              final bool connected = result != ConnectivityResult.none;

              return ElevatedButton(
                onPressed: connected
                    ? () {
                        Navigator.of(context).pushNamed(
                          AppointmentSlots.routeName,
                          arguments: doctorDetails,
                        );
                      }
                    : null,
                child: Text(
                  connected ? 'Book Appointment' : 'You Are Offline',
                ),
              );
            },
            child: SizedBox(),
          ),
        ],
      ),
    );
  }
}
