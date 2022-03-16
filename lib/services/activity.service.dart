import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:varenya_mobile/constants/hive_boxes.constant.dart';
import 'package:varenya_mobile/exceptions/server.exception.dart';
import 'package:varenya_mobile/models/activity/activity.model.dart';
import 'package:varenya_mobile/utils/logger.util.dart';

/*
 * Service Implementation for Activity Module
 */
class ActivityService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Box<List<dynamic>> _activityBox = Hive.box(VARENYA_ACTIVITY_BOX);

  final String apiUrl;
  final String rawApiUrl;

  ActivityService({
    required this.apiUrl,
    required this.rawApiUrl,
  });

  /*
   * Method to fetch activities from server.
   */
  Future<List<Activity>> fetchActivity() async {
    try {
      // Fetch the ID token for the user.
      String firebaseAuthToken =
          await this._firebaseAuth.currentUser!.getIdToken();

      // Prepare URI for the request.
      Uri uri = Uri.parse("$apiUrl/activity");

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

      // Decode JSON and create objects based on it.
      List<dynamic> jsonResponse = json.decode(response.body);
      List<Activity> activities =
          jsonResponse.map((json) => Activity.fromJson(json)).toList();

      // Save activities to device storage.
      this._saveActivitiesToDevice(activities);

      // Return requested data.
      return activities;
    } on SocketException {
      log.wtf("Dedicated Server Offline");

      // Fetch activities from device storage.
      return this._fetchActivitiesFromDevice();
    } on TimeoutException {
      log.wtf("Dedicated Server Offline");

      // Fetch activities from device storage.
      return this._fetchActivitiesFromDevice();
    } on FirebaseAuthException catch (error) {
      if (error.code == "network-request-failed") {
        // Fetch activities from device storage.
        return this._fetchActivitiesFromDevice();
      } else {
        throw error;
      }
    }
  }

  /*
   * Method to save fetched activities on device storage.
   */
  void _saveActivitiesToDevice(List<Activity> activities) {
    log.i("Saving Activities to Device");

    // Saving data to HiveDB box.
    this._activityBox.put(VARENYA_ACTIVITY_LIST, activities);

    log.i("Saved Activities to Device");
  }

  /*
   * Method to fetch saved activities from device storage.
   */
  List<Activity> _fetchActivitiesFromDevice() {
    log.i("Fetching Activities From Device");

    // Returning stored data from HiveDB box.
    return this
        ._activityBox
        .get(VARENYA_ACTIVITY_LIST, defaultValue: [])!.cast<Activity>();
  }
}
