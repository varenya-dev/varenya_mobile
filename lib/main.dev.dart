import 'package:flutter/material.dart';
import 'package:varenya_mobile/app.dart';
import 'package:varenya_mobile/constants/notification_actions.constant.dart';
import 'package:varenya_mobile/providers.dart';
import 'package:varenya_mobile/setup.dart';
import 'package:varenya_mobile/utils/logger.util.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/*
 * Main Method to launch the app.
 */
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String action = DO_NOTHING;
  action = await fullSetup();
  runApp(
    DevRoot(
      action: action,
    ),
  );
}

class DevRoot extends StatelessWidget {
  final String action;

  DevRoot({
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    log.i("Action Status: $action");

    return Providers(
      action: action,
      child: App(),
      apiUrl: kIsWeb ? "http://127.0.0.1:5000/v1/api" : "http://10.0.2.2:5000/v1/api",
      rawApiUrl: kIsWeb ? "127.0.0.1:5000" : "10.0.2.2:5000",
    );
  }
}
