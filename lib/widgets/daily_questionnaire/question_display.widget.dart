import 'package:flutter/material.dart';
import 'package:varenya_mobile/models/daily_progress_data/question_answer/question_answer.model.dart';

class QuestionDisplay extends StatelessWidget {
  final QuestionAnswer question;
  final Function onEditQuestion;
  final Function onDeleteQuestion;

  const QuestionDisplay({
    Key? key,
    required this.question,
    required this.onEditQuestion,
    required this.onDeleteQuestion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        this.onEditQuestion(question);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(
            15.0,
          ),
        ),
        margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.01,
          horizontal: MediaQuery.of(context).size.width * 0.05,
        ),
        padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.02,
          horizontal: MediaQuery.of(context).size.width * 0.1,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Text(
                this.question.question,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.025,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                this.onDeleteQuestion(question);
              },
              icon: Icon(
                Icons.delete,
              ),
            )
          ],
        ),
      ),
    );
  }
}
