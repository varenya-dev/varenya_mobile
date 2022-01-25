import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/dtos/post/create_post/create_post.dto.dart';
import 'package:varenya_mobile/exceptions/server.exception.dart';
import 'package:varenya_mobile/models/post/post_category/post_category.model.dart';
import 'package:varenya_mobile/services/post.service.dart';
import 'package:varenya_mobile/utils/image_picker.dart';
import 'package:varenya_mobile/utils/logger.util.dart';
import 'package:varenya_mobile/utils/modal_bottom_sheet.dart';
import 'package:varenya_mobile/utils/snackbar.dart';
import 'package:varenya_mobile/utils/upload_image_generate_url.dart';
import 'package:varenya_mobile/widgets/common/custom_text_area.widget.dart';
import 'package:varenya_mobile/widgets/common/loading_icon_button.widget.dart';
import 'package:varenya_mobile/widgets/posts/file_image_carousel.widget.dart';
import 'package:varenya_mobile/widgets/posts/post_categories.widget.dart';
import 'package:varenya_mobile/widgets/posts/select_categories.widget.dart';

class NewPost extends StatefulWidget {
  const NewPost({Key? key}) : super(key: key);

  static const routeName = "/new-post";

  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  late final PostService _postService;
  final TextEditingController _bodyController = new TextEditingController();
  List<PostCategory> _categories = [];
  List<File> _imageFiles = [];

  bool loading = false;

  @override
  void initState() {
    super.initState();

    this._postService = Provider.of<PostService>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();

    this._bodyController.dispose();
  }

  /*
   * Method for uploading images from gallery.
   */
  Future<void> _uploadFromGallery() async {
    // Open the gallery and get the selected image.
    XFile? imageXFile = await openGallery();

    // Run if there is an image selected.
    if (imageXFile != null) {
      // Prepare the file from the selected image.
      File imageFile = new File(imageXFile.path);

      setState(() {
        this._imageFiles.add(imageFile);
      });

      // Display a success snackbar.
      displaySnackbar(
        "Image Added",
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
      // Prepare the file from the selected image.
      File imageFile = new File(imageXFile.path);

      setState(() {
        this._imageFiles.add(imageFile);
      });

      // Display a success snackbar.
      displaySnackbar(
        "Image Added",
        context,
      );
    }
  }

  void _removeImage(File imageFile) {
    setState(() {
      this._imageFiles = this
          ._imageFiles
          .where((imgFile) => imgFile.path != imageFile.path)
          .toList();
    });
  }

  Future<void> _onCreateNewPost() async {
    if (!this._formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      List<String> uploadedImages = await Future.wait(
        this._imageFiles.map(
              (file) async => await uploadImageAndGenerateUrl(file, 'posts'),
            ),
      );

      List<String> selectedCategories =
          this._categories.map((category) => category.categoryName).toList();

      if (selectedCategories.length == 0) {
        throw new ServerException(
            message: 'Please select at least one category');
      }

      String body = this._bodyController.text;

      CreatePostDto createPostDto = new CreatePostDto(
        body: body,
        images: uploadedImages,
        categories: selectedCategories,
      );

      await this._postService.createNewPost(createPostDto);

      setState(() {
        loading = false;
      });

      displaySnackbar("Post Created!", context);

      Navigator.of(context).pop();
    } on ServerException catch (error) {
      setState(() {
        loading = false;
      });

      displaySnackbar(error.message, context);
    } catch (error, stackTrace) {
      setState(() {
        loading = false;
      });

      log.e("NewPost:_onCreateNewPost", error, stackTrace);
      displaySnackbar(
        "Something went wrong, please try again later.",
        context,
      );
    }
  }

  /*
   * Method to open up camera or gallery on user's selection.
   */
  void _onUploadImage() {
    displayBottomSheet(
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

  void _openPostCategories() {
    displayBottomSheet(
      context,
      StatefulBuilder(
        builder: (context, setStateInner) => SelectCategories(
          categories: this._categories,
          onChanged: (bool? value, PostCategory category) {
            if (value == true) {
              setState(() {
                this._categories.add(category);
              });
            } else {
              setState(() {
                this._categories = this
                    ._categories
                    .where((cty) => cty.id != category.id)
                    .toList();
              });
            }
            setStateInner(() {});
          },
          onClear: () {
            setState(() {
              this._categories.clear();
            });

            setStateInner(() {});
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Post'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: this._formKey,
          child: Column(
            children: [
              CustomTextArea(
                textFieldController: this._bodyController,
                label: 'Body of the post',
                validators: [
                  RequiredValidator(
                    errorText: 'Body is required.',
                  ),
                  MinLengthValidator(
                    10,
                    errorText: 'Body should be at least 10 characters long.',
                  )
                ],
                textInputType: TextInputType.text,
                minLines: 1,
              ),
              TextButton(
                onPressed: this._openPostCategories,
                child: Text(
                  'Select Categories',
                ),
              ),
              PostCategories(
                categories: this._categories,
              ),
              TextButton(
                onPressed: this._onUploadImage,
                child: Text(
                  'Upload Images',
                ),
              ),
              FileImageCarousel(
                fileImages: this._imageFiles,
                onDelete: this._removeImage,
              ),
              OfflineBuilder(
                connectivityBuilder:
                    (BuildContext context, ConnectivityResult result, _) {
                  final bool connected = result != ConnectivityResult.none;

                  return connected
                      ? LoadingIconButton(
                          connected: true,
                          loading: loading,
                          onFormSubmit: this._onCreateNewPost,
                          text: 'Create Post',
                          loadingText: 'Creating',
                          icon: Icon(
                            Icons.add_circle,
                          ),
                        )
                      : LoadingIconButton(
                          connected: false,
                          loading: loading,
                          onFormSubmit: this._onCreateNewPost,
                          text: 'Create Post',
                          loadingText: 'Creating',
                          icon: Icon(
                            Icons.add_circle,
                          ),
                        );
                  ;
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
