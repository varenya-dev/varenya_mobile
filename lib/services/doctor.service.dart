import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:varenya_mobile/constants/endpoint_constant.dart';
import 'package:varenya_mobile/dtos/doctor_filter/doctor_filter.dto.dart';
import 'package:varenya_mobile/exceptions/server.exception.dart';
import 'package:varenya_mobile/models/doctor/doctor.model.dart';
import 'package:varenya_mobile/models/specialization/specialization.model.dart';
import 'package:http/http.dart' as http;

class DoctorService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<List<Doctor>> fetchDoctorsWithFiltering(
      DoctorFilterDto doctorFilterDto) async {
    // Fetch the ID token for the user.
    String firebaseAuthToken =
        await this._firebaseAuth.currentUser!.getIdToken();

    // Prepare URI for the request.
    Uri uri = Uri.http(
      RAW_ENDPOINT,
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
      throw ServerException(
        message: 'Something went wrong, please try again later.',
      );
    }

    List<dynamic> jsonResponse = json.decode(response.body);
    List<Doctor> doctors =
        jsonResponse.map((doctorJson) => Doctor.fromJson(doctorJson)).toList();

    return doctors;
  }

  Future<List<Specialization>> fetchSpecializations() async {
    // Fetch the ID token for the user.
    String firebaseAuthToken =
        await this._firebaseAuth.currentUser!.getIdToken();

    // Prepare URI for the request.
    Uri uri = Uri.parse("$ENDPOINT/doctor/specialization");

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
    List<Specialization> specializations =
        jsonResponse.map((json) => Specialization.fromJson(json)).toList();

    return specializations;
  }

  Future<List<String>> fetchJobTitles() async {
    // Fetch the ID token for the user.
    String firebaseAuthToken =
        await this._firebaseAuth.currentUser!.getIdToken();

    // Prepare URI for the request.
    Uri uri = Uri.parse("$ENDPOINT/doctor/title");

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

    List<dynamic> titlesData = json.decode(response.body);
    List<String> titles =
        titlesData.map((element) => element.toString()).toList();

    return titles;
  }
}
