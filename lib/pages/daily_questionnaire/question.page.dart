import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/models/daily_progress_data/question_answer/question_answer.model.dart';
import 'package:varenya_mobile/services/daily_questionnaire.service.dart';
import 'package:varenya_mobile/widgets/daily_questionnaire/question_display.widget.dart';

class Question extends StatefulWidget {
  const Question({Key? key}) : super(key: key);

  static const routeName = "/question";

  @override
  _QuestionState createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  late final DailyQuestionnaireService _dailyQuestionnaireService;
  late List<QuestionAnswer> _questions;

  @override
  void initState() {
    super.initState();

    this._dailyQuestionnaireService = Provider.of(context, listen: false);
    this._questions = this._dailyQuestionnaireService.fetchDailyQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Questions Configuration'),
      ),
      body: ListView.builder(
        itemCount: this._questions.length,
        itemBuilder: (BuildContext context, int index) {
          QuestionAnswer question = this._questions[index];

          return QuestionDisplay(
            question: question,
            onEditQuestion: () {},
            onDeleteQuestion: () {},
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellow,
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}
