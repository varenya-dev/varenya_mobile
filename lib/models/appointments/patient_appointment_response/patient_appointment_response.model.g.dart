// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_appointment_response.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatientAppointmentResponse _$PatientAppointmentResponseFromJson(
    Map<String, dynamic> json) {
  return PatientAppointmentResponse(
    appointment:
        Appointment.fromJson(json['appointment'] as Map<String, dynamic>),
    doctor: Doctor.fromJson(json['doctor'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PatientAppointmentResponseToJson(
        PatientAppointmentResponse instance) =>
    <String, dynamic>{
      'appointment': instance.appointment,
      'doctor': instance.doctor,
    };
