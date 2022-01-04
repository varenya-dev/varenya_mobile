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
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PostUserDetails(
            serverUser: post.user,
          ),
          PostCategories(
            categories: this.post.categories,
          ),
          ImageCarousel(
            imageUrls: post.images,
          ),
        ],
      ),
    );
  }
}
