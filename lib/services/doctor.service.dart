import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:varenya_mobile/constants/endpoint_constant.dart';
import 'package:varenya_mobile/exceptions/server.exception.dart';
import 'package:varenya_mobile/models/specialization/specialization.model.dart';
import 'package:http/http.dart' as http;

class DoctorService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchDoctorsStream(
    String? jobFilter,
    List<String> specializationsFilter,
  ) {
    if (jobFilter != null && specializationsFilter.length == 0) {
      return this
          ._firestore
          .collection('doctors')
          .where('jobTitle', isEqualTo: jobFilter.toString().split('.')[1])
          .snapshots();
    } else if (jobFilter == null && specializationsFilter.length > 0) {
      return this
          ._firestore
          .collection('doctors')
          .where('specializations',
              arrayContainsAny: specializationsFilter
                  .map((s) => s.toString().split('.')[1])
                  .toList())
          .snapshots();
    } else if (jobFilter != null && specializationsFilter.length > 0) {
      return this
          ._firestore
          .collection('doctors')
          .where('jobTitle', isEqualTo: jobFilter.toString().split('.')[1])
          .where('specializations',
              arrayContainsAny: specializationsFilter
                  .map((s) => s.toString().split('.')[1])
                  .toList())
          .snapshots();
    } else {
      return this._firestore.collection('doctors').snapshots();
    }
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

    List<String> titles = json.decode(response.body);

    return titles;
  }
}
