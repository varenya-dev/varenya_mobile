import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:varenya_mobile/constants/endpoint_constant.dart';
import 'package:varenya_mobile/dtos/appointment/create_appointment/create_appointment.dto.dart';
import 'package:varenya_mobile/dtos/appointment/fetch_available_slots/fetch_available_slots.dto.dart';
import 'package:varenya_mobile/exceptions/server.exception.dart';
import 'package:varenya_mobile/models/appointments/appointment/appointment.model.dart';
import 'package:varenya_mobile/models/appointments/patient_appointment_response/patient_appointment_response.model.dart';

class AppointmentService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<List<DateTime>> fetchAvailableSlots(
      FetchAvailableSlotsDto fetchAvailableSlotsDto) async {

    // Fetch the ID token for the user.
    String firebaseAuthToken =
        await this._firebaseAuth.currentUser!.getIdToken();

    // Prepare URI for the request.
    Uri uri = Uri.http(
      RAW_ENDPOINT,
      "/v1/api/appointment/available",
      fetchAvailableSlotsDto.toJson(),
    );

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
    if (response.statusCode >= 400 && response.statusCode < 500) {
      Map<String, dynamic> body = json.decode(response.body);
      throw ServerException(message: body['message']);
    } else if (response.statusCode >= 500) {
      throw ServerException(
          message: 'Something went wrong, please try again later.');
    }

    List<dynamic> rawDates = json.decode(response.body);
    List<DateTime> availableDates =
        rawDates.map((date) => DateTime.parse(date)).toList();

    return availableDates;
  }

  Future<Appointment> requestForAppointment(
    CreateAppointmentDto createAppointmentDto,
  ) async {
    // Fetch the ID token for the user.
    String firebaseAuthToken =
        await this._firebaseAuth.currentUser!.getIdToken();

    // Prepare URI for the request.
    Uri uri = Uri.parse("$ENDPOINT/appointment");

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
    if (response.statusCode >= 400 && response.statusCode < 500) {
      Map<String, dynamic> body = json.decode(response.body);
      throw ServerException(message: body['message']);
    } else if (response.statusCode >= 500) {
      throw ServerException(
          message: 'Something went wrong, please try again later.');
    }

    Appointment appointment = Appointment.fromJson(json.decode(response.body));

    return appointment;
  }

  Future<List<PatientAppointmentResponse>> fetchScheduledAppointments() async {
    // Fetch the ID token for the user.
    String firebaseAuthToken =
        await this._firebaseAuth.currentUser!.getIdToken();

    // Prepare URI for the request.
    Uri uri = Uri.parse("$ENDPOINT/appointment/patient");

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
    if (response.statusCode >= 400 && response.statusCode < 500) {
      Map<String, dynamic> body = json.decode(response.body);
      throw ServerException(message: body['message']);
    } else if (response.statusCode >= 500) {
      throw ServerException(
        message: 'Something went wrong, please try again later.',
      );
    }

    List<dynamic> jsonResponse = json.decode(response.body);
    List<PatientAppointmentResponse> appointments = jsonResponse
        .map((json) => PatientAppointmentResponse.fromJson(json))
        .toList();

    return appointments;
  }

  Future<void> deleteAppointment(Appointment appointment) async {
    // Fetch the ID token for the user.
    String firebaseAuthToken =
        await this._firebaseAuth.currentUser!.getIdToken();

    // Prepare URI for the request.
    Uri uri = Uri.parse("$ENDPOINT/appointment");

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
    if (response.statusCode >= 400 && response.statusCode < 500) {
      Map<String, dynamic> body = json.decode(response.body);
      throw ServerException(message: body['message']);
    } else if (response.statusCode >= 500) {
      throw ServerException(
          message: 'Something went wrong, please try again later.');
    }
  }
}
