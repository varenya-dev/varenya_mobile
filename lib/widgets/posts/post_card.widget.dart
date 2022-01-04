import 'package:flutter/material.dart';
import 'package:varenya_mobile/models/post/post.model.dart';
import 'package:varenya_mobile/widgets/posts/image_carousel.widget.dart';
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
        children: [
          PostUserDetails(
            serverUser: post.user,
          ),
          ImageCarousel(
            imageUrls: post.images,
          ),
        ],
      ),
    );
  }
}
