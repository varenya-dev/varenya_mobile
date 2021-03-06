import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:varenya_mobile/utils/palette.util.dart';

class CustomFieldWidget extends StatelessWidget {
  final String label;
  final TextEditingController textFieldController;
  final List<FieldValidator> validators;
  final bool obscureText;
  final TextInputType textInputType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  CustomFieldWidget({
    Key? key,
    required this.textFieldController,
    required this.label,
    required this.validators,
    this.obscureText = false,
    required this.textInputType,
    this.prefixIcon,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.05,
        vertical: MediaQuery.of(context).size.height * 0.01,
      ),
      child: TextFormField(
        style: TextStyle(
          color: Colors.white,
        ),
        obscureText: this.obscureText,
        keyboardType: textInputType,
        decoration: InputDecoration(
          labelText: label,
          fillColor: Palette.secondary,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide.none,
          ),
          prefixIcon: this.prefixIcon,
          suffixIcon: this.suffixIcon,
        ),
        controller: this.textFieldController,
        validator: MultiValidator(validators),
      ),
    );
  }
}
