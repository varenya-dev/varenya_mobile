// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_account_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterAccountDto _$RegisterAccountDtoFromJson(Map<String, dynamic> json) =>
    RegisterAccountDto(
      fullName: json['fullName'] as String,
      imageUrl: json['imageUrl'] as String,
      emailAddress: json['emailAddress'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$RegisterAccountDtoToJson(RegisterAccountDto instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'imageUrl': instance.imageUrl,
      'emailAddress': instance.emailAddress,
      'password': instance.password,
    };
