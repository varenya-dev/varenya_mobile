// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_filter.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorFilterDto _$DoctorFilterDtoFromJson(Map<String, dynamic> json) {
  return DoctorFilterDto(
    jobTitle: json['jobTitle'] as String? ?? 'EMPTY',
    specializations: (json['specializations'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        ['', ''],
  );
}

Map<String, dynamic> _$DoctorFilterDtoToJson(DoctorFilterDto instance) =>
    <String, dynamic>{
      'jobTitle': instance.jobTitle,
      'specializations': instance.specializations,
    };
