import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/dtos/user/update_email_dto/update_email_dto.dart';
import 'package:varenya_mobile/exceptions/auth/not_logged_in_exception.dart';
import 'package:varenya_mobile/exceptions/auth/user_already_exists_exception.dart';
import 'package:varenya_mobile/exceptions/auth/wrong_password_exception.dart';
import 'package:varenya_mobile/providers/user_provider.dart';
import 'package:varenya_mobile/services/user_service.dart';
import 'package:varenya_mobile/utils/logger.util.dart';
import 'package:varenya_mobile/utils/snackbar.dart';
import 'package:varenya_mobile/widgets/common/custom_field_widget.dart';
import 'package:varenya_mobile/widgets/common/loading_icon_button.widget.dart';

class UserEmailUpdateTab extends StatefulWidget {
  const UserEmailUpdateTab({Key? key}) : super(key: key);

  @override
  _UserEmailUpdateTabState createState() => _UserEmailUpdateTabState();
}

class _UserEmailUpdateTabState extends State<UserEmailUpdateTab> {
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  late UserProvider _userProvider;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late UserService _userService;

  bool loading = false;

  @override
  void initState() {
    super.initState();

    // Initializing the user provider.
    this._userProvider = Provider.of<UserProvider>(context, listen: false);

    // Initializing the user service
    this._userService = Provider.of<UserService>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();

    // Dispose off the controllers.
    this._emailController.dispose();
    this._passwordController.dispose();
  }

  /*
   * Form submission method for user email update.
   */
  Future<void> _onFormSubmit() async {
    try {
      // Validate the form.
      if (this._formKey.currentState!.validate()) {
        setState(() {
          loading = true;
        });

        // Prepare DTO for updating password.
        UpdateEmailDto updateEmailDto = new UpdateEmailDto(
          newEmailAddress: this._emailController.text,
          password: this._passwordController.text,
        );

        // Update it on server and also update the state as well.
        User user = await this._userService.updateEmailAddress(
              updateEmailDto,
            );

        this._userProvider.user = user;

        setState(() {
          loading = false;
        });

        // Display success snackbar.
        displaySnackbar("Email updated!", context);
      }
    }
    // Handle errors gracefully.
    on UserAlreadyExistsException catch (error) {
      displaySnackbar(error.message, context);
    } on WrongPasswordException catch (error) {
      displaySnackbar(error.message, context);
    } on NotLoggedInException catch (error) {
      displaySnackbar(error.message, context);
    } catch (error, stackTrace) {
      log.e("UserEmailUpdate:_onFormSubmit", error, stackTrace);
      displaySnackbar(
        'Something went wrong, please try again later.',
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20.0,
          horizontal: 10.0,
        ),
        child: Consumer<UserProvider>(
          builder: (context, state, child) {
            User user = state.user;
            this._emailController.text = user.email != null ? user.email! : '';
            return Form(
              key: this._formKey,
              child: Column(
                children: [
                  CustomFieldWidget(
                    textFieldController: this._emailController,
                    label: "Email Address",
                    validators: [
                      RequiredValidator(
                        errorText: "Please enter your email address.",
                      ),
                      EmailValidator(
                        errorText: "Please enter a valid email address.",
                      ),
                    ],
                    textInputType: TextInputType.emailAddress,
                  ),
                  CustomFieldWidget(
                    textFieldController: this._passwordController,
                    label: "Password",
                    validators: [
                      RequiredValidator(
                        errorText: "Please enter your password.",
                      ),
                      MinLengthValidator(
                        5,
                        errorText:
                            "Your password should be at least 5 characters long.",
                      )
                    ],
                    textInputType: TextInputType.visiblePassword,
                    obscureText: true,
                  ),
                  OfflineBuilder(
                    connectivityBuilder:
                        (BuildContext context, ConnectivityResult result, _) {
                      final bool connected = result != ConnectivityResult.none;

                      return connected
                          ? LoadingIconButton(
                              connected: true,
                              loading: loading,
                              onFormSubmit: this._onFormSubmit,
                              text: 'Update Email Address',
                              loadingText: 'Updating',
                            )
                          : LoadingIconButton(
                              connected: false,
                              loading: loading,
                              onFormSubmit: this._onFormSubmit,
                              text: 'Update Email Address',
                              loadingText: 'Updating',
                            );
                    },
                    child: SizedBox(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
