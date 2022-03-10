import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/models/daily_progress_data/question_answer/question_answer.model.dart';
import 'package:varenya_mobile/services/daily_questionnaire.service.dart';
import 'package:varenya_mobile/utils/palette.util.dart';
import 'package:varenya_mobile/utils/responsive_config.util.dart';
import 'package:varenya_mobile/widgets/common/custom_field_widget.dart';
import 'package:varenya_mobile/widgets/daily_questionnaire/question_actions.widget.dart';
import 'package:varenya_mobile/widgets/daily_questionnaire/question_display.widget.dart';
import 'package:uuid/uuid.dart';

class Question extends StatefulWidget {
  const Question({Key? key}) : super(key: key);

  // Page Route Name.
  static const routeName = "/question";

  @override
  _QuestionState createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  // Daily Questionnaire Service.
  late final DailyQuestionnaireService _dailyQuestionnaireService;

  // List of questions.
  late List<QuestionAnswer> _questions;

  // Form State keys and Text Editing Controllers.
  final GlobalKey<FormState> _createFormKey = new GlobalKey<FormState>();
  final TextEditingController _createQuestionController =
      new TextEditingController();

  final GlobalKey<FormState> _editFormKey = new GlobalKey<FormState>();
  final TextEditingController _editQuestionController =
      new TextEditingController();

  // UUID
  final Uuid uuid = new Uuid();

  @override
  void initState() {
    super.initState();

    // Injecting Daily Questionnaire Service from global state.
    this._dailyQuestionnaireService = Provider.of(context, listen: false);

    // Fetch questions from device storage.
    this._questions = this._dailyQuestionnaireService.fetchDailyQuestions();
  }

  /*
   * Method to handle creation of new question.
   */
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

  /*
   * Method handling saving new question to device storage.
   */
  void _createQuestion() {
    // Check for form validation
    if (!this._createFormKey.currentState!.validate()) {
      return;
    }

    // Save question to the list of questions.
    this._questions.add(
          new QuestionAnswer(
            id: uuid.v4(),
            question: this._createQuestionController.text,
            answer: '',
          ),
        );

    // Saving the updated list to the device storage.
    this._dailyQuestionnaireService.saveQuestions(this._questions);

    // State change to get the new updated list of questions.
    setState(() {
      this._questions = this._dailyQuestionnaireService.fetchDailyQuestions();
    });

    this._createQuestionController.text = '';

    Navigator.of(context).pop();
  }

  /*
   * Method to handle updating of an existing question.
   * @param question QuestionAnswer object to be updated.
   */
  void _handleUpdateQuestion(QuestionAnswer question) {
    // Set the controller text as the original question.
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

  /*
   * Method handling saving the updated question to device storage.
   * @param question Question answer object to be updated.
   */
  void _updateQuestion(QuestionAnswer question) {
    if (!this._editFormKey.currentState!.validate()) {
      return;
    }

    // Find the index of where the question exists in the list of questions.
    int questionIndex = this._questions.indexWhere(
          (element) => element.id == question.id,
        );

    // Save the updated question to the list.
    this._questions[questionIndex] = new QuestionAnswer(
      id: uuid.v4(),
      question: this._editQuestionController.text,
      answer: '',
    );

    // Save the updated list to the device storage.
    this._dailyQuestionnaireService.saveQuestions(this._questions);

    // State change to get the new updated list of questions.
    setState(() {
      this._questions = this._dailyQuestionnaireService.fetchDailyQuestions();
    });

    this._editQuestionController.text = '';

    Navigator.of(context).pop();
  }

  /*
   * Method to handle deleting of an existing question.
   * @param question QuestionAnswer object to be deleted.
   */
  void _handleDeleteQuestion(QuestionAnswer question) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          'Are you sure you want to delete this question?',
        ),
        content: Text(
          question.question,
        ),
        actions: [
          TextButton(
            onPressed: () {
              this._deleteQuestion(question);
            },
            child: Text('Delete'),
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

  /*
   * Method handling deleting question from device storage.
   * @param question Question answer object to be deleted.
   */
  void _deleteQuestion(QuestionAnswer question) {
    // Remove the question from the list.
    this._questions.removeWhere((element) => element.id == question.id);

    // Save the updated list to the device storage.
    this._dailyQuestionnaireService.saveQuestions(this._questions);

    // State change to get the new updated list of questions.
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Palette.black,
                width: MediaQuery.of(context).size.width,
                height: responsiveConfig(
                  context: context,
                  large: MediaQuery.of(context).size.height * 0.3,
                  medium: MediaQuery.of(context).size.height * 0.3,
                  small: MediaQuery.of(context).size.height * 0.24,
                ),
                padding: EdgeInsets.all(
                  responsiveConfig(
                    context: context,
                    large: MediaQuery.of(context).size.width * 0.03,
                    medium: MediaQuery.of(context).size.width * 0.03,
                    small: MediaQuery.of(context).size.width * 0.05,
                  ),
                ),
                child: Text(
                  'Questions\nConfiguration',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.07,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              QuestionActions(
                addQuestion: _handleCreateNewQuestion,
              ),
              Divider(),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: this._questions.length,
                itemBuilder: (BuildContext context, int index) {
                  QuestionAnswer question = this._questions[index];

                  return QuestionDisplay(
                    question: question,
                    onEditQuestion: this._handleUpdateQuestion,
                    onDeleteQuestion: this._handleDeleteQuestion,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
