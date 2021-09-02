import 'package:flutter/material.dart';

class ProfilePictureWidget extends StatelessWidget {
  final String imageUrl;
  final double size;

  ProfilePictureWidget({
    Key? key,
    required this.imageUrl,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.yellow,
      backgroundImage: imageUrl.length == 0 ? null : NetworkImage(imageUrl),
      child: imageUrl.length == 0
          ? Icon(
              Icons.person,
              size: size / 2,
              color: Colors.white,
            )
          : null,
      radius: size / 2,
    );
  }
}
