import 'package:flutter/material.dart';
import 'package:varenya_mobile/enum/roles.enum.dart';
import 'package:varenya_mobile/models/doctor/doctor.model.dart';
import 'package:varenya_mobile/models/post/post_image/post_image.model.dart';
import 'package:varenya_mobile/models/user/random_name/random_name.model.dart';
import 'package:varenya_mobile/models/user/server_user.model.dart';
import 'package:varenya_mobile/widgets/posts/image_carousel.widget.dart';
import 'package:varenya_mobile/widgets/posts/post_user_details.widget.dart';

class PostCard extends StatelessWidget {
  PostCard({Key? key}) : super(key: key);

  final List<PostImage> dummyImages = [
    new PostImage(id: '1', imageUrl: 'https://picsum.photos/id/200/300'),
    new PostImage(id: '2', imageUrl: 'https://picsum.photos/id/200/500'),
    new PostImage(id: '3', imageUrl: 'https://picsum.photos/id/600/300'),
    new PostImage(id: '4', imageUrl: 'https://picsum.photos/id/100/300'),
  ];

  final ServerUser dummyUser = new ServerUser(
    id: 'lol',
    firebaseId: 'lol',
    role: Roles.MAIN,
    doctor: new Doctor(
      id: 'id',
      fullName: 'Full Name',
      imageUrl: 'https://picsum.photos/200/',
      shiftStartTime: DateTime.now(),
      shiftEndTime: DateTime.now(),
    ),
    randomName: new RandomName(
      id: 'lol',
      randomName: 'randomName',
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          PostUserDetails(
            serverUser: dummyUser,
          ),
          ImageCarousel(
            imageUrls: dummyImages,
          ),
        ],
      ),
    );
  }
}
