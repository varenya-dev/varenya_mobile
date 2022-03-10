import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:varenya_mobile/constants/emoji_mood.constant.dart';
import 'package:varenya_mobile/models/daily_progress_data/daily_progress_data.model.dart';
import 'package:varenya_mobile/models/daily_progress_data/question_answer/question_answer.model.dart';
import 'package:varenya_mobile/widgets/daily_questionnaire/mood_view.widget.dart';

class PastProgressItem extends StatefulWidget {
  final DailyProgressData dailyProgressData;

  const PastProgressItem({
    Key? key,
    required this.dailyProgressData,
  }) : super(key: key);

  @override
  _PastProgressItemState createState() => _PastProgressItemState();
}

class _PastProgressItemState extends State<PastProgressItem> {
  bool display = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          this.display = true;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.1,
          vertical: MediaQuery.of(context).size.height * 0.01,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(
            15.0,
          ),
        ),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                ListTile(
                  title: Text(
                    'Mood score: ${this.widget.dailyProgressData.moodRating}',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    DateFormat.yMMMd().add_jm().format(
                          this.widget.dailyProgressData.createdAt,
                        ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: MoodView(
                    emojiPath: EMOJIS_IMG[
                        this.widget.dailyProgressData.moodRating - 1],
                  ),
                ),
              ],
            ),
            if (display)
              Column(
                children: [
                  Divider(),
                  ListView.builder(
                    itemCount: this.widget.dailyProgressData.answers.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      QuestionAnswer questionAnswer =
                          this.widget.dailyProgressData.answers[index];

                      return ListTile(
                        title: Text(
                          questionAnswer.question,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(questionAnswer.answer),
                      );
                    },
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        this.display = false;
                      });
                    },
                    icon: Icon(
                      Icons.arrow_drop_up,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
