import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:varenya_mobile/constants/notification_actions.constant.dart';
import 'package:varenya_mobile/utils/logger.util.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

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
    tz.initializeTimeZones();

    tz.setLocalLocation(
      tz.getLocation(
        "Asia/Colombo",
      ),
    );

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
          "Time for you check in!",
          "How was your day?",
          platform,
          payload: INSTANT_NOTIFICATION,
        );
  }

  Future scheduledNotification(DateTime dateTime) async {
    var android = AndroidNotificationDetails(
      "id",
      "channel",
    );

    var notificationDetails = new NotificationDetails(android: android);

    await this.flutterLocalNotificationsPlugin.zonedSchedule(
          0,
          "Time for you check in!",
          "How was your day?",
          tz.TZDateTime.from(
            dateTime,
            tz.getLocation(
              "Asia/Colombo",
            ),
          ),
          notificationDetails,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          androidAllowWhileIdle: true,
          payload: QUESTIONNAIRE_NOTIFICATION,
          matchDateTimeComponents: DateTimeComponents.time,
        );
  }

  Future<void> cancelNotification() async {
    await this.flutterLocalNotificationsPlugin.cancelAll();
  }
}
