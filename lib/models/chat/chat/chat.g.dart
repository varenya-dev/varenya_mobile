// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chat _$ChatFromJson(Map<String, dynamic> json) {
  return Chat(
    userId: json['userId'] as String,
    message: json['message'] as String,
  );
}

Map<String, dynamic> _$ChatToJson(Chat instance) => <String, dynamic>{
      'userId': instance.userId,
      'message': instance.message,
    };
