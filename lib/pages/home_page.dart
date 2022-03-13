import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/exceptions/server.exception.dart';
import 'package:varenya_mobile/notification_handler.dart';
import 'package:varenya_mobile/pages/activity/activity.page.dart';
import 'package:varenya_mobile/pages/appointment/appointment_list.page.dart';
import 'package:varenya_mobile/pages/auth/auth_page.dart';
import 'package:varenya_mobile/pages/chat/threads.page.dart';
import 'package:varenya_mobile/pages/daily_questionnaire/past_progress.page.dart';
import 'package:varenya_mobile/pages/daily_questionnaire/question.page.dart';
import 'package:varenya_mobile/pages/daily_questionnaire/questionnaire.page.dart';
import 'package:varenya_mobile/pages/doctor/doctor_list.page.dart';
import 'package:varenya_mobile/pages/post/categorized_posts.page.dart';
import 'package:varenya_mobile/pages/records/records.page.dart';
import 'package:varenya_mobile/pages/user/user_update_page.dart';
import 'package:varenya_mobile/providers/user_provider.dart';
import 'package:varenya_mobile/services/alerts_service.dart';
import 'package:varenya_mobile/services/auth_service.dart';
import 'package:varenya_mobile/services/chat.service.dart';
import 'package:varenya_mobile/services/local_notifications.service.dart';
import 'package:varenya_mobile/services/user_service.dart';
import 'package:varenya_mobile/utils/check_connectivity.util.dart';
import 'package:varenya_mobile/utils/logger.util.dart';
import 'package:varenya_mobile/utils/snackbar.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:varenya_mobile/widgets/common/home_bar.widget.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  static const routeName = "/home";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final UserService _userService;
  late final AlertsService _alertsService;

  final LocalNotificationsService localNotificationsService =
      LocalNotificationsService();

  @override
  void initState() {
    super.initState();

    this._userService = Provider.of<UserService>(context, listen: false);
    this._alertsService = Provider.of<AlertsService>(context, listen: false);

    if (!kIsWeb)
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

  final List<Widget> screens = [
    Activity(),
    CategorizedPosts(),
    DoctorList(),
    Threads(),
    Question(),
    AppointmentList(),
  ];

  int screen = 0;

  void emitScreen(int screenNumber) {
    setState(() {
      this.screen = screenNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: HomeBar(
        screen: screen,
        emitScreen: this.emitScreen,
      ),
      body: NotificationsHandler(
        child: screens[screen],
      ),
    );
  }
}
