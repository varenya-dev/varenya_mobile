import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/exceptions/server.exception.dart';
import 'package:varenya_mobile/models/post/post.model.dart';
import 'package:varenya_mobile/models/post/post_category/post_category.model.dart';
import 'package:varenya_mobile/services/post.service.dart';
import 'package:varenya_mobile/utils/logger.util.dart';
import 'package:varenya_mobile/utils/modal_bottom_sheet.dart';
import 'package:varenya_mobile/widgets/posts/display_categories.widget.dart';
import 'package:varenya_mobile/widgets/posts/post_card.widget.dart';
import 'package:varenya_mobile/widgets/posts/posts_filter.widget.dart';
import 'package:varenya_mobile/widgets/posts/select_categories.widget.dart';

class CategorizedPosts extends StatefulWidget {
  const CategorizedPosts({Key? key}) : super(key: key);

  static const routeName = "/categorized-posts";

  @override
  _CategorizedPostsState createState() => _CategorizedPostsState();
}

class _CategorizedPostsState extends State<CategorizedPosts> {
  late final PostService _postService;
  String _categoryName = 'NEW';
  String _categoryId = '';
  List<Post>? _posts;

  @override
  void initState() {
    super.initState();

    this._postService = Provider.of<PostService>(context, listen: false);
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
      backgroundColor: Colors.grey[900],
      context: context,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (context, setStateInner) => SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.25,
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.03,
              left: MediaQuery.of(context).size.width * 0.03,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.filter_list_outlined,
                      size: MediaQuery.of(context).size.width * 0.08,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.02,
                      ),
                      child: Text(
                        'Filters',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.03,
                        ),
                      ),
                    )
                  ],
                ),
                DisplayCategories(
                  selectedCategories: [
                    new PostCategory(
                      id: this._categoryId,
                      categoryName: this._categoryName,
                    ),
                  ],
                  addOrRemoveCategory: (PostCategory category) {
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

                    setStateInner(() {});
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
        centerTitle: true,
        backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
            onPressed: this._openPostCategoriesFilters,
            icon: Icon(
              Icons.filter_list_outlined,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              FutureBuilder(
                future:
                    this._postService.fetchPostsByCategory(this._categoryName),
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

  Widget _buildFilter() {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.03,
        horizontal: MediaQuery.of(context).size.width * 0.05,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Show Posts By'),
          GestureDetector(
            onTap: this._openPostCategoriesFilters,
            child: Text(
              this._categoryName,
              style: TextStyle(
                color: Colors.yellow,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
