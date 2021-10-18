import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/models/chat/chat/chat.dart';
import 'package:varenya_mobile/models/chat/chat_thread/chat_thread.dart';
import 'package:varenya_mobile/services/chat_service.dart';
import 'package:varenya_mobile/widgets/chat/chat_bubble_widget.dart';
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
    super.initState();

    // Injecting the required services.
    this._chatService = Provider.of<ChatService>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();

    // Disposing off the text controllers.
    this._chatController.dispose();
  }

  /*
   * Method to handle chat message submission.
   */
  Future<void> onMessageSubmit() async {
    // Check the validity of the form.
    if (!this._formKey.currentState!.validate()) {
      return;
    }

    // Save the message in database in the given thread.
    await this
        ._chatService
        .sendMessage(this._chatController.text, this._chatThread);
  }

  /*
   * Method to handle deleting chat message.
   */
  Future<void> onMessageDelete(String id) async {
    // Delete the message from the thread.
    await this._chatService.deleteMessage(id, this._chatThread);
  }

  /*
   * Method to handle closing a thread.
   */
  Future<void> onThreadClose() async {
    // Close the thread and pop off from the chat screen.
    await this._chatService.closeThread(this._chatThread);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    String id = ModalRoute.of(context)!.settings.arguments as String;

    AppBar appBar = AppBar(
      title: Text('Chat'),
      actions: [
        TextButton(
          onPressed: this.onThreadClose,
          child: Text('Close Chat'),
        ),
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
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

              ScrollController controller = ScrollController();

              SchedulerBinding.instance!.addPostFrameCallback((_) {
                controller.jumpTo(controller.position.maxScrollExtent);
              });

              return Expanded(
                child: ListView.builder(
                  controller: controller,
                  shrinkWrap: true,
                  itemCount: this._chatThread.messages.length,
                  itemBuilder: (context, index) {
                    Chat chat = this._chatThread.messages[index];
                    return ChatBubbleWidget(
                      chat: chat,
                      onDelete: this.onMessageDelete,
                    );
                  },
                ),
              );
            },
          ),
          Container(
            child: Form(
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
          ),
        ],
      ),
    );
  }
}