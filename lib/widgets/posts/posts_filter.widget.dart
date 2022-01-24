import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/exceptions/server.exception.dart';
import 'package:varenya_mobile/models/post/post_category/post_category.model.dart';
import 'package:varenya_mobile/services/post.service.dart';
import 'package:varenya_mobile/utils/logger.util.dart';

class PostsFilter extends StatefulWidget {
  final Function selectCategory;
  final VoidCallback resetCategory;
  final String categoryName;

  const PostsFilter({
    Key? key,
    required this.selectCategory,
    required this.categoryName,
    required this.resetCategory,
  }) : super(key: key);

  @override
  State<PostsFilter> createState() => _PostsFilterState();
}

class _PostsFilterState extends State<PostsFilter> {
  late final PostService _postService;
  List<PostCategory>? _categories;

  @override
  void initState() {
    super.initState();

    this._postService = Provider.of<PostService>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        FutureBuilder(
          future: this._postService.fetchCategories(),
          builder: (BuildContext context,
              AsyncSnapshot<List<PostCategory>> snapshot) {
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
                      "CategorizedPosts:_openPostCategoriesFilters Error",
                      snapshot.error,
                      snapshot.stackTrace,
                    );
                    return Text(
                      "Something went wrong, please try again later",
                    );
                  }
              }
            }

            if (snapshot.connectionState == ConnectionState.done) {
              this._categories = snapshot.data!;
              return _buildCategoriesBody();
            }

            return this._categories == null
                ? Column(
                    children: [
                      CircularProgressIndicator(),
                    ],
                  )
                : this._buildCategoriesBody();
          },
        ),
        Center(
          child: TextButton(
            child: Text('Clear Filters'),
            onPressed: this.widget.resetCategory,
          ),
        )
      ],
    );
  }

  Widget _buildCategoriesBody() {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: this
          ._categories!
          .map(
            (category) => ListTile(
              title: Text(
                category.categoryName,
              ),
              leading: Radio(
                value: category.categoryName,
                groupValue: this.widget.categoryName,
                onChanged: (String? categoryValue) {
                  this.widget.selectCategory(categoryValue);
                },
              ),
            ),
          )
          .toList(),
    );
  }
}
