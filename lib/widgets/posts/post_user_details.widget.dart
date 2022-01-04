import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/enum/post_options_type.enum.dart';
import 'package:varenya_mobile/enum/roles.enum.dart';
import 'package:varenya_mobile/models/user/server_user.model.dart';
import 'package:varenya_mobile/providers/user_provider.dart';
import 'package:varenya_mobile/widgets/common/profile_picture_widget.dart';

class PostUserDetails extends StatelessWidget {
  final ServerUser serverUser;

  const PostUserDetails({
    Key? key,
    required this.serverUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        this.serverUser.role == Roles.PROFESSIONAL
            ? Row(
                children: [
                  Container(
                    margin: EdgeInsets.all(10.0),
                    child: ProfilePictureWidget(
                      imageUrl: this.serverUser.doctor!.imageUrl,
                      size: 40,
                    ),
                  ),
                  Text(
                    "Dr. ${this.serverUser.doctor!.fullName} posted",
                  ),
                ],
              )
            : Row(
                children: [
                  Container(
                    margin: EdgeInsets.all(10.0),
                    child: ProfilePictureWidget(
                      imageUrl: '',
                      size: 40,
                    ),
                  ),
                  Text(
                    "${this.serverUser.randomName!.randomName} posted",
                  ),
                ],
              ),
        Column(
          children: [
            Consumer<UserProvider>(
              builder: (context, user, _) => this.serverUser.firebaseId ==
                      user.user.uid
                  ? Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.05,
                      ),
                      child: PopupMenuButton(
                        enabled: true,
                        child: Icon(Icons.more_vert),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: Text("Update Post"),
                            value: PostOptionsType.UPDATE,
                          ),
                          PopupMenuItem(
                            child: Text("Delete Post"),
                            value: PostOptionsType.DELETE,
                          ),
                        ],
                        onSelected: (PostOptionsType selectedData) {
                          if (selectedData == PostOptionsType.UPDATE) {}
                          if (selectedData == PostOptionsType.DELETE) {}
                        },
                      ),
                    )
                  : SizedBox(),
            ),
          ],
        ),
      ],
    );
  }
}
