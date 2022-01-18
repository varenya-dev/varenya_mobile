import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:varenya_mobile/models/daily_progress_data/question_controller/question_controller.model.dart';
import 'package:varenya_mobile/widgets/common/custom_field_widget.dart';

class QuestionnaireField extends StatelessWidget {
  const QuestionnaireField({
    Key? key,
    required this.questionController,
  }) : super(key: key);

  final QuestionController questionController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.02,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
            ),
            child: Text(
              questionController.question.question,
            ),
          ),
          CustomFieldWidget(
            textFieldController: questionController.textEditingController,
            label: 'Answer',
            validators: [
              MinLengthValidator(
                5,
                errorText: 'Answer should be at least 5 characters long',
              ),
            ],
            textInputType: TextInputType.text,
          ),
        ],
      ),
    );
  }
}
