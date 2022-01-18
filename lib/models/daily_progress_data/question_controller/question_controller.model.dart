import 'package:flutter/cupertino.dart';
import 'package:varenya_mobile/models/daily_progress_data/question_answer/question_answer.model.dart';

class QuestionController {
  final QuestionAnswer question;
  final TextEditingController textEditingController;

  QuestionController({
    required this.question,
    required this.textEditingController,
  });
}
