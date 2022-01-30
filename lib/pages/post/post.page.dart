import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/dtos/comments/create_comment/create_comment.dto.dart';
import 'package:varenya_mobile/dtos/comments/delete_comment/delete_comment.dto.dart';
import 'package:varenya_mobile/enum/comment_form_type.enum.dart';
import 'package:varenya_mobile/enum/roles.enum.dart';
import 'package:varenya_mobile/exceptions/auth/not_logged_in_exception.dart';
import 'package:varenya_mobile/exceptions/server.exception.dart';
import 'package:varenya_mobile/models/post/post.model.dart' as PM;
import 'package:varenya_mobile/services/comments.service.dart';
import 'package:varenya_mobile/services/post.service.dart';
import 'package:varenya_mobile/utils/logger.util.dart';
import 'package:varenya_mobile/utils/modal_bottom_sheet.dart';
import 'package:varenya_mobile/utils/snackbar.dart';
import 'package:varenya_mobile/widgets/comments/comment_form.widget.dart';
import 'package:varenya_mobile/widgets/comments/comment_list.widget.dart';
import 'package:varenya_mobile/widgets/common/custom_text_area.widget.dart';
import 'package:varenya_mobile/widgets/common/profile_picture_widget.dart';
import 'package:varenya_mobile/widgets/posts/image_carousel.widget.dart';

class Post extends StatefulWidget {
  const Post({Key? key}) : super(key: key);

  static const routeName = "/post";

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  String? _postId;
  PM.Post? _post;
  late final PostService _postService;
  late final CommentsService _commentsService;

  final DateTime _now = DateTime.now();

  final TextEditingController _commentController = new TextEditingController();
  final GlobalKey<FormState> _formKey = new GlobalKey();

  bool _showCommentForm = false;

  Future<void> _onFormSubmit() async {
    if (!this._formKey.currentState!.validate()) {
      return;
    }

    try {
      CreateCommentDto createCommentDto = new CreateCommentDto(
        comment: this._commentController.text,
        postId: this._post!.id,
      );

      await this._commentsService.createNewComment(createCommentDto);
      setState(() {});

      displaySnackbar("Comment created!", context);
    } on ServerException catch (error) {
      displaySnackbar(error.message, context);
    } on NotLoggedInException catch (error) {
      displaySnackbar(error.message, context);
    } catch (error, stackTrace) {
      log.e("CommentForm:_onFormSubmit", error, stackTrace);
      displaySnackbar("Something went wrong, please try again later.", context);
    }
  }

  @override
  void dispose() {
    super.dispose();

    this._commentController.dispose();
  }

  @override
  void initState() {
    super.initState();

    this._postService = Provider.of<PostService>(context, listen: false);
    this._commentsService =
        Provider.of<CommentsService>(context, listen: false);
  }

