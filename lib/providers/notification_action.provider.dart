import 'package:flutter/foundation.dart';
import 'package:varenya_mobile/constants/notification_actions.constant.dart';

class NotificationActionProvider extends ChangeNotifier {
  String action = DO_NOTHING;

  NotificationActionProvider({
    required this.action,
  });
}
