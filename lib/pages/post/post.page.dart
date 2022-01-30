import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/dtos/comments/create_comment/create_comment.dto.dart';
import 'package:varenya_mobile/exceptions/auth/not_logged_in_exception.dart';
import 'package:varenya_mobile/exceptions/server.exception.dart';
import 'package:varenya_mobile/models/post/post.model.dart' as PM;
import 'package:varenya_mobile/services/comments.service.dart';
import 'package:varenya_mobile/services/post.service.dart';
import 'package:varenya_mobile/utils/logger.util.dart';
import 'package:varenya_mobile/utils/snackbar.dart';
import 'package:varenya_mobile/widgets/comments/comment_form.widget.dart';
import 'package:varenya_mobile/widgets/comments/comment_list.widget.dart';
import 'package:varenya_mobile/widgets/posts/full_post_body.widget.dart';
import 'package:varenya_mobile/widgets/posts/full_post_duration.widget.dart';
import 'package:varenya_mobile/widgets/posts/full_post_user_details.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    if (this._postId == null) {
      this._postId = ModalRoute.of(context)!.settings.arguments as String;
    }

    return Scaffold(
      bottomSheet: this._showCommentForm
          ? CommentForm(
              refreshPost: () {
                setState(() {});
              },
              postId: this._post!.id,
            )
          : null,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Posts'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: FutureBuilder(
          future: this._postService.fetchPostsById(this._postId!),
          builder: (
            BuildContext context,
            AsyncSnapshot<PM.Post> snapshot,
          ) {
            if (snapshot.hasError) {
              switch (snapshot.error.runtimeType) {
                case ServerException:
                  {
                    ServerException exception =
                        snapshot.error as ServerException;
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
      ),
    );
  }

  Widget _buildBody() {
    Duration duration = _now.difference(this._post!.createdAt);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.grey[900],
            child: FullPostUserDetails(
              context: context,
              post: _post,
            ),
          ),
          ImageCarousel(
            imageUrls: this._post!.images,
          ),
          FullPostDuration(
            context: context,
            post: _post,
            duration: duration,
          ),
          FullPostBody(
            context: context,
            post: _post,
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
            refreshPost: () {
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
