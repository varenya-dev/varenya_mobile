import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:varenya_mobile/constants/hive_boxes.constant.dart';
import 'package:varenya_mobile/dtos/appointment/create_appointment/create_appointment.dto.dart';
import 'package:varenya_mobile/dtos/appointment/fetch_available_slots/fetch_available_slots.dto.dart';
import 'package:varenya_mobile/exceptions/server.exception.dart';
import 'package:varenya_mobile/models/appointments/appointment/appointment.model.dart';
import 'package:varenya_mobile/utils/logger.util.dart';

/*
 * Service Implementation for Appointments Module.
 */
class AppointmentService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Box<List<dynamic>> _appointmentsBox = Hive.box(VARENYA_APPOINTMENT_BOX);

  final String apiUrl;
  final String rawApiUrl;

  AppointmentService({
    required this.apiUrl,
    required this.rawApiUrl,
  });

  /*
   * Method to fetch available time slots for
   * a particular day for a particular doctors.
   * @param fetchAvailableSlotsDto DTO Object for fetching available slots.
   */
  Future<List<DateTime>> fetchAvailableSlots(
    FetchAvailableSlotsDto fetchAvailableSlotsDto,
  ) async {
    // Fetch the ID token for the user.
    String firebaseAuthToken =
        await this._firebaseAuth.currentUser!.getIdToken();

    // Prepare URI for the request.
    Uri uri = Uri.http(
      rawApiUrl,
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

    // Decode JSON and create objects based on it.
    List<dynamic> rawDates = json.decode(response.body);
    List<DateTime> availableDates =
        rawDates.map((date) => DateTime.parse(date)).toList();

    // Return available slots to user.
    return availableDates;
  }

  /*
   * Method to confirm booking on a particular time slot
   * for a particular doctor.
   * @param createAppointmentDto DTO Object for booking a time slot for a doctor.
   */
  Future<void> bookAppointment(
    CreateAppointmentDto createAppointmentDto,
  ) async {
    // Fetch the ID token for the user.
    String firebaseAuthToken =
        await this._firebaseAuth.currentUser!.getIdToken();

    // Prepare URI for the request.
    Uri uri = Uri.parse("$apiUrl/appointment");

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

  /*
   * Method to fetch scheduled appointments by the user.
   */
  Future<List<Appointment>> fetchScheduledAppointments() async {
    try {
      // Fetch the ID token for the user.
      String firebaseAuthToken =
          await this._firebaseAuth.currentUser!.getIdToken();

      // Prepare URI for the request.
      Uri uri = Uri.parse("$apiUrl/appointment/patient");

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

      // Decode JSON and create objects based on it.
      List<dynamic> jsonResponse = json.decode(response.body);
      List<Appointment> appointments =
          jsonResponse.map((json) => Appointment.fromJson(json)).toList();

      // Saved scheduled appointments to device storage.
      this._saveAppointmentsToDevice(appointments);

      // Return schedule appointments.
      return appointments;
    } on SocketException {
      log.wtf("Dedicated Server Offline");

      // Fetch scheduled appointments from device storage.
      return this._fetchAppointmentsFromDevice();
    } on TimeoutException {
      log.wtf("Dedicated Server Offline");

      // Fetch scheduled appointments from device storage.
      return this._fetchAppointmentsFromDevice();
    } on FirebaseAuthException catch (error) {
      if (error.code == "network-request-failed") {
        // Fetch scheduled appointments from device storage.
        return this._fetchAppointmentsFromDevice();
      } else {
        throw error;
      }
    }
  }

  /*
   * Method to delete appointment from the server.
   */
  Future<void> deleteAppointment(Appointment appointment) async {
    // Fetch the ID token for the user.
    String firebaseAuthToken =
        await this._firebaseAuth.currentUser!.getIdToken();

    // Prepare URI for the request.
    Uri uri = Uri.parse("$apiUrl/appointment");

    // Prepare authorization headers.
    Map<String, String> headers = {
      "Authorization": "Bearer $firebaseAuthToken",
    };

    // Convert appointment object to JSON.
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

  /*
   * Method to save fetched appointments to device storage.
   */
  void _saveAppointmentsToDevice(List<Appointment> appointments) {
    log.i("Saving Appointments to Device");

    // Save appointments to device storage.
    this._appointmentsBox.put(VARENYA_APPOINTMENT_LIST, appointments);
    log.i("Saved Appointments to Device");
  }

  /*
   * Method to fetch saved appointments from device storage.
   */
  List<Appointment> _fetchAppointmentsFromDevice() {
    log.i("Fetching Appointments From Device");

    // Fetching and returning appointments from device storage.
    return this
        ._appointmentsBox
        .get(VARENYA_APPOINTMENT_LIST, defaultValue: [])!.cast<Appointment>();
  }
}
