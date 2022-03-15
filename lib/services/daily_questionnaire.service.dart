import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:varenya_mobile/constants/hive_boxes.constant.dart';
import 'package:varenya_mobile/models/daily_progress_data/daily_mood/daily_mood.model.dart';
import 'package:varenya_mobile/models/daily_progress_data/daily_mood_data/daily_mood_data.model.dart';
import 'package:varenya_mobile/models/daily_progress_data/daily_progress_data.model.dart';
import 'package:varenya_mobile/models/daily_progress_data/question_answer/question_answer.model.dart';

/*
 * Service Implementation for Daily Questionnaire Module.
 */
class DailyQuestionnaireService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final Box<List<dynamic>> _progressBox = Hive.box(VARENYA_PROGRESS_BOX);
  final Box<List<dynamic>> _questionBox = Hive.box(VARENYA_QUESTION_BOX);
  final Box<dynamic> _timingBox = Hive.box(VARENYA_TIMING_BOX);

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

  DateTime fetchNotificationDate() {
    return this
        ._timingBox
        .get(VARENYA_TIMING_STRING, defaultValue: DateTime.now());
  }

  void saveTiming(DateTime timing) =>
      this._timingBox.put(VARENYA_TIMING_STRING, timing);

  /*
   * Method to save daily questionnaire questions on device.
   */
  void saveQuestions(List<QuestionAnswer> questions) =>
      this._questionBox.put(VARENYA_QUESTION_LIST, questions);

  /*
   * Method to save daily progress data on device.
   */
  Future<void> saveProgressData(DailyProgressData dailyProgressData) async {
    // Fetch existing data from device
    List<DailyProgressData> existingData = this.fetchDailyProgressData();

    // Add the new data to the fetched list.
    existingData.add(dailyProgressData);

    // Sort the list by date they were created on
    existingData.sort((prevData, nextData) =>
        prevData.createdAt.compareTo(nextData.createdAt));

    // Save the sorted list on device storage.
    this._progressBox.put(VARENYA_PROGRESS_LIST, existingData);

    await this._createOrUpdateMoodData();
  }

  Future<bool> checkIfDoctorHasAccess(String doctorId) async {
    DailyMoodData dailyMoodData = await this._fetchMoods();

    return dailyMoodData.access.contains(doctorId);
  }

  Future<void> toggleShareMood(String doctorId) async {
    DailyMoodData dailyMoodData = await this._fetchMoods();

    if (dailyMoodData.access.contains(doctorId))
      dailyMoodData.access.remove(doctorId);
    else
      dailyMoodData.access.add(doctorId);

    Map<String, dynamic> data = dailyMoodData.toJson();
    data['moods'] = data['moods'].map((mood) => mood.toJson()).toList();

    await this
        ._firestore
        .collection('moods')
        .doc(this._auth.currentUser!.uid)
        .set(data);
  }

  Future<bool> _checkForExistingMoodData() async {
    DocumentSnapshot<Map<String, dynamic>> moodData = await this
        ._firestore
        .collection('moods')
        .doc(this._auth.currentUser!.uid)
        .get();

    return moodData.exists;
  }

  Future<DailyMoodData> _fetchMoods() async {
    if (!(await this._checkForExistingMoodData())) {
      await this._createOrUpdateMoodData();
    }

    DocumentSnapshot<Map<String, dynamic>> moodData = await this
        ._firestore
        .collection('moods')
        .doc(this._auth.currentUser!.uid)
        .get();

    return DailyMoodData.fromJson(moodData.data()!);
  }

  Future<void> _createOrUpdateMoodData() async {
    List<DailyProgressData> dailyProgressData = this.fetchDailyProgressData();

    DailyMoodData existingData = await this._fetchMoods();

    List<DailyMood> dailyMood = dailyProgressData
        .map(
          (progress) => new DailyMood(
            date: progress.createdAt,
            mood: progress.moodRating,
          ),
        )
        .toList();

    DailyMoodData dailyMoodData = new DailyMoodData(
      access: existingData.access,
      moods: dailyMood,
    );

    Map<String, dynamic> data = dailyMoodData.toJson();
    data['moods'] = data['moods'].map((mood) => mood.toJson()).toList();

    await this
        ._firestore
        .collection('moods')
        .doc(this._auth.currentUser!.uid)
        .set(data);
  }
}
