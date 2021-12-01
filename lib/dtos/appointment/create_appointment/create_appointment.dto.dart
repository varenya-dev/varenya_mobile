import 'package:json_annotation/json_annotation.dart';

part 'create_appointment.dto.g.dart';

@JsonSerializable()
class CreateAppointmentDto {
  final String doctorId;
  final DateTime timing;

  CreateAppointmentDto({
    required this.doctorId,
    required this.timing,
  });

  factory CreateAppointmentDto.fromJson(Map<String, dynamic> json) =>
      _$CreateAppointmentDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateAppointmentDtoToJson(this);
}
