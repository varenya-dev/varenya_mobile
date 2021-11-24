import 'package:json_annotation/json_annotation.dart';

part 'doctor_filter.dto.g.dart';

@JsonSerializable()
class DoctorFilterDto {
  @JsonKey(defaultValue: 'EMPTY')
  final String? jobTitle;

  @JsonKey(defaultValue: ['', ''])
  final List<String> specializations;

  DoctorFilterDto({
    this.jobTitle = 'EMPTY',
    this.specializations = const ['', ''],
  });

  factory DoctorFilterDto.fromJson(Map<String, dynamic> json) =>
      _$DoctorFilterDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorFilterDtoToJson(this);
}
