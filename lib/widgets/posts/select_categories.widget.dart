import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/exceptions/server.exception.dart';
import 'package:varenya_mobile/models/post/post_category/post_category.model.dart';
import 'package:varenya_mobile/services/post.service.dart';
import 'package:varenya_mobile/utils/logger.util.dart';

class SelectCategories extends StatefulWidget {
  final List<PostCategory> categories;
  final Function onChanged;
  final VoidCallback onClear;

  const SelectCategories({
    Key? key,
    required this.categories,
    required this.onChanged,
    required this.onClear,
  }) : super(key: key);

  @override
  State<SelectCategories> createState() => _SelectCategoriesState();
}

class _SelectCategoriesState extends State<SelectCategories> {
  late final PostService _postService;
  List<PostCategory>? _fetchedCategories;

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
                      "NewPost:_openPostCategories Error",
                      snapshot.error,
                      snapshot.stackTrace,
                    );
                    return Text("Something went wrong, please try again later");
                  }
              }
            }

            if (snapshot.connectionState == ConnectionState.done) {
              this._fetchedCategories = snapshot.data!;
              return _buildCategoriesBody();
            }

            return this._fetchedCategories == null
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
            onPressed: this.widget.onClear,
          ),
        )
      ],
    );
  }

  ListView _buildCategoriesBody() {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: this
          ._fetchedCategories!
          .map(
            (category) => ListTile(
              title: Text(
                category.categoryName,
              ),
              leading: Checkbox(
                value: this
                    .widget
                    .categories
                    .where((cty) => cty.id == category.id)
                    .isNotEmpty,
                onChanged: (bool? value) {
                  this.widget.onChanged(value, category);
                },
              ),
            ),
          )
          .toList(),
    );
  }
}
