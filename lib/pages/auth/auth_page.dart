import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/enum/auth_page_status.dart';
import 'package:varenya_mobile/pages/auth/login_page.dart';
import 'package:varenya_mobile/pages/auth/register_page.dart';
import 'package:varenya_mobile/services/auth_service.dart';
import 'package:varenya_mobile/utils/responsive_config.util.dart';
import 'package:varenya_mobile/utils/snackbar.dart';
import 'package:varenya_mobile/widgets/auth/auth_button_bar_widget.dart';
import 'package:varenya_mobile/widgets/common/custom_field_widget.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  static const routeName = "/auth";

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _emailAddressController =
      new TextEditingController();

  final GlobalKey<FormState> _formKey = new GlobalKey();

  late AuthService _authService;

  AuthPageStatus _authPageStatus = AuthPageStatus.REGISTER;

  @override
  void initState() {
    super.initState();

    // Injecting Authentication service from context.
    this._authService = Provider.of<AuthService>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();

    // Disposing off the text editing controller.
    this._emailAddressController.dispose();
  }

  /*
   * Method to handle the registration/login status of the auth page.
   * @param authPageStatus Auth status.
   */
  void _handleAuthPageStatus(AuthPageStatus authPageStatus) {
    // Change status of the page.
    setState(() {
      this._authPageStatus = authPageStatus;
    });
  }

  /*
   * Handle form submission to check for email address availability.
   */
  Future<void> _handleFormSubmit() async {
    // Check the validity of the form.
    if (!this._formKey.currentState!.validate()) {
      return;
    }

    // Get the email address input from user.
    String emailAddress = this._emailAddressController.text;

    // Check only for registration process.
    if (this._authPageStatus == AuthPageStatus.REGISTER) {
      // Check for account availability on firebase.
      bool isAvailable =
          await this._authService.checkAccountAvailability(emailAddress);

      // If available, route the user to registration page.
      if (isAvailable) {
        Navigator.of(context).pushNamed(
          RegisterPage.routeName,
          arguments: emailAddress,
        );
      }

      // Else show them the error message.
      else {
        displaySnackbar("This email address is not available.", context);
      }
    }

    // Route to login page.
    else {
      Navigator.of(context).pushNamed(
        LoginPage.routeName,
        arguments: emailAddress,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: this._formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: responsiveConfig(
                    context: context,
                    large: MediaQuery.of(context).size.height * 0.5,
                    medium: MediaQuery.of(context).size.height * 0.5,
                    small: MediaQuery.of(context).size.height * 0.5,
                  ),
                  child: Image.asset(
                    'assets/logo/app_logo.png',
                    scale: 0.5,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: responsiveConfig(
                      context: context,
                      large: MediaQuery.of(context).size.width * 0.3,
                      medium: MediaQuery.of(context).size.width * 0.1,
                      small: 10.0,
                    ),
                  ),
                  child: CustomFieldWidget(
                    textFieldController: this._emailAddressController,
                    label: 'Email Address',
                    validators: [
                      RequiredValidator(
                          errorText: 'Email address is required.'),
                      EmailValidator(
                          errorText: 'Please enter a valid email address.')
                    ],
                    textInputType: TextInputType.emailAddress,
                    suffixIcon: GestureDetector(
                      onTap: this._handleFormSubmit,
                      child: Icon(Icons.arrow_forward),
                    ),
                  ),
                ),
                Text(
                  'A Mental Health Support Application.',
                  textAlign: TextAlign.center,
                ),
                AuthButtonBarWidget(
                  onSelect: this._handleAuthPageStatus,
                  authPageStatus: this._authPageStatus,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
