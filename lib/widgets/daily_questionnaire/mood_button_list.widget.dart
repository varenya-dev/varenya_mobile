import 'package:flutter/material.dart';
import 'package:varenya_mobile/constants/emoji_mood.constant.dart';
import 'package:varenya_mobile/widgets/daily_questionnaire/mood_button.widget.dart';

class MoodButtonList extends StatelessWidget {
  final Function onPress;
  final int moodValue;

  const MoodButtonList({
    Key? key,
    required this.onPress,
    required this.moodValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: EMOJIS_IMG
          .map(
            (img) => MoodButton(
              emojiPath: img,
              onPress: () {
                onPress(EMOJIS_IMG.indexOf(img) + 1);
              },
              selected: (this.moodValue - 1) == EMOJIS_IMG.indexOf(img),
            ),
          )
          .toList(),
    );
  }
}
