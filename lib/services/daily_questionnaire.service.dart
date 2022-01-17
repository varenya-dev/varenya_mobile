import 'package:hive/hive.dart';
import 'package:varenya_mobile/constants/hive_boxes.constant.dart';

class DailyQuestionnaireService {
  final Box<List<dynamic>> _progressBox = Hive.box(VARENYA_PROGESS_BOX);
}
