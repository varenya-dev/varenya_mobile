import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:varenya_mobile/constants/endpoint_constant.dart';
import 'package:varenya_mobile/dtos/appointment/create_appointment/create_appointment.dto.dart';
import 'package:varenya_mobile/models/appointments/appointment/appointment.model.dart';
import 'package:varenya_mobile/models/appointments/patient_appointment_response/patient_appointment_response.model.dart';

class AppointmentService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<Appointment> requestForAppointment(
    CreateAppointmentDto createAppointmentDto,
  ) async {
    try {
      // Fetch the ID token for the user.
      String firebaseAuthToken =
          await this._firebaseAuth.currentUser!.getIdToken();

      // Prepare URI for the request.
      Uri uri = Uri.parse("$endpoint/appointment");

      // Prepare authorization headers.
      Map<String, String> headers = {
        "Authorization": "Bearer $firebaseAuthToken",
      };

      // Send the post request to the server.
      http.Response response = await http.post(
        uri,
        body: createAppointmentDto.toJson(),
        headers: headers,
      );

      // Check for any errors.
      if (response.statusCode >= 400) {
        Map<String, dynamic> body = json.decode(response.body);
        throw Exception(body);
      }

      Appointment appointment =
          Appointment.fromJson(json.decode(response.body));

      return appointment;
    } catch (error) {
      throw Exception('Try again later');
    }
  }

  Future<List<PatientAppointmentResponse>> fetchScheduledAppointments() async {
    try {
      // Fetch the ID token for the user.
      String firebaseAuthToken =
          await this._firebaseAuth.currentUser!.getIdToken();

      // Prepare URI for the request.
      Uri uri = Uri.parse("$endpoint/appointment/patient");

      // Prepare authorization headers.
      Map<String, String> headers = {
        "Authorization": "Bearer $firebaseAuthToken",
      };

      // Send the post request to the server.
      http.Response response = await http.get(
        uri,
        headers: headers,
      );

      // Check for any errors.
      if (response.statusCode >= 400) {
        Map<String, dynamic> body = json.decode(response.body);
        throw Exception(body);
      }

      List<dynamic> jsonResponse = json.decode(response.body);
      List<PatientAppointmentResponse> appointments = jsonResponse
          .map((json) => PatientAppointmentResponse.fromJson(json))
          .toList();

      return appointments;
    } catch (error) {
      throw Exception('Try again later');
    }
  }

  Future<void> deleteAppointment(Appointment appointment) async {
    try {
      // Fetch the ID token for the user.
      String firebaseAuthToken =
          await this._firebaseAuth.currentUser!.getIdToken();

      // Prepare URI for the request.
      Uri uri = Uri.parse("$endpoint/appointment");

      // Prepare authorization headers.
      Map<String, String> headers = {
        "Authorization": "Bearer $firebaseAuthToken",
      };

      Map<String, dynamic> appointmentJson = appointment.toJson();
      appointmentJson.remove('patientUser');
      appointmentJson.remove('doctorUser');

      // Send the post request to the server.
      http.Response response = await http.delete(
        uri,
        body: appointmentJson,
        headers: headers,
      );

      // Check for any errors.
      if (response.statusCode >= 400) {
        Map<String, dynamic> body = json.decode(response.body);
        throw Exception(body);
      }
    } catch (error) {
      throw Exception('Try again later');
    }
  }
}
