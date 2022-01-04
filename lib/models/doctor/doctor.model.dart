import 'package:json_annotation/json_annotation.dart';
import 'package:varenya_mobile/models/specialization/specialization.model.dart';

part 'doctor.model.g.dart';

@JsonSerializable()
class Doctor {
  final String id;

  @JsonKey(defaultValue: '')
  final String imageUrl;

  @JsonKey(defaultValue: '')
  final String fullName;

  @JsonKey(defaultValue: '')
  final String clinicAddress;

  @JsonKey(defaultValue: 0.0)
  final double cost;

  @JsonKey(defaultValue: "")
  final String jobTitle;

  @JsonKey(defaultValue: [])
  final List<Specialization> specializations;

  final DateTime shiftStartTime;
  final DateTime shiftEndTime;

  const Doctor({
    required this.id,
    this.imageUrl = '',
    this.fullName = '',
    this.clinicAddress = '',
    this.cost = 0.0,
    this.jobTitle = "",
    this.specializations = const [],
    required this.shiftStartTime,
    required this.shiftEndTime,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) => _$DoctorFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorToJson(this);
}
