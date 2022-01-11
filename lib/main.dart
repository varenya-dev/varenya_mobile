import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:varenya_mobile/app.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/constants/hive_boxes.constant.dart';
import 'package:varenya_mobile/models/post/post_category/post_category.model.dart';
import 'package:varenya_mobile/models/post/post_image/post_image.model.dart';
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

  await Firebase.initializeApp();
  await Hive.initFlutter();

  Hive.registerAdapter<PostCategory>(new PostCategoryAdapter());
  Hive.registerAdapter<PostImage>(new PostImageAdapter());

  await Hive.openBox(VARENYA_DOCTORS_BOX);
  await Hive.openBox(VARENYA_POSTS_BOX);

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
