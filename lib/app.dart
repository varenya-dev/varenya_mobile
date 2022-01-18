import 'package:flutter/material.dart';
import 'package:varenya_mobile/pages/activity/activity.page.dart';
import 'package:varenya_mobile/pages/appointment/appointment_list.page.dart';
import 'package:varenya_mobile/pages/appointment/appointment_slots.page.dart';
import 'package:varenya_mobile/pages/auth/auth_page.dart';
import 'package:varenya_mobile/pages/auth/login_page.dart';
import 'package:varenya_mobile/pages/auth/register_page.dart';
import 'package:varenya_mobile/pages/chat/chat_page.dart';
import 'package:varenya_mobile/pages/chat/threads_page.dart';
import 'package:varenya_mobile/pages/common/splash_page.dart';
import 'package:varenya_mobile/pages/daily_questionnaire/question.page.dart';
import 'package:varenya_mobile/pages/daily_questionnaire/questionnaire.page.dart';
import 'package:varenya_mobile/pages/doctor/doctor_details.page.dart';
import 'package:varenya_mobile/pages/doctor/doctor_list.page.dart';
import 'package:varenya_mobile/pages/home_page.dart';
import 'package:varenya_mobile/pages/post/categorized_posts.page.dart';
import 'package:varenya_mobile/pages/post/new_post.page.dart';
import 'package:varenya_mobile/pages/post/new_posts.page.dart';
import 'package:varenya_mobile/pages/post/post.page.dart';
import 'package:varenya_mobile/pages/post/update_post.page.dart';
import 'package:varenya_mobile/pages/user/user_update_page.dart';

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey(debugLabel: "Main Navigator");

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: this.navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Varenya',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.yellow,
      ),
      routes: {
        HomePage.routeName: (context) => HomePage(),
        AuthPage.routeName: (context) => AuthPage(),
        LoginPage.routeName: (context) => LoginPage(),
        RegisterPage.routeName: (context) => RegisterPage(),
        UserUpdatePage.routeName: (context) => UserUpdatePage(),
        ThreadsPage.routeName: (context) => ThreadsPage(),
        ChatPage.routeName: (context) => ChatPage(),
        DoctorList.routeName: (context) => DoctorList(),
        DoctorDetails.routeName: (context) => DoctorDetails(),
        AppointmentList.routeName: (context) => AppointmentList(),
        AppointmentSlots.routeName: (context) => AppointmentSlots(),
        NewPosts.routeName: (context) => NewPosts(),
        CategorizedPosts.routeName: (context) => CategorizedPosts(),
        NewPost.routeName: (context) => NewPost(),
        UpdatePost.routeName: (context) => UpdatePost(),
        Post.routeName: (context) => Post(),
        Activity.routeName: (context) => Activity(),
        Question.routeName: (context) => Question(),
        Questionnaire.routeName: (context) => Questionnaire(),
      },
      home: SplashPage(),
    );
  }
}
