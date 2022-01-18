import 'package:flutter/material.dart';
import 'package:varenya_mobile/models/daily_progress_data/question_answer/question_answer.model.dart';

class QuestionDisplay extends StatelessWidget {
  final QuestionAnswer question;
  final VoidCallback onEditQuestion;
  final VoidCallback onDeleteQuestion;

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
      leading: Wrap(
        children: [
          IconButton(
            onPressed: this.onEditQuestion,
            icon: Icon(
              Icons.edit,
            ),
          ),
          IconButton(
            onPressed: this.onDeleteQuestion,
            icon: Icon(
              Icons.delete,
            ),
          )
        ],
      ),
    );
  }
}
