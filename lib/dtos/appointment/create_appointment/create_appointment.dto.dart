import 'package:json_annotation/json_annotation.dart';

part 'create_appointment.dto.g.dart';

@JsonSerializable()
class CreateAppointmentDto {
  String doctorId;

  CreateAppointmentDto({
    required this.doctorId,
  });

  factory CreateAppointmentDto.fromJson(Map<String, dynamic> json) =>
      _$CreateAppointmentDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateAppointmentDtoToJson(this);
}
