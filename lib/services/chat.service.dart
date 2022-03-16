import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:varenya_mobile/exceptions/server.exception.dart';
import 'package:varenya_mobile/models/chat/chat/chat.model.dart';
import 'package:uuid/uuid.dart';
import 'package:varenya_mobile/models/chat/chat_thread/thread.model.dart';
import 'package:http/http.dart' as http;
import 'package:varenya_mobile/utils/logger.util.dart';

/*
 * Service implementation for chat module.
 */
class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Uuid uuid = new Uuid();

  final String apiUrl;
  final String rawApiUrl;

  ChatService({
    required this.apiUrl,
    required this.rawApiUrl,
  });

  /*
   * Method to create a new chat thread.
   * @param userId ID to create a chat thread with.
   */
  Future<String> createNewThread(String userId) async {
    // Get logged in user ID.
    String loggedInUserId = this._auth.currentUser!.uid;

    // Preparing participants list.
    List<String> participants = [
      userId,
      loggedInUserId,
    ];

    String checkForDuplicates =
        await this._checkForExistingThreads(participants);

    if (checkForDuplicates != 'EMPTY') {
      return checkForDuplicates;
    }

    // Generate a document ID from an empty document.
    DocumentReference threadDocumentReference =
        this._firestore.collection('threads').doc();

    // Preparing chat thread object
    Thread chatThread = new Thread(
      id: threadDocumentReference.id,
      participants: participants,
      messages: [],
    );

    // Save chat thread object to firestore.
    await this
        ._firestore
        .collection('threads')
        .doc(chatThread.id)
        .set(chatThread.toJson());

    // Return the thread id.
    return threadDocumentReference.id;
  }

  Future<String> _checkForExistingThreads(List<String> participants) async {
    QuerySnapshot firstChatQuerySnapshot = await this
        ._firestore
        .collection('threads')
        .where("participants", whereIn: [participants]).get();

    QuerySnapshot secondChatQuerySnapshot = await this
        ._firestore
        .collection('threads')
        .where("participants", whereIn: [participants.reversed.toList()]).get();

    List<DocumentSnapshot> firstChatDocumentSnapshotList =
        firstChatQuerySnapshot.docs;
    List<DocumentSnapshot> secondChatDocumentSnapshotList =
        secondChatQuerySnapshot.docs;

    if (firstChatDocumentSnapshotList.isNotEmpty &&
        firstChatDocumentSnapshotList[0].exists) {
      return firstChatDocumentSnapshotList[0].reference.id;
    } else if (secondChatDocumentSnapshotList.isNotEmpty &&
        secondChatDocumentSnapshotList[0].exists) {
      return secondChatDocumentSnapshotList[0].reference.id;
    } else {
      return 'EMPTY';
    }
  }

  /*
   * Method to fetch all threads the user is part of.
   */
  Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllThreads() => this
      ._firestore
      .collection('threads')
      .where("participants", arrayContains: this._auth.currentUser!.uid)
      .snapshots();

  /*
   * Method to fetch all chats in a given thread.
   * @param id Thread ID to be fetched.
   */
  Stream<DocumentSnapshot<Map<String, dynamic>>> listenToThread(String id) =>
      this._firestore.collection('threads').doc(id).snapshots();

  /*
   * Method to save a chat message in a given thread.
   * @param message Message text to be saved.
   * @param thread Thread where the message is to be saved.
   */
  Future<void> sendMessage(String message, Thread thread) async {
    // Create the chat message object based on the message.
    Chat chatMessage = new Chat(
      id: uuid.v4(),
      userId: this._auth.currentUser!.uid,
      message: message,
      timestamp: DateTime.now(),
    );

    // Add it to the chat list in the thread.
    thread.messages.add(chatMessage);

    // Convert all to JSON and update the same in firestore.
    Map<String, dynamic> jsonData = thread.toJson();
    jsonData['messages'] =
        jsonData['messages'].map((Chat message) => message.toJson()).toList();
    await this._firestore.collection("threads").doc(thread.id).set(jsonData);

    await this._sendChatNotification(thread.id, message);
  }

  /*
   * Method to delete a chat message in a given thread.
   * @param id ID for the message to be deleted.
   * @param thread Thread from which the message is needed to be deleted.
   */
  Future<void> deleteMessage(String id, Thread thread) async {
    // Filter out the message list using the message ID.
    thread.messages = thread.messages.where((chat) => chat.id != id).toList();

    // Convert all to JSON and update the same in firestore.
    Map<String, dynamic> jsonData = thread.toJson();
    jsonData['messages'] =
        jsonData['messages'].map((Chat message) => message.toJson()).toList();
    await this._firestore.collection("threads").doc(thread.id).set(jsonData);
  }

  /*
   * Close chat thread in firestore.
   */
  Future<void> closeThread(Thread thread) async =>
      await this._firestore.collection("threads").doc(thread.id).delete();

  Future<void> _sendChatNotification(String threadId, String message) async {
    // Fetch the ID token for the user.
    String firebaseAuthToken = await this._auth.currentUser!.getIdToken();

    // Prepare URI for the request.
    Uri uri = Uri.parse("$apiUrl/notification/chat");

    // Prepare authorization headers.
    Map<String, String> headers = {
      "Authorization": "Bearer $firebaseAuthToken",
    };

    // Preparing body for the request.
    Map<String, String> body = {
      "threadId": threadId,
      "message": message,
    };

    // Send the post request to the server.
    http.Response response = await http.post(
      uri,
      headers: headers,
      body: body,
    );

    // Check for any errors.
    if (response.statusCode >= 400 && response.statusCode < 500) {
      Map<String, dynamic> body = json.decode(response.body);
      throw ServerException(message: body['message']);
    } else if (response.statusCode >= 500) {
      Map<String, dynamic> body = json.decode(response.body);
      log.e("ChatService:_sendChatNotification Error", body['message']);
      throw ServerException(
          message: 'Something went wrong, please try again later.');
    }
  }
}
