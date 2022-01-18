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
    return ListTile(
      title: Text(this.question.question),
      trailing: Wrap(
        children: [
          IconButton(
            onPressed: () {
              this.onEditQuestion(question);
            },
            icon: Icon(
              Icons.edit,
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
    );
  }
}
