import 'package:flutter/material.dart';
import 'package:varenya_mobile/pages/activity/activity.page.dart';
import 'package:varenya_mobile/pages/appointment/appointment_list.page.dart';
import 'package:varenya_mobile/pages/appointment/appointment_slots.page.dart';
import 'package:varenya_mobile/pages/auth/auth_page.dart';
import 'package:varenya_mobile/pages/auth/login_page.dart';
import 'package:varenya_mobile/pages/auth/register_page.dart';
import 'package:varenya_mobile/pages/chat/chat.page.dart';
import 'package:varenya_mobile/pages/chat/threads.page.dart';
import 'package:varenya_mobile/pages/common/splash_page.dart';
import 'package:varenya_mobile/pages/daily_questionnaire/past_progress.page.dart';
import 'package:varenya_mobile/pages/daily_questionnaire/question.page.dart';
import 'package:varenya_mobile/pages/daily_questionnaire/questionnaire.page.dart';
import 'package:varenya_mobile/pages/daily_questionnaire/single_progress.page.dart';
import 'package:varenya_mobile/pages/doctor/doctor_list.page.dart';
import 'package:varenya_mobile/pages/home_page.dart';
import 'package:varenya_mobile/pages/post/categorized_posts.page.dart';
import 'package:varenya_mobile/pages/post/new_post.page.dart';
import 'package:varenya_mobile/pages/post/post.page.dart';
import 'package:varenya_mobile/pages/post/update_post.page.dart';
import 'package:varenya_mobile/pages/records/records.page.dart';
import 'package:varenya_mobile/pages/user/user_update_page.dart';
import 'package:varenya_mobile/utils/custom_scroll_behaviour.util.dart';
import 'package:varenya_mobile/utils/generate_swatch.util.dart';
import 'package:varenya_mobile/utils/palette.util.dart';

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey(debugLabel: "Main Navigator");

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: CustomScrollBehaviour(),
      navigatorKey: this.navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Varenya',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: generateMaterialColor(
          Palette.primary,
        ),
        primaryColor: Palette.primary,
        scaffoldBackgroundColor: Color(0xff1f1d24),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Colors.transparent,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              Palette.primary,
            ),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(
            0XFF282A2E,
          ),
        ),
        textTheme: TextTheme(
          subtitle1: TextStyle(
            color: Colors.white.withOpacity(
              0.44,
            ),
          ),
        ),
        cardTheme: CardTheme(
          color: Palette.secondary,
        ),
      ),
      routes: {
        HomePage.routeName: (context) => HomePage(),
        AuthPage.routeName: (context) => AuthPage(),
        LoginPage.routeName: (context) => LoginPage(),
        RegisterPage.routeName: (context) => RegisterPage(),
        UserUpdatePage.routeName: (context) => UserUpdatePage(),
        Threads.routeName: (context) => Threads(),
        Chat.routeName: (context) => Chat(),
        DoctorList.routeName: (context) => DoctorList(),
        AppointmentList.routeName: (context) => AppointmentList(),
        AppointmentSlots.routeName: (context) => AppointmentSlots(),
        CategorizedPosts.routeName: (context) => CategorizedPosts(),
        NewPost.routeName: (context) => NewPost(),
        UpdatePost.routeName: (context) => UpdatePost(),
        Post.routeName: (context) => Post(),
        Activity.routeName: (context) => Activity(),
        Question.routeName: (context) => Question(),
        Questionnaire.routeName: (context) => Questionnaire(),
        PastProgress.routeName: (context) => PastProgress(),
        SingleProgress.routeName: (context) => SingleProgress(),
        Records.routeName: (context) => Records(),
      },
      home: SplashPage(),
    );
  }
}
