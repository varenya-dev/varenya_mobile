import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/models/daily_progress_data/question_answer/question_answer.model.dart';
import 'package:varenya_mobile/services/daily_questionnaire.service.dart';
import 'package:varenya_mobile/widgets/common/custom_field_widget.dart';
import 'package:varenya_mobile/widgets/daily_questionnaire/question_display.widget.dart';
import 'package:uuid/uuid.dart';

class Question extends StatefulWidget {
  const Question({Key? key}) : super(key: key);

  static const routeName = "/question";

  @override
  _QuestionState createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  late final DailyQuestionnaireService _dailyQuestionnaireService;
  late List<QuestionAnswer> _questions;

  final GlobalKey<FormState> _createFormKey = new GlobalKey<FormState>();
  final TextEditingController _createQuestionController =
      new TextEditingController();

  final GlobalKey<FormState> _editFormKey = new GlobalKey<FormState>();
  final TextEditingController _editQuestionController =
      new TextEditingController();

  final Uuid uuid = new Uuid();

  @override
  void initState() {
    super.initState();

    this._dailyQuestionnaireService = Provider.of(context, listen: false);
    this._questions = this._dailyQuestionnaireService.fetchDailyQuestions();
  }

  void _handleCreateNewQuestion() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text('Create New Question'),
        content: Form(
          key: this._createFormKey,
          child: CustomFieldWidget(
            textFieldController: this._createQuestionController,
            label: 'Question',
            validators: [
              MinLengthValidator(
                5,
                errorText: 'Question should be at least 5 characters long',
              ),
            ],
            textInputType: TextInputType.text,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _createQuestion,
            child: Text('Create'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _createQuestion() {
    if (!this._createFormKey.currentState!.validate()) {
      return;
    }

    this._questions.add(
          new QuestionAnswer(
            id: uuid.v4(),
            question: this._createQuestionController.text,
            answer: '',
          ),
        );

    this._dailyQuestionnaireService.saveQuestions(this._questions);

    setState(() {
      this._questions = this._dailyQuestionnaireService.fetchDailyQuestions();
    });

    Navigator.of(context).pop();
  }

  void _handleUpdateQuestion(QuestionAnswer question) {
    this._editQuestionController.text = question.question;

    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text('Update Question'),
        content: Form(
          key: this._editFormKey,
          child: CustomFieldWidget(
            textFieldController: this._editQuestionController,
            label: 'Question',
            validators: [
              MinLengthValidator(
                5,
                errorText: 'Question should be at least 5 characters long',
              ),
            ],
            textInputType: TextInputType.text,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              this._updateQuestion(question);
            },
            child: Text('Update'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _updateQuestion(QuestionAnswer question) {
    if (!this._editFormKey.currentState!.validate()) {
      return;
    }

    int questionIndex = this._questions.indexWhere(
          (element) => element.id == question.id,
        );

    this._questions[questionIndex] = new QuestionAnswer(
      id: uuid.v4(),
      question: this._editQuestionController.text,
      answer: '',
    );

    this._dailyQuestionnaireService.saveQuestions(this._questions);

    setState(() {
      this._questions = this._dailyQuestionnaireService.fetchDailyQuestions();
    });

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    super.dispose();

    this._createQuestionController.dispose();
    this._editQuestionController.dispose();
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
            onEditQuestion: this._handleUpdateQuestion,
            onDeleteQuestion: _handleCreateNewQuestion,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellow,
        onPressed: _handleCreateNewQuestion,
        child: Icon(Icons.add),
      ),
    );
  }
}
