import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
import 'package:varenya_mobile/services/post.service.dart';
import 'package:varenya_mobile/services/records.service.dart';
import 'package:varenya_mobile/services/user_service.dart';

class Providers extends StatelessWidget {
  final Widget child;
  final String action;
  final String apiUrl;
  final String rawApiUrl;

  const Providers({
    Key? key,
    required this.child,
    required this.action,
    required this.apiUrl,
    required this.rawApiUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          create: (context) => AuthService(
            apiUrl: apiUrl,
            rawApiUrl: rawApiUrl,
          ),
        ),
        Provider<UserService>(
          create: (context) => UserService(
            apiUrl: apiUrl,
            rawApiUrl: rawApiUrl,
          ),
        ),
        Provider<ChatService>(
          create: (context) => ChatService(
            apiUrl: apiUrl,
            rawApiUrl: rawApiUrl,
          ),
        ),
        Provider<AlertsService>(
          create: (context) => AlertsService(
            apiUrl: apiUrl,
            rawApiUrl: rawApiUrl,
          ),
        ),
        Provider<DoctorService>(
          create: (context) => DoctorService(
            apiUrl: apiUrl,
            rawApiUrl: rawApiUrl,
          ),
        ),
        Provider<AppointmentService>(
          create: (context) => AppointmentService(
            apiUrl: apiUrl,
            rawApiUrl: rawApiUrl,
          ),
        ),
        Provider<PostService>(
          create: (context) => PostService(
            apiUrl: apiUrl,
            rawApiUrl: rawApiUrl,
          ),
        ),
        Provider<CommentsService>(
          create: (context) => CommentsService(
            apiUrl: apiUrl,
            rawApiUrl: rawApiUrl,
          ),
        ),
        Provider<ActivityService>(
          create: (context) => ActivityService(
            apiUrl: apiUrl,
            rawApiUrl: rawApiUrl,
          ),
        ),
        Provider<DailyQuestionnaireService>(
          create: (context) => DailyQuestionnaireService(),
        ),
        Provider<RecordsService>(
          create: (context) => RecordsService(
            apiUrl: apiUrl,
            rawApiUrl: rawApiUrl,
          ),
        ),
      ],
      child: child,
    );
  }
}
