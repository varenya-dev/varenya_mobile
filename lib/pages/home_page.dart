import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/pages/auth/auth_page.dart';
import 'package:varenya_mobile/pages/user/user_update_page.dart';
import 'package:varenya_mobile/providers/user_provider.dart';
import 'package:varenya_mobile/services/auth_service.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  static const routeName = "/home";
  late AuthService _authService;

  @override
  Widget build(BuildContext context) {
    this._authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Varenya'),
      ),
      body: Center(
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
              onPressed: () async {
                await this._authService.logOut();
                Navigator.of(context).pushNamed(AuthPage.routeName);
              },
              child: Text('Logout'),
            )
          ],
        ),
      ),
    );
  }
}
