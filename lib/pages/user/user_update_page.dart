import 'package:flutter/material.dart';
import 'package:varenya_mobile/utils/palette.util.dart';
import 'package:varenya_mobile/utils/responsive_config.util.dart';
import 'package:varenya_mobile/widgets/user/user_delete_tab.dart';
import 'package:varenya_mobile/widgets/user/user_email_update_tab.dart';
import 'package:varenya_mobile/widgets/user/user_password_update_tab.dart';
import 'package:varenya_mobile/widgets/user/user_profile_update_tab.dart';

class UserUpdatePage extends StatelessWidget {
  const UserUpdatePage({Key? key}) : super(key: key);

  static const routeName = "/user-update";

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black54,
          title: Text(
            'Update\nProfile',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.05,
            ),
          ),
          toolbarHeight: MediaQuery.of(context).size.height * 0.2,
          automaticallyImplyLeading: false,
          bottom: TabBar(
            indicatorColor: Palette.primary,
            tabs: [
              Tab(
                child: Text(
                  'User Details',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Email Details',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Password Details',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Delete Account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: responsiveConfig(
                context: context,
                large: MediaQuery.of(context).size.width * 0.25,
                medium: MediaQuery.of(context).size.width * 0.25,
                small: 0,
              ),
            ),
            child: TabBarView(
              children: [
                UserProfileUpdateTab(),
                UserEmailUpdateTab(),
                UserPasswordUpdateTab(),
                UserDeleteTab(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
