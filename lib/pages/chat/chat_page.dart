import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/models/chat/chat/chat.dart';
import 'package:varenya_mobile/models/chat/chat_thread/chat_thread.dart';
import 'package:varenya_mobile/services/chat_service.dart';
import 'package:varenya_mobile/widgets/common/custom_field_widget.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  static const routeName = "/chat";

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late ChatService _chatService;
  late ChatThread _chatThread;
  List<Chat> _chats = [];

  final TextEditingController _chatController = new TextEditingController();
  final GlobalKey<FormState> _formKey = new GlobalKey();

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

    this._chatController.dispose();
  }

  Future<void> onMessageSubmit() async {
    if (!this._formKey.currentState!.validate()) {
      return;
    }

    await this
        ._chatService
        .sendMessage(this._chatController.text, this._chatThread);
  }

  @override
  Widget build(BuildContext context) {
    String id = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: this._chatService.listenToThread(id),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                    snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }

              this._chats.clear();

              if (snapshot.data!.data() != null) {
                this._chatThread = ChatThread.fromJson(snapshot.data!.data()!);
                this._chatThread.messages.sort(
                    (Chat a, Chat b) => a.timestamp.compareTo(b.timestamp));
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: this._chatThread.messages.length,
                itemBuilder: (context, index) {
                  Chat chat = this._chatThread.messages[index];
                  return Text(chat.message);
                },
              );
            },
          ),
          Form(
            key: this._formKey,
            child: CustomFieldWidget(
              textFieldController: this._chatController,
              label: "Your Message",
              validators: [
                RequiredValidator(errorText: "Please type in your message")
              ],
              textInputType: TextInputType.text,
              suffixIcon: IconButton(
                icon: Icon(Icons.send),
                onPressed: this.onMessageSubmit,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
