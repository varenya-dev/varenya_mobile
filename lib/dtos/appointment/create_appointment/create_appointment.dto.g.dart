// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_appointment.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateAppointmentDto _$CreateAppointmentDtoFromJson(
        Map<String, dynamic> json) =>
    CreateAppointmentDto(
      doctorId: json['doctorId'] as String,
      timing: DateTime.parse(json['timing'] as String),
    );

Map<String, dynamic> _$CreateAppointmentDtoToJson(
        CreateAppointmentDto instance) =>
    <String, dynamic>{
      'doctorId': instance.doctorId,
      'timing': instance.timing.toIso8601String(),
    };
