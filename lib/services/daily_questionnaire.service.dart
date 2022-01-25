import 'package:hive/hive.dart';
import 'package:varenya_mobile/constants/hive_boxes.constant.dart';
import 'package:varenya_mobile/models/daily_progress_data/daily_progress_data.model.dart';
import 'package:varenya_mobile/models/daily_progress_data/question_answer/question_answer.model.dart';

/*
 * Service Implementation for Daily Questionnaire Service.
 */
class DailyQuestionnaireService {
  final Box<List<dynamic>> _progressBox = Hive.box(VARENYA_PROGRESS_BOX);
  final Box<List<dynamic>> _questionBox = Hive.box(VARENYA_QUESTION_BOX);

  /*
   * Method to fetch daily questionnaire questions from device.
   */
  List<QuestionAnswer> fetchDailyQuestions() => this
      ._questionBox
      .get(VARENYA_QUESTION_LIST, defaultValue: [])!.cast<QuestionAnswer>();

  /*
   * Method to fetch daily progress data from device.
   */
  List<DailyProgressData> fetchDailyProgressData() => this
      ._progressBox
      .get(VARENYA_PROGRESS_LIST, defaultValue: [])!.cast<DailyProgressData>();

  /*
   * Method to save daily questionnaire questions on device.
   */
  void saveQuestions(List<QuestionAnswer> questions) =>
      this._questionBox.put(VARENYA_QUESTION_LIST, questions);

  /*
   * Method to save daily progress data on device.
   */
  void saveProgressData(DailyProgressData dailyProgressData) {
    // Fetch existing data from device
    List<DailyProgressData> existingData = this.fetchDailyProgressData();

    // Add the new data to the fetched list.
    existingData.add(dailyProgressData);

    // Sort the list by date they were created on
    existingData.sort((prevData, nextData) =>
        prevData.createdAt.compareTo(nextData.createdAt));

    // Save the sorted list on device storage.
    this._progressBox.put(VARENYA_PROGRESS_LIST, existingData);
  }
}
