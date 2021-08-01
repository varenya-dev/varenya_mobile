import 'dart:async';

import 'package:flutter/material.dart';
import 'package:varenya_mobile/pages/auth/auth_page.dart';
import 'package:varenya_mobile/pages/common/loading_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:varenya_mobile/pages/home_page.dart';

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
    // TODO: implement initState
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
          Navigator.of(context).pushReplacementNamed(HomePage.routeName);
        } else {
          Navigator.of(context).pushReplacementNamed(AuthPage.routeName);
        }
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    this._streamSubscription!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingPage();
  }
}
