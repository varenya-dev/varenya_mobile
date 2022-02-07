import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:varenya_mobile/models/specialization/specialization.model.dart';
import 'package:varenya_mobile/models/user/server_user.model.dart';

part 'doctor.model.g.dart';

@HiveType(typeId: 5)
@JsonSerializable()
class Doctor {
  @HiveField(0, defaultValue: '')
  final String id;

  @HiveField(1, defaultValue: '')
  @JsonKey(defaultValue: '')
  final String imageUrl;

  @HiveField(2, defaultValue: '')
  @JsonKey(defaultValue: '')
  final String fullName;

  @HiveField(3, defaultValue: '')
  @JsonKey(defaultValue: '')
  final String clinicAddress;

  @HiveField(4, defaultValue: 0.0)
  @JsonKey(defaultValue: 0.0)
  final double cost;

  @HiveField(5, defaultValue: '')
  @JsonKey(defaultValue: "")
  final String jobTitle;

  @HiveField(6, defaultValue: [])
  @JsonKey(defaultValue: [])
  final List<Specialization> specializations;

  @HiveField(7)
  final DateTime shiftStartTime;

  @HiveField(8)
  final DateTime shiftEndTime;

  @HiveField(9, defaultValue: null)
  @JsonKey(defaultValue: null)
  final ServerUser? user;

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
    required this.user,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) => _$DoctorFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorToJson(this);
}
