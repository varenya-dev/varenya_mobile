import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/pages/auth/auth_page.dart';
import 'package:varenya_mobile/pages/chat/threads_page.dart';
import 'package:varenya_mobile/pages/user/user_update_page.dart';
import 'package:varenya_mobile/providers/user_provider.dart';
import 'package:varenya_mobile/services/auth_service.dart';
import 'package:varenya_mobile/services/user_service.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  static const routeName = "/home";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final AuthService _authService;

  late final UserService _userService;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this._authService = Provider.of<AuthService>(context, listen: false);
    this._userService = Provider.of<UserService>(context, listen: false);

    this._userService.updateUserPresence();

    this._userService.generateAndSaveTokenToDatabase();

    FirebaseMessaging.instance.onTokenRefresh
        .listen(this._userService.saveTokenToDatabase);
  }

  @override
  Widget build(BuildContext context) {
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
            )
          ],
        ),
      ),
    );
  }
}
