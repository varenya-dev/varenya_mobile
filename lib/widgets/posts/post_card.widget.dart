import 'package:flutter/material.dart';
import 'package:varenya_mobile/models/post/post_image/post_image.model.dart';
import 'package:varenya_mobile/widgets/posts/image_carousel.widget.dart';

class PostCard extends StatelessWidget {
  PostCard({Key? key}) : super(key: key);

  final List<PostImage> dummyImages = [
    new PostImage(id: '1', imageUrl: 'https://picsum.photos/id/237/200/300'),
    new PostImage(id: '2', imageUrl: 'https://picsum.photos/id/237/200/500'),
    new PostImage(id: '3', imageUrl: 'https://picsum.photos/id/237/600/300'),
    new PostImage(id: '4', imageUrl: 'https://picsum.photos/id/237/100/300'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ImageCarousel(
            imageUrls: dummyImages,
          ),
        ],
      ),
    );
  }
}
