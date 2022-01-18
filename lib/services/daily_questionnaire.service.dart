import 'package:hive/hive.dart';
import 'package:varenya_mobile/constants/hive_boxes.constant.dart';
import 'package:varenya_mobile/models/daily_progress_data/daily_progress_data.model.dart';
import 'package:varenya_mobile/models/daily_progress_data/question_answer/question_answer.model.dart';

class DailyQuestionnaireService {
  final Box<List<dynamic>> _progressBox = Hive.box(VARENYA_PROGRESS_BOX);
  final Box<List<dynamic>> _questionBox = Hive.box(VARENYA_QUESTION_BOX);

  List<DailyProgressData> fetchDailyProgressData() {
    return this._progressBox.get(VARENYA_PROGRESS_LIST,
        defaultValue: [])!.cast<DailyProgressData>();
  }

  void saveQuestions(List<QuestionAnswer> questions) {
    this._questionBox.put(VARENYA_QUESTION_LIST, questions);
  }

  void saveProgressData(DailyProgressData dailyProgressData) {
    List<DailyProgressData> existingData = this.fetchDailyProgressData();

    existingData.add(dailyProgressData);

    existingData.sort((prevData, nextData) =>
        nextData.createdAt.compareTo(prevData.createdAt));

    this._progressBox.put(VARENYA_PROGRESS_LIST, existingData);
  }
}
