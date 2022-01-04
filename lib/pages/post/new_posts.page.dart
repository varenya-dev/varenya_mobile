import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/enum/post_type.enum.dart';
import 'package:varenya_mobile/enum/roles.enum.dart';
import 'package:varenya_mobile/exceptions/server.exception.dart';
import 'package:varenya_mobile/models/doctor/doctor.model.dart';
import 'package:varenya_mobile/models/post/post.model.dart';
import 'package:varenya_mobile/models/post/post_category/post_category.model.dart';
import 'package:varenya_mobile/models/post/post_image/post_image.model.dart';
import 'package:varenya_mobile/models/user/random_name/random_name.model.dart';
import 'package:varenya_mobile/models/user/server_user.model.dart';
import 'package:varenya_mobile/services/post.service.dart';
import 'package:varenya_mobile/widgets/posts/post_card.widget.dart';

class NewPosts extends StatefulWidget {
  const NewPosts({Key? key}) : super(key: key);

  static const routeName = "/new-posts";

  @override
  _NewPostsState createState() => _NewPostsState();
}

class _NewPostsState extends State<NewPosts> {
  late final PostService _postService;

  @override
  void initState() {
    super.initState();

    this._postService = Provider.of<PostService>(context, listen: false);
  }

  final Post dummyPost = new Post(
    id: 'lol',
    postType: PostType.Post,
    body: 'oii',
    images: [
      new PostImage(id: '1', imageUrl: 'https://picsum.photos/id/200/300'),
      new PostImage(id: '2', imageUrl: 'https://picsum.photos/id/200/500'),
      new PostImage(id: '3', imageUrl: 'https://picsum.photos/id/600/300'),
      new PostImage(id: '4', imageUrl: 'https://picsum.photos/id/100/300'),
    ],
    user: new ServerUser(
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
    ),
    comments: [],
    categories: [
      new PostCategory(id: 'lol', categoryName: 'LOL'),
      new PostCategory(id: 'lol', categoryName: 'LOL'),
      new PostCategory(id: 'lol', categoryName: 'LOL'),
      new PostCategory(id: 'lol', categoryName: 'LOL'),
    ],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: this._postService.fetchNewPosts(),
          builder: (
            BuildContext context,
            AsyncSnapshot<List<Post>> snapshot,
          ) {
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
                    print(snapshot.error);
                    return Text("Something went wrong, please try again later");
                  }
              }
            }

            if (snapshot.connectionState == ConnectionState.done) {
              List<Post> posts = snapshot.data!;

              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: posts.length,
                itemBuilder: (BuildContext context, int index) {
                  Post post = posts[index];

                  return PostCard(
                    post: post,
                  );
                },
              );
            }

            return Column(
              children: [
                CircularProgressIndicator(),
              ],
            );
          },
        ),
      ),
    );
  }
}
