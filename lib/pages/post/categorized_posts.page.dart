import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/exceptions/server.exception.dart';
import 'package:varenya_mobile/models/post/post.model.dart';
import 'package:varenya_mobile/models/post/post_category/post_category.model.dart';
import 'package:varenya_mobile/providers/user_provider.dart';
import 'package:varenya_mobile/services/auth_service.dart';
import 'package:varenya_mobile/services/post.service.dart';
import 'package:varenya_mobile/utils/logger.util.dart';
import 'package:varenya_mobile/utils/responsive_config.util.dart';
import 'package:varenya_mobile/widgets/posts/display_create_post.widget.dart';
import 'package:varenya_mobile/widgets/posts/post_card.widget.dart';
import 'package:varenya_mobile/widgets/posts/post_filter.widget.dart';

class CategorizedPosts extends StatefulWidget {
  const CategorizedPosts({Key? key}) : super(key: key);

  static const routeName = "/categorized-posts";

  @override
  _CategorizedPostsState createState() => _CategorizedPostsState();
}

class _CategorizedPostsState extends State<CategorizedPosts> {
  late final PostService _postService;
  late final AuthService _authService;

  String _categoryName = 'NEW';
  String _categoryId = '';
  List<Post>? _posts;

  @override
  void initState() {
    super.initState();

    this._postService = Provider.of<PostService>(context, listen: false);
    this._authService = Provider.of<AuthService>(context, listen: false);
  }

  void _openPostCategoriesFilters() {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            15.0,
          ),
          topRight: Radius.circular(
            15.0,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      context: context,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (context, setStateInner) => PostFilter(
          addOrRemoveCategory: (PostCategory category) {
            _handleAddOrRemoveCategory(category);

            setStateInner(() {});
          },
          categoryName: this._categoryName,
          categoryId: this._categoryId,
        ),
      ),
    );
  }

  void _handleAddOrRemoveCategory(PostCategory category) {
    if (this._categoryName == category.categoryName) {
      setState(() {
        this._categoryName = 'NEW';
        this._categoryId = '';
      });
    } else {
      setState(() {
        this._categoryName = category.categoryName;
        this._categoryId = category.id;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: responsiveConfig(
                  context: context,
                  large: MediaQuery.of(context).size.width * 0.25,
                  medium: MediaQuery.of(context).size.width * 0.25,
                  small: 0,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    height: responsiveConfig(
                      context: context,
                      large: MediaQuery.of(context).size.height * 0.2,
                      medium: MediaQuery.of(context).size.height * 0.2,
                      small: MediaQuery.of(context).size.height * 0.16,
                    ),
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black54,
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.05,
                      vertical: MediaQuery.of(context).size.height * 0.05,
                    ),
                    child: Consumer<UserProvider>(
                      builder:
                          (BuildContext context, UserProvider userProvider, _) {
                        User user = userProvider.user;

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Hello, ${user.displayName?.split(' ')[0]}',
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.06,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            PopupMenuButton(
                              padding: EdgeInsets.zero,
                              color: Colors.grey[900],
                              child: CircleAvatar(
                                radius: 50.0,
                                backgroundColor: Colors.transparent,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      100.0,
                                    ),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 3,
                                    ),
                                  ),
                                  padding: EdgeInsets.all(
                                    5,
                                  ),
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              onSelected: (int result) async {
                                if (result == 1) {
                                  await this._authService.logOut();
                                }
                              },
                              itemBuilder: (BuildContext context) => [
                                PopupMenuItem(
                                  value: 0,
                                  child: Text(
                                    'Logged In As: ${user.displayName ?? ''}',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 1,
                                  child: Text(
                                    'Log Out',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.01,
                      horizontal: MediaQuery.of(context).size.width * 0.06,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Filter Posts'),
                        TextButton(
                          onPressed: this._openPostCategoriesFilters,
                          child: Text('Open Filters'),
                        ),
                      ],
                    ),
                  ),
                  DisplayCreatePost(),
                  FutureBuilder(
                    future: this
                        ._postService
                        .fetchPostsByCategory(this._categoryName),
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<List<Post>> snapshot,
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
                                "CategorizedPosts Error",
                                snapshot.error,
                                snapshot.stackTrace,
                              );
                              return Text(
                                  "Something went wrong, please try again later");
                            }
                        }
                      }

                      if (snapshot.connectionState == ConnectionState.done) {
                        this._posts = snapshot.data!;

                        return _buildPostsList();
                      }

                      return this._posts == null
                          ? Column(
                              children: [
                                CircularProgressIndicator(),
                              ],
                            )
                          : this._buildPostsList();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ListView _buildPostsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: this._posts!.length,
      itemBuilder: (BuildContext context, int index) {
        Post post = this._posts![index];

        return PostCard(
          post: post,
        );
      },
    );
  }
}
