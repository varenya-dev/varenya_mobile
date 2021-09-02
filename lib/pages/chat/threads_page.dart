import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/models/chat/chat_thread/chat_thread.dart';
import 'package:varenya_mobile/pages/chat/chat_page.dart';
import 'package:varenya_mobile/services/chat_service.dart';

class ThreadsPage extends StatefulWidget {
  const ThreadsPage({Key? key}) : super(key: key);

  static const routeName = "/threads";

  @override
  _ThreadsPageState createState() => _ThreadsPageState();
}

class _ThreadsPageState extends State<ThreadsPage> {
  late ChatService _chatService;
  List<ChatThread> _threads = [];
  late StreamSubscription _threadsSubscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this._chatService = Provider.of<ChatService>(context, listen: false);

    this._listenToThreads();
  }

  void _listenToThreads() {
    setState(() {
      this._threadsSubscription =
          this._chatService.fetchAllThreads().listen((threads) {
        this._threads.clear();

        setState(() {
          threads.docs.forEach((thread) {
            this._threads.add(ChatThread.fromJson(thread.data()));
          });
        });
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    this._threadsSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Threads'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: this._chatService.fetchAllThreads(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          this._threads.clear();
          snapshot.data!.docs.forEach((thread) {
            this._threads.add(ChatThread.fromJson(thread.data()));
          });

          return ListView.builder(
            itemCount: this._threads.length,
            itemBuilder: (context, index) {
              ChatThread thread = this._threads[index];
              return ListTile(
                leading: Icon(Icons.person),
                title: Text(thread.id),
                subtitle: Text(thread.participants.join(", ")),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    ChatPage.routeName,
                    arguments: thread.id,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
