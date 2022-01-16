import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:varenya_mobile/constants/endpoint_constant.dart';
import 'package:varenya_mobile/constants/hive_boxes.constant.dart';
import 'package:varenya_mobile/exceptions/server.exception.dart';
import 'package:varenya_mobile/models/activity/activity.model.dart';
import 'package:varenya_mobile/utils/logger.util.dart';

class ActivityService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Box<List<dynamic>> _activityBox = Hive.box(VARENYA_ACTIVITY_BOX);

  Future<List<Activity>> fetchActivity() async {
    try {
      // Fetch the ID token for the user.
      String firebaseAuthToken =
          await this._firebaseAuth.currentUser!.getIdToken();

      // Prepare URI for the request.
      Uri uri = Uri.parse("$ENDPOINT/activity");

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
        log.e("ActivityService:fetchActivity Error", body['message']);
        throw ServerException(
          message: 'Something went wrong, please try again later.',
        );
      }

      List<dynamic> jsonResponse = json.decode(response.body);

      List<Activity> activities =
          jsonResponse.map((json) => Activity.fromJson(json)).toList();

      this._saveActivitiesToDevice(activities);

      return activities;
    } on SocketException {
      log.wtf("Dedicated Server Offline");
      return this._fetchActivitiesFromDevice();
    } on TimeoutException {
      log.wtf("Dedicated Server Offline");
      return this._fetchActivitiesFromDevice();
    } on FirebaseAuthException catch (error) {
      if (error.code == "network-request-failed") {
        return this._fetchActivitiesFromDevice();
      } else {
        throw error;
      }
    }
  }

  void _saveActivitiesToDevice(List<Activity> activities) {
    log.i("Saving Activities to Device");
    this._activityBox.put(VARENYA_ACTIVITY_LIST, activities);
    log.i("Saved Activities to Device");
  }

  List<Activity> _fetchActivitiesFromDevice() {
    log.i("Fetching Activities From Device");
    return this
        ._activityBox
        .get(VARENYA_ACTIVITY_LIST, defaultValue: [])!.cast<Activity>();
  }
}
