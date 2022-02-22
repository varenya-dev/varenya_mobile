import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/providers/user_provider.dart';
import 'package:varenya_mobile/services/user_service.dart';
import 'package:varenya_mobile/utils/image_picker.dart';
import 'package:varenya_mobile/utils/logger.util.dart';
import 'package:varenya_mobile/utils/modal_bottom_sheet.dart' as SBS;
import 'package:varenya_mobile/utils/snackbar.dart';
import 'package:varenya_mobile/utils/upload_image_generate_url.dart';
import 'package:varenya_mobile/widgets/common/custom_field_widget.dart';
import 'package:varenya_mobile/widgets/common/loading_icon_button.widget.dart';
import 'package:varenya_mobile/widgets/common/profile_picture_widget.dart';

class UserProfileUpdateTab extends StatefulWidget {
  const UserProfileUpdateTab({Key? key}) : super(key: key);

  @override
  _UserProfileUpdateTabState createState() => _UserProfileUpdateTabState();
}

class _UserProfileUpdateTabState extends State<UserProfileUpdateTab> {
  TextEditingController _fullNameController = new TextEditingController();

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

    // Disposing off the controllers
    this._fullNameController.dispose();
  }

  /*
   * Method for uploading images from gallery.
   */
  Future<void> _uploadFromGallery() async {
    // Open the gallery and get the selected image.
    XFile? imageXFile = await openGallery();

    // Run if there is an image selected.
    if (imageXFile != null) {
      setState(() {
        loading = true;
      });

      // Prepare the file from the selected image.
      File imageFile = new File(imageXFile.path);

      // Upload the image to firebase and generate a URL.
      String uploadedUrl =
          await uploadImageAndGenerateUrl(imageFile, "profile-pictures");

      // Update the user details
      User user = await this._userService.updateProfilePicture(uploadedUrl);

      // Save the updated state.
      this._userProvider.user = user;

      setState(() {
        loading = false;
      });

      // Display a success snackbar.
      displaySnackbar(
        "Profile picture updated!",
        context,
      );
    }
  }

  /*
   * Method for uploading images from camera.
   */
  Future<void> _uploadFromCamera() async {
    // Open the gallery and get the selected image.
    XFile? imageXFile = await openCamera();

    // Run if there is an image selected.
    if (imageXFile != null) {
      setState(() {
        loading = true;
      });

      // Prepare the file from the selected image.
      File imageFile = new File(imageXFile.path);

      // Upload the image to firebase and generate a URL.
      String uploadedUrl =
          await uploadImageAndGenerateUrl(imageFile, "profile-pictures");

      // Update the user details
      User user = await this._userService.updateProfilePicture(uploadedUrl);

      // Save the updated state.
      this._userProvider.user = user;

      setState(() {
        loading = false;
      });

      // Display a success snackbar.
      displaySnackbar(
        "Profile picture updated!",
        context,
      );
    }
  }

  /*
   * Method to open up camera or gallery on user's selection.
   */
  void _onUploadImage() {
    SBS.displayBottomSheet(
      context,
      Wrap(
        children: [
          ListTile(
            leading: Icon(Icons.camera_alt_rounded),
            title: Text('Upload from camera'),
            onTap: this._uploadFromCamera,
          ),
          ListTile(
            leading: Icon(Icons.photo_album_sharp),
            title: Text('Upload from storage'),
            onTap: this._uploadFromGallery,
          )
        ],
      ),
    );
  }

  /*
   * Form submission method for user profile update.
   */
  Future<void> _onFormSubmit() async {
    try {
      // Validate the form.
      if (this._formKey.currentState!.validate()) {
        setState(() {
          loading = true;
        });

        // Update it on server and also update the state as well.
        User user = await this
            ._userService
            .updateFullName(this._fullNameController.text);

        this._userProvider.user = user;

        setState(() {
          loading = false;
        });

        // Display success snackbar.
        displaySnackbar("Your profile name has been updated!", context);
      }
    }
    // Handle errors gracefully.
    catch (error, stackTrace) {
      log.e("UserProfileUpdate:_onFormSubmit", error, stackTrace);
      displaySnackbar("Something went wrong, please try again later", context);

      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Consumer<UserProvider>(builder: (context, state, child) {
        User user = state.user;
        String imageUrl = user.photoURL == null ? '' : user.photoURL!;

        this._fullNameController.text =
            user.displayName != null ? user.displayName! : '';

        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20.0,
            horizontal: 10.0,
          ),
          child: Form(
            key: this._formKey,
            child: Column(
              children: [
                Column(
                  children: [
                    ProfilePictureWidget(
                      imageUrl: imageUrl,
                      size: 200,
                    ),
                    TextButton(
                      onPressed: this._onUploadImage,
                      child: Text(
                        'Upload New Image',
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                    )
                  ],
                ),
                CustomFieldWidget(
                  textFieldController: this._fullNameController,
                  label: "First Name",
                  validators: [
                    RequiredValidator(errorText: "Full name is required"),
                  ],
                  textInputType: TextInputType.text,
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
                      text: 'Update Profile',
                      loadingText: 'Updating',
                    )
                        : LoadingIconButton(
                      connected: false,
                      loading: loading,
                      onFormSubmit: this._onFormSubmit,
                      text: 'Update Profile',
                      loadingText: 'Updating',
                    );;
                  },
                  child: SizedBox(),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
