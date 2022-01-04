import 'package:flutter/material.dart';
import 'package:varenya_mobile/widgets/posts/post_card.widget.dart';

class NewPosts extends StatefulWidget {
  const NewPosts({Key? key}) : super(key: key);

  static const routeName = "/new-posts";

  @override
  _NewPostsState createState() => _NewPostsState();
}

class _NewPostsState extends State<NewPosts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
      ),
      body: Column(
        children: [
          PostCard(),
        ],
      ),
    );
  }
}
