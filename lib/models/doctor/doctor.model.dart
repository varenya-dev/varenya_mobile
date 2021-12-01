import 'package:json_annotation/json_annotation.dart';
import 'package:varenya_mobile/models/specialization/specialization.model.dart';

part 'doctor.model.g.dart';

@JsonSerializable()
class Doctor {
  String id;

  @JsonKey(defaultValue: '')
  String imageUrl;

  @JsonKey(defaultValue: '')
  String fullName;

  @JsonKey(defaultValue: '')
  String clinicAddress;

  @JsonKey(defaultValue: 0.0)
  double cost;

  @JsonKey(defaultValue: "")
  String jobTitle;

  @JsonKey(defaultValue: [])
  List<Specialization> specializations;

  DateTime shiftStartTime;
  DateTime shiftEndTime;

  Doctor({
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
