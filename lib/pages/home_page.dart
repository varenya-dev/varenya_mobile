import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/dtos/appointment/fetch_available_slots/fetch_available_slots.dto.dart';
import 'package:varenya_mobile/exceptions/server.exception.dart';
import 'package:varenya_mobile/notification_handler.dart';
import 'package:varenya_mobile/pages/appointment/appointment_list.page.dart';
import 'package:varenya_mobile/pages/auth/auth_page.dart';
import 'package:varenya_mobile/pages/chat/threads_page.dart';
import 'package:varenya_mobile/pages/doctor/doctor_list.page.dart';
import 'package:varenya_mobile/pages/user/user_update_page.dart';
import 'package:varenya_mobile/providers/user_provider.dart';
import 'package:varenya_mobile/services/alerts_service.dart';
import 'package:varenya_mobile/services/appointment.service.dart';
import 'package:varenya_mobile/services/auth_service.dart';
import 'package:varenya_mobile/services/chat_service.dart';
import 'package:varenya_mobile/services/doctor.service.dart';
import 'package:varenya_mobile/services/post.service.dart';
import 'package:varenya_mobile/services/user_service.dart';
import 'package:varenya_mobile/utils/snackbar.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  static const routeName = "/home";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final AuthService _authService;
  late final UserService _userService;
  late final ChatService _chatService;
  late final AlertsService _alertsService;
  late final AppointmentService _appointmentService;
  late final PostService _postService;

  @override
  void initState() {
    super.initState();

    this._authService = Provider.of<AuthService>(context, listen: false);
    this._userService = Provider.of<UserService>(context, listen: false);
    this._chatService = Provider.of<ChatService>(context, listen: false);
    this._alertsService = Provider.of<AlertsService>(context, listen: false);
    this._appointmentService =
        Provider.of<AppointmentService>(context, listen: false);
    this._postService = Provider.of<PostService>(context, listen: false);

    this._userService.generateAndSaveTokenToDatabase();

    FirebaseMessaging.instance.onTokenRefresh
        .listen(this._userService.saveTokenToDatabase);

    this
        ._alertsService
        .toggleSubscribeToSOSTopic(true)
        .then((_) => print('SOS TOPIC SUBSCRIBED'))
        .catchError((error) => print(error));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Varenya'),
      ),
      body: NotificationsHandler(
        child: Center(
          child: Column(
            children: [
              Consumer<UserProvider>(
                builder: (context, state, child) {
                  User user = state.user;
                  return Text(user.email!);
                },
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(UserUpdatePage.routeName);
                },
                child: Text('User Update'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(ThreadsPage.routeName);
                },
                child: Text('Threads'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await this._authService.logOut();
                  Navigator.of(context).pushNamed(AuthPage.routeName);
                },
                child: Text('Logout'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await this._chatService.openDummyThread();
                },
                child: Text('Dummy Chat'),
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await this._alertsService.sendSOSNotifications();
                  } on ServerException catch (error) {
                    displaySnackbar(
                      error.message,
                      context,
                    );
                  } catch (error) {
                    displaySnackbar(
                      "Something went wrong, please try again later.",
                      context,
                    );
                  }
                },
                child: Text('SOS Notification'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pushNamed(DoctorList.routeName);
                },
                child: Text('Doctor List'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pushNamed(AppointmentList.routeName);
                },
                child: Text('Appointments List'),
              ),
              ElevatedButton(
                onPressed: () async {
                  print(
                    await this._appointmentService.fetchAvailableSlots(
                          new FetchAvailableSlotsDto(
                            date: DateTime.now(),
                            doctorId: "d5635a62-4da3-420c-9771-723360ca46e7",
                          ),
                        ),
                  );
                },
                child: Text('Test Fetching available dates'),
              ),
              ElevatedButton(
                onPressed: () async {
                  print(
                    await this._postService.fetchPostsByCategory("bipolar"),
                  );
                },
                child: Text('Test Fetching posts'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
