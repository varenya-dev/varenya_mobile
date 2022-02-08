import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:varenya_mobile/app.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/constants/hive_boxes.constant.dart';
import 'package:varenya_mobile/constants/notification_actions.constant.dart';
import 'package:varenya_mobile/enum/post_type.enum.dart';
import 'package:varenya_mobile/enum/roles.enum.dart';
import 'package:varenya_mobile/models/activity/activity.model.dart';
import 'package:varenya_mobile/models/appointments/appointment/appointment.model.dart';
import 'package:varenya_mobile/models/daily_progress_data/daily_progress_data.model.dart';
import 'package:varenya_mobile/models/daily_progress_data/question_answer/question_answer.model.dart';
import 'package:varenya_mobile/models/doctor/doctor.model.dart';
import 'package:varenya_mobile/models/post/post.model.dart';
import 'package:varenya_mobile/models/post/post_category/post_category.model.dart';
import 'package:varenya_mobile/models/post/post_image/post_image.model.dart';
import 'package:varenya_mobile/models/specialization/specialization.model.dart';
import 'package:varenya_mobile/models/user/random_name/random_name.model.dart';
import 'package:varenya_mobile/models/user/server_user.model.dart';
import 'package:varenya_mobile/providers/notification_action.provider.dart';
import 'package:varenya_mobile/providers/user_provider.dart';
import 'package:varenya_mobile/services/activity.service.dart';
import 'package:varenya_mobile/services/alerts_service.dart';
import 'package:varenya_mobile/services/appointment.service.dart';
import 'package:varenya_mobile/services/auth_service.dart';
import 'package:varenya_mobile/services/chat.service.dart';
import 'package:varenya_mobile/services/comments.service.dart';
import 'package:varenya_mobile/services/daily_questionnaire.service.dart';
import 'package:varenya_mobile/services/doctor.service.dart';
import 'package:varenya_mobile/services/local_notifications.service.dart';
import 'package:varenya_mobile/services/post.service.dart';
import 'package:varenya_mobile/services/user_service.dart';
import 'package:varenya_mobile/utils/logger.util.dart';
import 'package:hive/hive.dart';

/*
 * Set up FCM service for server sent notifications.
 */
Future<void> setupFCM() async {
  // Initializing Firebase Notification settings.
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

  // Check for authorization status
  log.i("FCM Authorization Status: ${settings.authorizationStatus}");
}

/*
 * Register and open HiveDB boxes for offline storage of data.
 */
Future<void> openHiveBoxes() async {
  log.i("Opening Hive Boxes");

  // Register and open hive boxes.
  await Hive.openBox<List<dynamic>>(VARENYA_DOCTORS_BOX);
  await Hive.openBox<List<dynamic>>(VARENYA_POSTS_BOX);
  await Hive.openBox<List<dynamic>>(VARENYA_POST_CATEGORY_BOX);
  await Hive.openBox<List<dynamic>>(VARENYA_APPOINTMENT_BOX);
  await Hive.openBox<List<dynamic>>(VARENYA_SPECIALIZATION_BOX);
  await Hive.openBox<List<dynamic>>(VARENYA_JOB_BOX);
  await Hive.openBox<List<dynamic>>(VARENYA_ACTIVITY_BOX);
  await Hive.openBox<List<dynamic>>(VARENYA_PROGRESS_BOX);
  await Hive.openBox<List<dynamic>>(VARENYA_QUESTION_BOX);

  log.i("Opened Hive Boxes");
}

/*
 * Register all HiveDB adapters for all models.
 */
