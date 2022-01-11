import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:varenya_mobile/app.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/constants/hive_boxes.constant.dart';
import 'package:varenya_mobile/enum/post_type.enum.dart';
import 'package:varenya_mobile/enum/roles.enum.dart';
import 'package:varenya_mobile/models/appointments/appointment/appointment.model.dart';
import 'package:varenya_mobile/models/doctor/doctor.model.dart';
import 'package:varenya_mobile/models/post/post.model.dart';
import 'package:varenya_mobile/models/post/post_category/post_category.model.dart';
import 'package:varenya_mobile/models/post/post_image/post_image.model.dart';
import 'package:varenya_mobile/models/specialization/specialization.model.dart';
import 'package:varenya_mobile/models/user/random_name/random_name.model.dart';
import 'package:varenya_mobile/models/user/server_user.model.dart';
import 'package:varenya_mobile/providers/user_provider.dart';
import 'package:varenya_mobile/services/alerts_service.dart';
import 'package:varenya_mobile/services/appointment.service.dart';
import 'package:varenya_mobile/services/auth_service.dart';
import 'package:varenya_mobile/services/chat_service.dart';
import 'package:varenya_mobile/services/comments.service.dart';
import 'package:varenya_mobile/services/doctor.service.dart';
import 'package:varenya_mobile/services/post.service.dart';
import 'package:varenya_mobile/services/user_service.dart';
import 'package:varenya_mobile/utils/logger.util.dart';
import 'package:hive/hive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  log.i("Firebase and Hive Initializing");

  await Firebase.initializeApp();
  await Hive.initFlutter();

  log.i("Firebase and Hive Initialized");

  log.i("Registering Hive Adapters");

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

  log.i("Registered Hive Adapters");

  log.i("Opening Hive Boxes");

  await Hive.openBox<List<dynamic>>(VARENYA_DOCTORS_BOX);
  await Hive.openBox<List<dynamic>>(VARENYA_POSTS_BOX);
  await Hive.openBox<List<dynamic>>(VARENYA_APPOINTMENT_BOX);
  await Hive.openBox<List<dynamic>>(VARENYA_SPECIALIZATION_BOX);
  await Hive.openBox<List<dynamic>>(VARENYA_JOB_BOX);

  log.i("Opened Hive Boxes");

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
  log.i("FCM Authorization Status: ${settings.authorizationStatus}");

  runApp(Root());
}

class Root extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
        )
      ],
      child: App(),
    );
  }
}
