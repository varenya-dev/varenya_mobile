import 'package:json_annotation/json_annotation.dart';
import 'package:varenya_mobile/models/user/server_user.model.dart';

part 'appointment.model.g.dart';

@JsonSerializable()
class Appointment {
  String id;
  DateTime scheduledFor;
  DateTime createdAt;
  DateTime updatedAt;
  ServerUser patientUser;
  ServerUser doctorUser;

  Appointment({
    required this.id,
    required this.scheduledFor,
    required this.createdAt,
    required this.updatedAt,
    required this.patientUser,
    required this.doctorUser,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) =>
      _$AppointmentFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentToJson(this);
}