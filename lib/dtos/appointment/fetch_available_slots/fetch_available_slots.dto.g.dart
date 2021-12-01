// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_available_slots.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FetchAvailableSlotsDto _$FetchAvailableSlotsDtoFromJson(
        Map<String, dynamic> json) =>
    FetchAvailableSlotsDto(
      date: DateTime.parse(json['date'] as String),
      doctorId: json['doctorId'] as String,
    );

Map<String, dynamic> _$FetchAvailableSlotsDtoToJson(
        FetchAvailableSlotsDto instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'doctorId': instance.doctorId,
    };
