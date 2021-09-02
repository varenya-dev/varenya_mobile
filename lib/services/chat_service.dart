import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:varenya_mobile/models/chat/chat/chat.dart';
import 'package:uuid/uuid.dart';
import 'package:varenya_mobile/models/chat/chat_thread/chat_thread.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Uuid uuid = new Uuid();

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllThreads() => this
      ._firestore
      .collection('threads')
      .where("participants", arrayContains: this._auth.currentUser!.uid)
      .snapshots();

  Stream<DocumentSnapshot<Map<String, dynamic>>> listenToThread(String id) =>
      this._firestore.collection('threads').doc(id).snapshots();

  Future<void> sendMessage(String message, ChatThread thread) async {
    Chat chatMessage = new Chat(
      id: uuid.v4(),
      userId: this._auth.currentUser!.uid,
      message: message,
      timestamp: DateTime.now(),
    );

    thread.messages.add(chatMessage);

    Map<String, dynamic> jsonData = thread.toJson();
    jsonData['messages'] =
        jsonData['messages'].map((Chat message) => message.toJson()).toList();

    await this._firestore.collection("threads").doc(thread.id).set(jsonData);
  }

  Future<void> deleteMessage(String id, ChatThread thread) async {
    thread.messages = thread.messages.where((chat) => chat.id != id).toList();

    Map<String, dynamic> jsonData = thread.toJson();
    jsonData['messages'] =
        jsonData['messages'].map((Chat message) => message.toJson()).toList();

    await this._firestore.collection("threads").doc(thread.id).set(jsonData);
  }

  Future<void> closeThread(ChatThread thread) async {
    await this._firestore.collection("threads").doc(thread.id).delete();
  }
}
