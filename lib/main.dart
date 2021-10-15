import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:varenya_mobile/app.dart';
import 'package:varenya_mobile/pages/common/loading_page.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/providers/user_provider.dart';
import 'package:varenya_mobile/services/auth_service.dart';
import 'package:varenya_mobile/services/chat_service.dart';
import 'package:varenya_mobile/services/user_service.dart';

const AndroidNotificationChannel channel = const AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Channel',
  importance: Importance.high,
  playSound: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    new FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  Map<String, dynamic> data = message.data;
  String userNameSent = json.decode(data['owner'])['displayName'];

  flutterLocalNotificationsPlugin.show(
    01,
    'New Message!',
    '$userNameSent sent you a new message',
    NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.name,
        color: Colors.blue,
        playSound: true,
        icon: '@mipmap/launcher_icon',
      ),
    ),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print("FCM STATUS: ${settings.authorizationStatus}");

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen(_firebaseMessagingBackgroundHandler);

  runApp(Root());
}

class Root extends StatelessWidget {
  final Future<FirebaseApp> _firebaseInitialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: this._firebaseInitialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<UserProvider>(
                create: (context) => UserProvider(),
              ),
              Provider<AuthService>(
                create: (context) => AuthService(),
              ),
              Provider<UserService>(
                create: (context) => UserService(),
              ),
              Provider<ChatService>(
                create: (context) => ChatService(),
              ),
            ],
            child: App(),
          );
        }

        return LoadingPage();
      },
    );
  }
}
