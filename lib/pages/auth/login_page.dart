import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/dtos/auth/login_account_dto/login_account_dto.dart';
import 'package:varenya_mobile/exceptions/auth/user_not_found_exception.dart';
import 'package:varenya_mobile/exceptions/auth/wrong_password_exception.dart';
import 'package:varenya_mobile/pages/auth/register_page.dart';
import 'package:varenya_mobile/pages/home_page.dart';
import 'package:varenya_mobile/providers/user_provider.dart';
import 'package:varenya_mobile/services/auth_service.dart';
import 'package:varenya_mobile/utils/snackbar.dart';
import 'package:varenya_mobile/widgets/common/custom_field_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const routeName = "/login";

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  late AuthService _authService;

  final TextEditingController _emailFieldController =
      new TextEditingController();
  final TextEditingController _passwordFieldController =
      new TextEditingController();

  @override
  void initState() {
    super.initState();

    // Injecting the required services.
    this._authService = Provider.of<AuthService>(context, listen: false);
  }

  /*
   * Handle form submission for logging the user in.
   */
  Future<void> _onFormSubmit() async {
    // Check the validity of the form.
    if (!this._formKey.currentState!.validate()) {
      return;
    }

    // Create a DTO object for logging in the user.
    LoginAccountDto loginAccountDto = new LoginAccountDto(
      emailAddress: this._emailFieldController.text,
      password: this._passwordFieldController.text,
    );

    try {
      // Try logging the user in with given credentials.
      User user =
          await this._authService.loginWithEmailAndPassword(loginAccountDto);

      // Save the user details in memory.
      Provider.of<UserProvider>(context, listen: false).user = user;

      // Push them to the home page.
      Navigator.of(context).pushReplacementNamed(HomePage.routeName);
    }

    // Handle errors gracefully.
    on UserNotFoundException catch (error) {
      displaySnackbar(error.message, context);
    } on WrongPasswordException catch (error) {
      displaySnackbar(error.message, context);
    }
  }

  @override
  void dispose() {
    super.dispose();

    // Disposing off the text controllers.
    this._emailFieldController.dispose();
    this._passwordFieldController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the email address from the previous screen.
    this._emailFieldController.text =
        ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Image.asset(
                  'assets/logo/app_logo.png',
                  scale: 0.5,
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomFieldWidget(
                      textFieldController: this._emailFieldController,
                      label: 'Email Address',
                      validators: [
                        RequiredValidator(
                          errorText: 'Please enter your email address here.',
                        ),
                        EmailValidator(
                          errorText: 'Please enter a valid email address.',
                        )
                      ],
                      textInputType: TextInputType.emailAddress,
                    ),
                    CustomFieldWidget(
                      textFieldController: this._passwordFieldController,
                      label: 'Password',
                      validators: [
                        RequiredValidator(
                          errorText: 'Please enter your password here.',
                        ),
                        MinLengthValidator(
                          5,
                          errorText:
                              'Your password should be at least 5 characters long.',
                        )
                      ],
                      textInputType: TextInputType.text,
                      obscureText: true,
                    ),
                    ElevatedButton(
                      onPressed: _onFormSubmit,
                      child: Text('Login'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context)
                          .pushReplacementNamed(RegisterPage.routeName),
                      child: Text('Don\'t have an account? Register here!'),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
