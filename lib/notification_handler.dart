import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:varenya_mobile/pages/chat/chat_page.dart';

class NotificationsHandler extends StatefulWidget {
  final Widget child;

  const NotificationsHandler({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  _NotificationsHandlerState createState() => _NotificationsHandlerState();
}

class _NotificationsHandlerState extends State<NotificationsHandler> {
  late final FirebaseMessaging _firebaseMessaging;

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await this._firebaseMessaging.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  Future<void> _handleMessage(RemoteMessage message) async {
    print("MESSAGE DATA: ${message.data}");
    if (message.data['type'] == 'chat') {
      Navigator.pushNamed(
        context,
        ChatPage.routeName,
        arguments: message.data['thread'],
      );
    }
  }

  @override
  void initState() {
    super.initState();

    this._firebaseMessaging = FirebaseMessaging.instance;

    setupInteractedMessage();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
