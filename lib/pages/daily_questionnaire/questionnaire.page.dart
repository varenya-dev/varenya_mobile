import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/models/daily_progress_data/daily_progress_data.model.dart';
import 'package:varenya_mobile/models/daily_progress_data/question_answer/question_answer.model.dart';
import 'package:varenya_mobile/models/daily_progress_data/question_controller/question_controller.model.dart';
import 'package:varenya_mobile/services/daily_questionnaire.service.dart';
import 'package:varenya_mobile/utils/snackbar.dart';
import 'package:varenya_mobile/widgets/daily_questionnaire/mood_selector.widget.dart';
import 'package:varenya_mobile/widgets/daily_questionnaire/questionnaire_field.widget.dart';
import 'package:uuid/uuid.dart';

class Questionnaire extends StatefulWidget {
  const Questionnaire({Key? key}) : super(key: key);

  // Page Route Name.
  static const routeName = "/questionnaire";

  @override
  _QuestionnaireState createState() => _QuestionnaireState();
}

class _QuestionnaireState extends State<Questionnaire> {

  // Daily Questionnaire Service
  late final DailyQuestionnaireService _dailyQuestionnaireService;

  // List of question and text controllers and form state key.
  final List<QuestionController> _questionControllers = [];
  final GlobalKey<FormState> _questionnaireKey = new GlobalKey<FormState>();

  int mood = 0;

  final Uuid uuid = new Uuid();

  @override
  void initState() {
    super.initState();

    // Injecting the daily questionnaire service from global state.
    this._dailyQuestionnaireService =
        Provider.of<DailyQuestionnaireService>(context, listen: false);

    // Fetch all daily questions from storage
    // and mapping them to text editing controllers.
    this._dailyQuestionnaireService.fetchDailyQuestions().forEach(
      (element) {
        this._questionControllers.add(
              new QuestionController(
                question: element,
                textEditingController: new TextEditingController(),
              ),
            );
      },
    );
  }

  /*
   * Method to handle saving responses from the questionnaire.
   */
  void _handleSubmit() {

    // Checking for form validation.
    if (!this._questionnaireKey.currentState!.validate()) {
      return;
    }

    // Check for validating mood data.
    if (this.mood > 5 || this.mood < 1) {
      displaySnackbar(
        "Please select a valid mood",
        context,
      );

      return;
    }

    // Map the question controllers to
    // Question Answer object with answers.
    List<QuestionAnswer> questions = this
        ._questionControllers
        .map((e) => new QuestionAnswer(
              id: uuid.v4(),
              question: e.question.question,
              answer: e.textEditingController.text,
            ))
        .toList();

    // Creating a daily progress data object
    // with question answer list and mood.
    DailyProgressData dailyProgressData = new DailyProgressData(
      answers: questions,
      moodRating: this.mood,
      createdAt: DateTime.now(),
    );

    // Save Daily Progress Data to device storage.
    this._dailyQuestionnaireService.saveProgressData(dailyProgressData);

    // Display confirmation for progress save.
    displaySnackbar(
      "Progress recorded!",
      context,
    );

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    super.dispose();

    this._questionControllers.forEach(
          (element) => element.textEditingController.dispose(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Questionnaire'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: Form(
                key: this._questionnaireKey,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: this._questionControllers.length,
                  itemBuilder: (BuildContext context, int index) {
                    QuestionController questionController =
                        this._questionControllers[index];
                    return QuestionnaireField(
                      questionController: questionController,
                    );
                  },
                ),
              ),
            ),
            MoodSelector(
              emitMood: (int mood) {
                setState(() {
                  this.mood = mood;
                });
              },
            ),
            Center(
              child: ElevatedButton(
                onPressed: _handleSubmit,
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
