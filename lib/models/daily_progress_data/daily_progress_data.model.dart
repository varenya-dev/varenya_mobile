import 'package:hive/hive.dart';
import 'package:varenya_mobile/models/daily_progress_data/question_answer/question_answer.model.dart';

part 'daily_progress_data.model.g.dart';

@HiveType(typeId: 13)
class DailyProgressData {
  @HiveField(0, defaultValue: [])
  final List<QuestionAnswer> answers;

  @HiveField(1, defaultValue: 0)
  final int moodRating;

  DailyProgressData({
    required this.answers,
    required this.moodRating,
  });
}
