import 'package:flutter/material.dart';
import 'package:varenya_mobile/models/post/post.model.dart';
import 'package:varenya_mobile/widgets/posts/image_carousel.widget.dart';
import 'package:varenya_mobile/widgets/posts/post_categories.widget.dart';
import 'package:varenya_mobile/widgets/posts/post_user_details.widget.dart';
import 'package:varenya_mobile/pages/post/post.page.dart' as PostPage;

class PostCard extends StatelessWidget {
  final Post post;
  final bool fullPagePost;

  PostCard({
    Key? key,
    required this.post,
    this.fullPagePost = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: fullPagePost
          ? () {}
          : () {
              Navigator.of(context).pushNamed(
                PostPage.Post.routeName,
                arguments: this.post.id,
              );
            },
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PostUserDetails(
              post: this.post,
              serverUser: this.post.user,
            ),
            Container(
              margin: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.03,
              ),
              child: Text(
                this.post.body,
              ),
            ),
            PostCategories(
              categories: this.post.categories,
            ),
            ImageCarousel(
              imageUrls: post.images,
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
