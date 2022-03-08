import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:varenya_mobile/constants/hive_boxes.constant.dart';

class RecordsService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final Box<List<dynamic>> _postsBox = Hive.box(VARENYA_DOCTOR_RECORD_LIST);
}
