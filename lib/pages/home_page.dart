import 'package:flutter/material.dart';
import 'package:varenya_mobile/services/auth_service.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  static const routeName = "/home";
  final AuthService authService = new AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Varenya'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Varenya'),
          onPressed: authService.logOut,
        ),
      ),
    );
  }
}
