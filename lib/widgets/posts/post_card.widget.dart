import 'package:flutter/material.dart';
import 'package:varenya_mobile/models/post/post.model.dart';
import 'package:varenya_mobile/widgets/posts/image_carousel.widget.dart';
import 'package:varenya_mobile/widgets/posts/post_categories.widget.dart';
import 'package:varenya_mobile/widgets/posts/post_user_details.widget.dart';

class PostCard extends StatelessWidget {
  final Post post;

  PostCard({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.05,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PostUserDetails(
              postId: this.post.id,
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
          ],
        ),
      ),
    );
  }
}
