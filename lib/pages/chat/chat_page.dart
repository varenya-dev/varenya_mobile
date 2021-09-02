import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/models/chat/chat/chat.dart';
import 'package:varenya_mobile/models/chat/chat_thread/chat_thread.dart';
import 'package:varenya_mobile/services/chat_service.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  static const routeName = "/chat";

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late ChatService _chatService;
  List<Chat> _chats = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this._chatService = Provider.of<ChatService>(context, listen: false);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String id = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: this._chatService.listenToThread(id),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          this._chats.clear();

          if (snapshot.data!.data() != null) {
            ChatThread chatThread = ChatThread.fromJson(snapshot.data!.data()!);
            this._chats = chatThread.messages;
            this
                ._chats
                .sort((Chat a, Chat b) => a.timestamp.compareTo(b.timestamp));
          }

          return ListView.builder(
            itemCount: this._chats.length,
            itemBuilder: (context, index) {
              Chat chat = this._chats[index];
              return Text(chat.message);
            },
          );
        },
      ),
    );
  }
}
