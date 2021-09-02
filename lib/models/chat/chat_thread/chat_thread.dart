import 'package:json_annotation/json_annotation.dart';
import 'package:varenya_mobile/models/chat/chat/chat.dart';

part 'chat_thread.g.dart';

@JsonSerializable()
class ChatThread {
  String id;
  List<String> participants;
  List<Chat> messages;

  ChatThread({
    required this.id,
    required this.participants,
    required this.messages,
  });

  factory ChatThread.fromJson(Map<String, dynamic> json) =>
      _$ChatThreadFromJson(json);

  Map<String, dynamic> toJson() => _$ChatThreadToJson(this);
}
