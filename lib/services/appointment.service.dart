import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:varenya_mobile/constants/endpoint_constant.dart';
import 'package:varenya_mobile/dtos/appointment/create_appointment/create_appointment.dto.dart';
import 'package:varenya_mobile/models/appointments/appointment/appointment.model.dart';

class AppointmentService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> requestForAppointment(
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

      print(appointment.scheduledFor);
    } catch (error) {
      print(error);
    }
  }
}
