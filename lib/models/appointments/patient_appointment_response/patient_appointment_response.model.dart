import 'package:json_annotation/json_annotation.dart';
import 'package:varenya_mobile/models/appointments/appointment/appointment.model.dart';
import 'package:varenya_mobile/models/doctor/doctor.model.dart';

part 'patient_appointment_response.model.g.dart';

@JsonSerializable()
class PatientAppointmentResponse {
  Appointment appointment;
  Doctor doctor;

  PatientAppointmentResponse({
    required this.appointment,
    required this.doctor,
  });

  factory PatientAppointmentResponse.fromJson(Map<String, dynamic> json) =>
      _$PatientAppointmentResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PatientAppointmentResponseToJson(this);
}
