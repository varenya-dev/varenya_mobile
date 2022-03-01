import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/arguments/chat.argument.dart';
import 'package:varenya_mobile/models/doctor/doctor.model.dart';
import 'package:varenya_mobile/models/user/server_user.model.dart';
import 'package:varenya_mobile/pages/chat/chat.page.dart';
import 'package:varenya_mobile/services/chat.service.dart';
import 'package:varenya_mobile/services/user_service.dart';

class DoctorPopupNameSpecialization extends StatefulWidget {
  final Doctor doctor;

  const DoctorPopupNameSpecialization({
    Key? key,
    required this.doctor,
  }) : super(key: key);

  @override
  State<DoctorPopupNameSpecialization> createState() =>
      _DoctorPopupNameSpecializationState();
}

class _DoctorPopupNameSpecializationState
    extends State<DoctorPopupNameSpecialization> {
  late final ChatService _chatService;
  late final UserService _userService;

  @override
  void initState() {
    super.initState();

    this._chatService = Provider.of<ChatService>(context, listen: false);
    this._userService = Provider.of<UserService>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.02,
        vertical: MediaQuery.of(context).size.height * 0.02,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dr. ${this.widget.doctor.fullName}',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.03,
                ),
              ),
              Text(
                this.widget.doctor.jobTitle,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.02,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: () async {
              String threadId = await this
                  ._chatService
                  .createNewThread(this.widget.doctor.user!.firebaseId);

              ServerUser serverUser = await this._userService.findUserById(
                    this.widget.doctor.user!.firebaseId,
                  );

              Navigator.of(context).pushNamed(
                Chat.routeName,
                arguments: ChatArgument(
                  serverUser: serverUser,
                  threadId: threadId,
                ),
              );
            },
            icon: Icon(
              Icons.message,
            ),
          ),
        ],
      ),
    );
  }
}
