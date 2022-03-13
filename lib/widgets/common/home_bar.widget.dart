import 'package:flutter/material.dart';
import 'package:varenya_mobile/utils/palette.util.dart';
import 'package:varenya_mobile/widgets/common/home_bar_button.widget.dart';

class HomeBar extends StatelessWidget {
  final int screen;
  final Function emitScreen;

  const HomeBar({
    Key? key,
    required this.screen,
    required this.emitScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.03,
        left: MediaQuery.of(context).size.width * 0.03,
        right: MediaQuery.of(context).size.width * 0.03,
        bottom: MediaQuery.of(context).size.height * 0.02,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          12.0,
        ),
      ),
      height: MediaQuery.of(context).size.height * 0.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          HomeBarButton(
            icon: Icon(
              Icons.home,
              color: this.screen == 0 ? Palette.primary : Palette.secondary,
              size: MediaQuery.of(context).size.width * 0.12,
            ),
            text: 'Home',
            onTap: () {
              this.emitScreen(0);
            },
          ),
          HomeBarButton(
            icon: Icon(
              Icons.photo,
              color: this.screen == 1 ? Palette.primary : Palette.secondary,
              size: MediaQuery.of(context).size.width * 0.12,
            ),
            text: 'Posts',
            onTap: () {
              this.emitScreen(1);
            },
          ),
          HomeBarButton(
            icon: Icon(
              Icons.person_pin_rounded,
              color: this.screen == 2 ? Palette.primary : Palette.secondary,
              size: MediaQuery.of(context).size.width * 0.12,
            ),
            text: 'Doctors',
            onTap: () {
              this.emitScreen(2);
            },
          ),
          HomeBarButton(
            icon: Icon(
              Icons.chat,
              color: this.screen == 3 ? Palette.primary : Palette.secondary,
              size: MediaQuery.of(context).size.width * 0.12,
            ),
            text: 'Chat',
            onTap: () {
              this.emitScreen(3);
            },
          ),
          HomeBarButton(
            icon: Icon(
              Icons.question_answer_outlined,
              color: this.screen == 4 ? Palette.primary : Palette.secondary,
              size: MediaQuery.of(context).size.width * 0.12,
            ),
            text: 'Questions',
            onTap: () {
              this.emitScreen(4);
            },
          ),
          HomeBarButton(
            icon: Icon(
              Icons.history,
              color: this.screen == 5 ? Palette.primary : Palette.secondary,
              size: MediaQuery.of(context).size.width * 0.12,
            ),
            text: 'History',
            onTap: () {
              this.emitScreen(5);
            },
          ),
        ],
      ),
    );
  }
}
