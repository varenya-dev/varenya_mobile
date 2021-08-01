import 'package:flutter/material.dart';
import 'package:varenya_mobile/pages/auth/auth_page.dart';
import 'package:varenya_mobile/pages/common/splash_page.dart';
import 'package:varenya_mobile/pages/home_page.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Varenya',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        SplashPage.routeName: (context) => SplashPage(),
        HomePage.routeName: (context) => HomePage(),
        AuthPage.routeName: (context) => AuthPage(),
      },
    );
  }
}
