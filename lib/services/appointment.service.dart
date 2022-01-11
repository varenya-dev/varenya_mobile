import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:varenya_mobile/constants/endpoint_constant.dart';
import 'package:varenya_mobile/constants/hive_boxes.constant.dart';
import 'package:varenya_mobile/dtos/appointment/create_appointment/create_appointment.dto.dart';
import 'package:varenya_mobile/dtos/appointment/fetch_available_slots/fetch_available_slots.dto.dart';
import 'package:varenya_mobile/exceptions/server.exception.dart';
import 'package:varenya_mobile/models/appointments/appointment/appointment.model.dart';
import 'package:varenya_mobile/utils/logger.util.dart';

class AppointmentService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Box<List<dynamic>> _appointmentsBox = Hive.box(VARENYA_APPOINTMENT_BOX);

  Future<List<DateTime>> fetchAvailableSlots(
    FetchAvailableSlotsDto fetchAvailableSlotsDto,
  ) async {
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
      Map<String, dynamic> body = json.decode(response.body);
      log.e("AppointmentService:fetchAvailableSlots Error", body['message']);
      throw ServerException(
          message: 'Something went wrong, please try again later.');
    }

    List<dynamic> rawDates = json.decode(response.body);
    List<DateTime> availableDates =
        rawDates.map((date) => DateTime.parse(date)).toList();

    return availableDates;
  }

  Future<void> bookAppointment(
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
      Map<String, dynamic> body = json.decode(response.body);
      log.e("AppointmentService:bookAppointment Error", body['message']);
      throw ServerException(
          message: 'Something went wrong, please try again later.');
    }
  }

  Future<List<Appointment>> fetchScheduledAppointments() async {
    try {
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
      http.Response response = await http
          .get(
            uri,
            headers: headers,
          )
          .timeout(new Duration(seconds: 10));

      // Check for any errors.
      if (response.statusCode >= 400 && response.statusCode < 500) {
        Map<String, dynamic> body = json.decode(response.body);
        throw ServerException(message: body['message']);
      } else if (response.statusCode >= 500) {
        Map<String, dynamic> body = json.decode(response.body);
        log.e("AppointmentService:fetchScheduledAppointments Error",
            body['message']);
        throw ServerException(
          message: 'Something went wrong, please try again later.',
        );
      }

      List<dynamic> jsonResponse = json.decode(response.body);
      List<Appointment> appointments =
          jsonResponse.map((json) => Appointment.fromJson(json)).toList();

      this._saveAppointmentsToDevice(appointments);

      return appointments;
    } on SocketException {
      log.wtf("Dedicated Server Offline");
      return this._fetchAppointmentsFromDevice();
    } on TimeoutException {
      log.wtf("Dedicated Server Offline");
      return this._fetchAppointmentsFromDevice();
    } on FirebaseAuthException catch (error) {
      if (error.code == "network-request-failed") {
        return this._fetchAppointmentsFromDevice();
      } else {
        throw error;
      }
    }
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
      Map<String, dynamic> body = json.decode(response.body);
      log.e("AppointmentService:deleteAppointment Error", body['message']);
      throw ServerException(
          message: 'Something went wrong, please try again later.');
    }
  }

  void _saveAppointmentsToDevice(List<Appointment> appointments) {
    log.i("Saving Appointments to Device");
    this._appointmentsBox.put(VARENYA_APPOINTMENT_LIST, appointments);
    log.i("Saved Appointments to Device");
  }

  List<Appointment> _fetchAppointmentsFromDevice() {
    log.i("Fetching Appointments From Device");
    return this
        ._appointmentsBox
        .get(VARENYA_APPOINTMENT_LIST, defaultValue: [])!.cast<Appointment>();
  }
}
