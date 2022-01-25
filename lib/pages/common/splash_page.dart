import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/constants/notification_actions.constant.dart';
import 'package:varenya_mobile/pages/auth/auth_page.dart';
import 'package:varenya_mobile/pages/common/loading_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:varenya_mobile/pages/daily_questionnaire/questionnaire.page.dart';
import 'package:varenya_mobile/pages/home_page.dart';
import 'package:varenya_mobile/pages/user/user_update_page.dart';
import 'package:varenya_mobile/providers/notification_action.provider.dart';
import 'package:varenya_mobile/providers/user_provider.dart';
import 'package:varenya_mobile/utils/logger.util.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  static const routeName = "/";

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  StreamSubscription? _streamSubscription;

  @override
  void initState() {
    super.initState();

    setState(() {
      /*
       * Listen for logged in user using firebase auth changes.
       * If the user exists, route them to the Home Page.
       *
       * Otherwise, route them to Auth page.
       */
      this._streamSubscription =
          FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user != null) {
          Provider.of<UserProvider>(context, listen: false).user = user;

          log.i("Firebase User Signed In");

          // Fetch local notification action from global state.
          String action =
              Provider.of<NotificationActionProvider>(context, listen: false)
                  .action;

          log.i("Notification Action: $action");

          // Check what does the action requires the app to do.
          if (action == DO_NOTHING) {
            // Push to home page if no action needs to be taken.
            Navigator.of(context).pushReplacementNamed(HomePage.routeName);
          } else if (action == INSTANT_NOTIFICATION ||
              action == QUESTIONNAIRE_NOTIFICATION) {
            // Push to questionnaire page on questionnaire notification action.
            Navigator.of(context).pushReplacementNamed(Questionnaire.routeName);
          }
        } else {
          log.i("Firebase User Not Present");

          Navigator.of(context).pushReplacementNamed(AuthPage.routeName);
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    this._streamSubscription!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingPage();
  }
}
