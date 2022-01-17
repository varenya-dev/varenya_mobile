import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:varenya_mobile/utils/logger.util.dart';

class LocalNotificationsService {
  static final LocalNotificationsService _localNotificationsService =
      LocalNotificationsService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  factory LocalNotificationsService() {
    return _localNotificationsService;
  }

  LocalNotificationsService._internal();

  Future<void> initializeLocalNotifications() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: null,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: null,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: this.handleSelectNotification,
    );
  }

  Future<void> handleSelectNotification(String? payload) async {
    log.i("Notification Payload: $payload");
  }

  Future<NotificationAppLaunchDetails?> get notificationAppLaunchDetails =>
      this.flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  Future<void> instantNotification() async {
    var android = AndroidNotificationDetails(
      "id",
      "channel",
    );

    var ios = IOSNotificationDetails();

    var platform = new NotificationDetails(
      android: android,
      iOS: ios,
    );

    await this.flutterLocalNotificationsPlugin.show(
          0,
          "Demo instant notification",
          "Tap to do something",
          platform,
          payload: "instant",
        );
  }
}