  void _onDeleteComment(BuildContext context, String commentID) {
    displayBottomSheet(
      context,
      Wrap(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text('Are you sure you want to delete this comment?'),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () async {
                  await _confirmCommentDeletion(context, commentID);
                },
                child: Text('YES'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('NO'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onUpdateComment(BuildContext context, PM.Post comment) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Update Comment'),
        content: CommentForm(
          commentFormType: CommentFormType.UPDATE,
          refreshPost: () {
            setState(() {});
          },
          postId: this._post!.id,
          commentId: comment.id,
          text: comment.body,
        ),
      ),
    );
  }

  Future<void> _confirmCommentDeletion(
      BuildContext context, String commentId) async {
    try {
      await this._commentsService.deleteComment(
            new DeleteCommentDto(commentId: commentId),
          );

      setState(() {});

      Navigator.of(context).pop();

      displaySnackbar("Comment Deleted!", context);
    } on ServerException catch (error) {
      displaySnackbar(
        error.message,
        context,
      );
    } on NotLoggedInException catch (error) {
      displaySnackbar(
        error.message,
        context,
      );
    } catch (error, stackTrace) {
      log.e("PostPage:_confirmCommentDeletion", error, stackTrace);
      displaySnackbar(
        "Something went wrong, please try again later.",
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (this._postId == null) {
      this._postId = ModalRoute.of(context)!.settings.arguments as String;
    }

    return Scaffold(
      bottomSheet: this._showCommentForm
          ? Container(
              color: Colors.transparent,
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.03,
                left: MediaQuery.of(context).size.width * 0.03,
                right: MediaQuery.of(context).size.width * 0.03,
              ),
              child: Form(
                key: this._formKey,
                child: CustomTextArea(
                  helperText: 'Type a comment...',
                  textFieldController: this._commentController,
                  validators: [
                    RequiredValidator(
                      errorText: 'Please enter some text',
                    ),
                  ],
                  textInputType: TextInputType.text,
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.chat,
                      color: Colors.yellow,
                    ),
                    onPressed: this._onFormSubmit,
                  ),
                ),
              ),
            )
          : null,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Posts'),
      ),
      body: FutureBuilder(
        future: this._postService.fetchPostsById(this._postId!),
        builder: (
          BuildContext context,
          AsyncSnapshot<PM.Post> snapshot,
        ) {
          if (snapshot.hasError) {
            switch (snapshot.error.runtimeType) {
              case ServerException:
                {
                  ServerException exception = snapshot.error as ServerException;
                  return Text(exception.message);
                }
              default:
                {
                  log.e(
                    "Post Error",
                    snapshot.error,
                    snapshot.stackTrace,
                  );
                  return Text("Something went wrong, please try again later");
                }
            }
          }

          if (snapshot.connectionState == ConnectionState.done) {
            this._post = snapshot.data!;

            return _buildBody();
          }

          return this._post == null
              ? Column(
                  children: [
                    CircularProgressIndicator(),
                  ],
                )
              : _buildBody();
        },
      ),
    );
  }

  SingleChildScrollView _buildBody() {
    Duration duration = _now.difference(this._post!.createdAt);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.grey[900],
            child: Row(
              children: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.01,
                        vertical: MediaQuery.of(context).size.height * 0.01,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.03,
                        vertical: MediaQuery.of(context).size.height * 0.02,
                      ),
                      child: ProfilePictureWidget(
                        imageUrl: this._post!.user.role == Roles.PROFESSIONAL
                            ? this._post!.user.doctor!.imageUrl
                            : '',
                        size: MediaQuery.of(context).size.width * 0.1,
                      ),
                    ),
                    Text(
                      this._post!.user.role == Roles.PROFESSIONAL
                          ? "Dr. ${this._post!.user.doctor!.fullName}"
                          : this._post!.user.randomName!.randomName,
                    )
                  ],
                ),
              ],
            ),
          ),
          ImageCarousel(
            imageUrls: this._post!.images,
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.01,
              vertical: MediaQuery.of(context).size.height * 0.01,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.03,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  this._post!.user.role == Roles.PROFESSIONAL
                      ? "Dr. ${this._post!.user.doctor!.fullName}"
                      : this._post!.user.randomName!.randomName,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                if (duration.inSeconds < 60)
                  Text(
                    '${duration.inSeconds}s ago',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  )
                else if (duration.inSeconds < 3600)
                  Text(
                    '${duration.inMinutes}m ago',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  )
                else
                  Text(
                    '${duration.inHours}h ago',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.01,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.03,
            ),
            child: Text(
              this._post!.body,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.01,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.03,
            ),
            child: TextButton(
              onPressed: () => setState(() {
                this._showCommentForm = !this._showCommentForm;
              }),
              child: Text(
                'Add Comment',
              ),
            ),
          ),
          CommentList(
            comments: this._post!.comments,
            onEditComment: this._onUpdateComment,
            onDeleteComment: this._onDeleteComment,
          ),
        ],
      ),
    );
  }
}
