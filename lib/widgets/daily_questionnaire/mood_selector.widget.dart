import 'package:flutter/material.dart';
import 'package:varenya_mobile/widgets/daily_questionnaire/mood_indicator.widget.dart';

class MoodSelector extends StatefulWidget {
  final Function emitMood;

  MoodSelector({
    Key? key,
    required this.emitMood,
  }) : super(key: key);

  @override
  State<MoodSelector> createState() => _MoodSelectorState();
}

class _MoodSelectorState extends State<MoodSelector> {
  final List<String> emojis = ['😭', '😟', '😐', '😊', '😄'];
  int mood = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
              vertical: MediaQuery.of(context).size.height * 0.02,
            ),
            child: Text('How is your mood today?'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: this
                .emojis
                .map(
                  (emoji) => MoodIndicator(
                    onPress: () {
                      widget.emitMood(this.emojis.indexOf(emoji) + 1);
                      setState(() {
                        this.mood = this.emojis.indexOf(emoji) + 1;
                      });
                    },
                    emoji: emoji,
                    activated: this.emojis.indexOf(emoji) + 1 == mood,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
