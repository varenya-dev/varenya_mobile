import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/exceptions/server.exception.dart';
import 'package:varenya_mobile/notification_handler.dart';
import 'package:varenya_mobile/pages/appointment/appointment_list.page.dart';
import 'package:varenya_mobile/pages/auth/auth_page.dart';
import 'package:varenya_mobile/pages/chat/threads_page.dart';
import 'package:varenya_mobile/pages/doctor/doctor_list.page.dart';
import 'package:varenya_mobile/pages/post/categorized_posts.page.dart';
import 'package:varenya_mobile/pages/post/new_post.page.dart';
import 'package:varenya_mobile/pages/post/new_posts.page.dart';
import 'package:varenya_mobile/pages/user/user_update_page.dart';
import 'package:varenya_mobile/providers/user_provider.dart';
import 'package:varenya_mobile/services/alerts_service.dart';
import 'package:varenya_mobile/services/auth_service.dart';
import 'package:varenya_mobile/services/chat_service.dart';
import 'package:varenya_mobile/services/user_service.dart';
import 'package:varenya_mobile/utils/check_connectivity.util.dart';
import 'package:varenya_mobile/utils/logger.util.dart';
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

  @override
  void initState() {
    super.initState();

    this._authService = Provider.of<AuthService>(context, listen: false);
    this._userService = Provider.of<UserService>(context, listen: false);
    this._chatService = Provider.of<ChatService>(context, listen: false);
    this._alertsService = Provider.of<AlertsService>(context, listen: false);

    checkConnectivity().then((value) {
      if (value) {
        this._userService.generateAndSaveTokenToDatabase();
        FirebaseMessaging.instance.onTokenRefresh
            .listen(this._userService.saveTokenToDatabase);

        this
            ._alertsService
            .toggleSubscribeToSOSTopic(true)
            .then((_) => log.i("SOS Topic Subscribed"))
            .catchError((error) => print(error));
      } else {
        log.i(
            "Device offline, suspending FCM Token Generation and Topic Subscription");
      }
    }).catchError((error, stackTrace) {
      log.e("HomePage Error", error, stackTrace);
    });
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
                  Navigator.of(context).pushNamed(NewPosts.routeName);
                },
                child: Text('New Posts'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pushNamed(CategorizedPosts.routeName);
                },
                child: Text('Categorized Posts'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pushNamed(NewPost.routeName);
                },
                child: Text('New Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
