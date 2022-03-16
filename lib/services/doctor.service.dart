import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:varenya_mobile/constants/hive_boxes.constant.dart';
import 'package:varenya_mobile/dtos/doctor_filter/doctor_filter.dto.dart';
import 'package:varenya_mobile/exceptions/server.exception.dart';
import 'package:varenya_mobile/models/doctor/doctor.model.dart';
import 'package:varenya_mobile/models/specialization/specialization.model.dart';
import 'package:http/http.dart' as http;
import 'package:varenya_mobile/utils/logger.util.dart';

class DoctorService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Box<List<dynamic>> _doctorsBox = Hive.box(VARENYA_DOCTORS_BOX);
  final Box<List<dynamic>> _jobsBox = Hive.box(VARENYA_JOB_BOX);
  final Box<List<dynamic>> _specializationsBox =
      Hive.box(VARENYA_SPECIALIZATION_BOX);

  final String apiUrl;
  final String rawApiUrl;

  DoctorService({
    required this.apiUrl,
    required this.rawApiUrl,
  });

  Future<List<Doctor>> fetchDoctorsWithFiltering(
    DoctorFilterDto doctorFilterDto,
  ) async {
    try {
      // Fetch the ID token for the user.
      String firebaseAuthToken =
          await this._firebaseAuth.currentUser!.getIdToken();

      // Prepare URI for the request.
      Uri uri = Uri.http(
        rawApiUrl,
        "/v1/api/doctor/filter",
        doctorFilterDto.toJson(),
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
        log.e("DoctorService:fetchDoctorsWithFiltering Error", body['message']);
        throw ServerException(
          message: 'Something went wrong, please try again later.',
        );
      }

      List<dynamic> jsonResponse = json.decode(response.body);
      List<Doctor> doctors = jsonResponse
          .map((doctorJson) => Doctor.fromJson(doctorJson))
          .toList();

      this._saveFilteredDoctorsToDevice(doctors);

      return doctors;
    } on SocketException {
      log.wtf("Dedicated Server Offline");
      return this._fetchFilteredDoctorsFromDevice();
    } on TimeoutException {
      log.wtf("Dedicated Server Offline");
      return this._fetchFilteredDoctorsFromDevice();
    } on FirebaseAuthException catch (error) {
      if (error.code == "network-request-failed") {
        return this._fetchFilteredDoctorsFromDevice();
      } else {
        throw error;
      }
    }
  }

  Future<List<Specialization>> fetchSpecializations() async {
    try {
      // Fetch the ID token for the user.
      String firebaseAuthToken =
          await this._firebaseAuth.currentUser!.getIdToken();

      // Prepare URI for the request.
      Uri uri = Uri.parse("$apiUrl/doctor/specialization");

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
        log.e("DoctorService:fetchSpecializations Error", body['message']);
        throw ServerException(
          message: 'Something went wrong, please try again later.',
        );
      }

      List<dynamic> jsonResponse = json.decode(response.body);
      List<Specialization> specializations =
          jsonResponse.map((json) => Specialization.fromJson(json)).toList();

      this._saveSpecializationsToDevice(specializations);

      return specializations;
    } on SocketException {
      log.wtf("Dedicated Server Offline");
      return this._fetchSpecializationsFromDevice();
    } on TimeoutException {
      log.wtf("Dedicated Server Offline");
      return this._fetchSpecializationsFromDevice();
    } on FirebaseAuthException catch (error) {
      if (error.code == "network-request-failed") {
        return this._fetchSpecializationsFromDevice();
      } else {
        throw error;
      }
    }
  }

  Future<List<String>> fetchJobTitles() async {
    try {
      // Fetch the ID token for the user.
      String firebaseAuthToken =
          await this._firebaseAuth.currentUser!.getIdToken();

      // Prepare URI for the request.
      Uri uri = Uri.parse("$apiUrl/doctor/title");

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
        log.e("DoctorService:fetchJobTitles Error", body['message']);
        throw ServerException(
          message: 'Something went wrong, please try again later.',
        );
      }

      List<dynamic> titlesData = json.decode(response.body);
      List<String> titles =
          titlesData.map((element) => element.toString()).toList();

      this._saveJobsToDevice(titles);

      return titles;
    } on SocketException {
      log.wtf("Dedicated Server Offline");
      return this._fetchJobsFromDevice();
    } on TimeoutException {
      log.wtf("Dedicated Server Offline");
      return this._fetchJobsFromDevice();
    } on FirebaseAuthException catch (error) {
      if (error.code == "network-request-failed") {
        return this._fetchJobsFromDevice();
      } else {
        throw error;
      }
    }
  }

  void _saveFilteredDoctorsToDevice(List<Doctor> doctors) {
    log.i("Saving Doctors to Device");
    this._doctorsBox.put(VARENYA_FILTERED_DOCTORS_LIST, doctors);
    log.i("Saved Doctors to Device");
  }

  List<Doctor> _fetchFilteredDoctorsFromDevice() {
    log.i("Fetching Doctors From Device");
    List<Doctor> doctors = this
        ._doctorsBox
        .get(VARENYA_FILTERED_DOCTORS_LIST, defaultValue: [])!.cast<Doctor>();
    return doctors;
  }

  void _saveSpecializationsToDevice(List<Specialization> specializations) {
    log.i("Saving Specializations to Device");
    this._specializationsBox.put(VARENYA_SPECIALIZATION_LIST, specializations);
    log.i("Saved Specializations to Device");
  }

  List<Specialization> _fetchSpecializationsFromDevice() {
    log.i("Fetching Specializations From Device");
    return this._specializationsBox.get(
      VARENYA_SPECIALIZATION_LIST,
      defaultValue: [],
    )!.cast<Specialization>();
  }

  void _saveJobsToDevice(List<String> jobs) {
    log.i("Saving Jobs to Device");
    this._jobsBox.put(VARENYA_JOB_LIST, jobs);
    log.i("Saved Jobs to Device");
  }

  List<String> _fetchJobsFromDevice() {
    log.i("Fetching Jobs From Device");
    return this
        ._jobsBox
        .get(VARENYA_JOB_LIST, defaultValue: [])!.cast<String>();
  }
}
