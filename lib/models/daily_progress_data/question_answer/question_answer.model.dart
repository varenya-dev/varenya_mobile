import 'package:hive/hive.dart';

part 'question_answer.model.g.dart';

@HiveType(typeId: 12)
class QuestionAnswer {
  @HiveField(0, defaultValue: '')
  final String id;

  @HiveField(1, defaultValue: '')
  final String question;

  @HiveField(2, defaultValue: '')
  final String answer;

  QuestionAnswer({
    required this.id,
    required this.question,
    required this.answer,
  });
}
