import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:varenya_mobile/constants/emoji_mood.constant.dart';
import 'package:varenya_mobile/models/daily_progress_data/daily_progress_data.model.dart';
import 'package:varenya_mobile/models/daily_progress_data/question_answer/question_answer.model.dart';

class SingleProgress extends StatefulWidget {
  // Page Route Name.
  static const routeName = "/single-progress";

  @override
  State<SingleProgress> createState() => _SingleProgressState();
}

class _SingleProgressState extends State<SingleProgress> {
  // Daily Progress Data.
  DailyProgressData? dailyProgressData;

  @override
  Widget build(BuildContext context) {
    // Fetch Daily Progress Data from route arguments
    if (this.dailyProgressData == null) {
      this.dailyProgressData =
          ModalRoute.of(context)!.settings.arguments as DailyProgressData;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Progress Report for: ${DateFormat.yMMMd().add_jm().format(dailyProgressData!.createdAt)}",
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.04,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: this.dailyProgressData!.answers.length,
              itemBuilder: (BuildContext context, int index) {
                QuestionAnswer question =
                    this.dailyProgressData!.answers[index];

                return ListTile(
                  title: Text(question.question),
                  subtitle: Text('Answer: ${question.answer}'),
                );
              },
            ),
            ListTile(
              title: Text(
                  'Mood: ${EMOJIS[this.dailyProgressData!.moodRating - 1]}'),
            ),
          ],
        ),
      ),
    );
  }
}
