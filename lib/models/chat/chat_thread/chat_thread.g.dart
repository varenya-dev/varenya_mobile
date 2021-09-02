// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_thread.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatThread _$ChatThreadFromJson(Map<String, dynamic> json) {
  return ChatThread(
    participants: (json['participants'] as List<dynamic>)
        .map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>)
        .map((e) => Chat.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$ChatThreadToJson(ChatThread instance) =>
    <String, dynamic>{
      'participants': instance.participants,
      'messages': instance.messages,
    };