void registerHiveAdapters() {
  log.i("Registering Hive Adapters");

  // Registering all model hive adapters.
  Hive.registerAdapter<Specialization>(new SpecializationAdapter());
  Hive.registerAdapter<Doctor>(new DoctorAdapter());
  Hive.registerAdapter<RandomName>(new RandomNameAdapter());
  Hive.registerAdapter<Roles>(new RolesAdapter());
  Hive.registerAdapter<ServerUser>(new ServerUserAdapter());
  Hive.registerAdapter<Appointment>(new AppointmentAdapter());
  Hive.registerAdapter<PostCategory>(new PostCategoryAdapter());
  Hive.registerAdapter<PostImage>(new PostImageAdapter());
  Hive.registerAdapter<PostType>(new PostTypeAdapter());
  Hive.registerAdapter<Post>(new PostAdapter());
  Hive.registerAdapter<Activity>(new ActivityAdapter());
  Hive.registerAdapter<QuestionAnswer>(new QuestionAnswerAdapter());
  Hive.registerAdapter<DailyProgressData>(new DailyProgressDataAdapter());

  log.i("Registered Hive Adapters");
}

/*
 * Register and start the local notification service to send
 * and check when a local notification wakes up the app.
 */
Future<LocalNotificationsService> setupLocalNotifications() async {
  log.i("Initializing Local Notifications");

  // Creating a local notification service singleton.
  LocalNotificationsService localNotificationsService =
      LocalNotificationsService();

  // Initializing local notifications.
  await localNotificationsService.initializeLocalNotifications();
  log.i("Initialized Local Notifications");

  // Return the service object.
  return localNotificationsService;
}

/*
 * Method to check if the app was launched due to
 * a local notification.
 * @param localNotificationsService Local Notification Service Singleton
 * @param action Default action to perform.
 */
Future<String> checkNotificationLaunchedApp(
  LocalNotificationsService localNotificationsService,
  String action,
) async {
  log.i("Checking Notification Triggered App Launch");

  // Getting app launch details.
  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
      await localNotificationsService.notificationAppLaunchDetails;

  // Check if notification launched the app.
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    log.i("Notification Triggered App Launch: TRUE");

    // Set action as payload from the notification.
    action = notificationAppLaunchDetails!.payload!;
  } else {
    log.i("Notification Triggered App Launch: FALSE");
  }

  // Return action to perform.
  return action;
}

/*
 * Main Method to launch the app.
 */
void main() async {
  // STEP 1: Ensure Widget Binding.
  WidgetsFlutterBinding.ensureInitialized();

  log.i("Firebase and Hive Initializing");

  // STEP 2: Initialize Firebase and HiveDB.
  await Firebase.initializeApp();
  await Hive.initFlutter();

  log.i("Firebase and Hive Initialized");

  // STEP 3: Register all HiveDB Adapters.
  registerHiveAdapters();

  // STEP 4: Open up all required HiveDB boxes.
  await openHiveBoxes();

  // STEP 5: Setup Firebase Messaging and Notifications.
  await setupFCM();

  // STEP 6: Initialize local notification service.
  LocalNotificationsService localNotificationsService =
      await setupLocalNotifications();

  String action = DO_NOTHING;

  // STEP 7: Check if app was launched by a local notification.
  action = await checkNotificationLaunchedApp(
    localNotificationsService,
    action,
  );

  // STEP 8: Run the app.
  runApp(
    Root(
      action: action,
    ),
  );
}

class Root extends StatelessWidget {
  final String action;

  Root({
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    log.i("Action Status: $action");

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider<NotificationActionProvider>(
          create: (context) => NotificationActionProvider(
            action: action,
          ),
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
        Provider<AlertsService>(
          create: (context) => AlertsService(),
        ),
        Provider<DoctorService>(
          create: (context) => DoctorService(),
        ),
        Provider<AppointmentService>(
          create: (context) => AppointmentService(),
        ),
        Provider<PostService>(
          create: (context) => PostService(),
        ),
        Provider<CommentsService>(
          create: (context) => CommentsService(),
        ),
        Provider<ActivityService>(
          create: (context) => ActivityService(),
        ),
        Provider<DailyQuestionnaireService>(
          create: (context) => DailyQuestionnaireService(),
        ),
      ],
      child: App(),
    );
  }
}
