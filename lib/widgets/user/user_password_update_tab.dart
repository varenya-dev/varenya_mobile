import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/dtos/user/update_password_dto/update_password_dto.dart';
import 'package:varenya_mobile/exceptions/auth/not_logged_in_exception.dart';
import 'package:varenya_mobile/exceptions/auth/weak_password_exception.dart';
import 'package:varenya_mobile/exceptions/auth/wrong_password_exception.dart';
import 'package:varenya_mobile/services/user_service.dart';
import 'package:varenya_mobile/utils/logger.util.dart';
import 'package:varenya_mobile/utils/snackbar.dart';
import 'package:varenya_mobile/validators/value_validator.dart';
import 'package:varenya_mobile/widgets/common/custom_field_widget.dart';
import 'package:varenya_mobile/widgets/common/loading_icon_button.widget.dart';

class UserPasswordUpdateTab extends StatefulWidget {
  const UserPasswordUpdateTab({Key? key}) : super(key: key);

  @override
  _UserPasswordUpdateTabState createState() => _UserPasswordUpdateTabState();
}

class _UserPasswordUpdateTabState extends State<UserPasswordUpdateTab> {
  TextEditingController _newPasswordController = new TextEditingController();
  TextEditingController _newPasswordAgainController =
      new TextEditingController();
  TextEditingController _oldPasswordController = new TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late UserService _userService;

  bool loading = false;

  @override
  void initState() {
    super.initState();

    // Initializing the user service
    this._userService = Provider.of<UserService>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();

    // Dispose off the controllers.
    this._newPasswordController.dispose();
    this._newPasswordAgainController.dispose();
    this._oldPasswordController.dispose();
  }

  /*
   * Form submission method for user password update.
   */
  Future<void> _onFormSubmit() async {
    try {
      // Validate the form.
      if (this._formKey.currentState!.validate()) {
        setState(() {
          loading = true;
        });

        // Prepare DTO for updating password.
        UpdatePasswordDto updatePasswordDto = new UpdatePasswordDto(
          oldPassword: this._oldPasswordController.text,
          newPassword: this._newPasswordController.text,
        );

        // Update it on the server.
        await this._userService.updatePassword(updatePasswordDto);

        setState(() {
          loading = false;
        });

        // Display success snackbar.
        displaySnackbar("Password updated!", context);
      }
    }
    // Handle errors gracefully.
    on WrongPasswordException catch (error) {
      setState(() {
        loading = false;
      });
      displaySnackbar(error.message, context);
    } on WeakPasswordException catch (error) {
      setState(() {
        loading = false;
      });
      displaySnackbar(error.message, context);
    } on NotLoggedInException catch (error) {
      setState(() {
        loading = false;
      });
      displaySnackbar(error.message, context);
    } catch (error, stackTrace) {
      setState(() {
        loading = false;
      });
      log.e("UserPasswordUpdate:_onFormSubmit", error, stackTrace);
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
        child: Form(
          key: this._formKey,
          child: Column(
            children: [
              CustomFieldWidget(
                textFieldController: this._oldPasswordController,
                label: "Old Password",
                validators: [
                  RequiredValidator(
                    errorText: "Please enter your old password.",
                  ),
                  MinLengthValidator(
                    5,
                    errorText:
                        "Your old password should be at least 5 characters long.",
                  ),
                ],
                textInputType: TextInputType.visiblePassword,
                obscureText: true,
              ),
              CustomFieldWidget(
                textFieldController: this._newPasswordController,
                label: "New Password",
                validators: [
                  RequiredValidator(
                    errorText: "Please enter your new password.",
                  ),
                  MinLengthValidator(
                    5,
                    errorText:
                        "Your new password should be at least 5 characters long.",
                  )
                ],
                textInputType: TextInputType.visiblePassword,
                obscureText: true,
              ),
              CustomFieldWidget(
                textFieldController: this._newPasswordAgainController,
                label: "New Password Again",
                validators: [
                  RequiredValidator(
                    errorText: "Please enter your new password.",
                  ),
                  MinLengthValidator(
                    5,
                    errorText:
                        "Your new password should be at least 5 characters long.",
                  ),
                  ValueValidator(
                    checkAgainstTextController: this._newPasswordController,
                    errorText: "Passwords don't match",
                  ),
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
                  );;
                },
                child: SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
