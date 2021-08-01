import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:varenya_mobile/dtos/auth/login_account_dto/login_account_dto.dart';
import 'package:varenya_mobile/services/auth_service.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  static const routeName = "/auth";

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  AuthService authService = new AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Login'),
            TextButton(
              onPressed: () async {
                await this.authService.loginWithEmailAndPassword(
                      LoginAccountDto.fromJson(
                        {
                          'emailAddress': 'varun@google.com',
                          'password': 'varun123'
                        },
                      ),
                    );
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
    ;
  }
}
