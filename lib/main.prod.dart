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
    ProdRoot(
      action: action,
    ),
  );
}

class ProdRoot extends StatelessWidget {
  final String action;

  ProdRoot({
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    log.i("Action Status: $action");

    return Providers(
      action: action,
      child: App(),
      apiUrl: kIsWeb ? "https://varenya-production.herokuapp.com/v1/api" : "https://varenya-production.herokuapp.com/v1/api",
      rawApiUrl: kIsWeb ? "varenya-production.herokuapp.com" : "varenya-production.herokuapp.com",
    );
  }
}
