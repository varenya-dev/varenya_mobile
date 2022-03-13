import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/services/daily_questionnaire.service.dart';
import 'package:varenya_mobile/services/local_notifications.service.dart';
import 'package:varenya_mobile/utils/palette.util.dart';
import 'package:varenya_mobile/utils/responsive_config.util.dart';

class QuestionnaireTiming extends StatefulWidget {
  QuestionnaireTiming({
    Key? key,
  }) : super(key: key);

  @override
  State<QuestionnaireTiming> createState() => _QuestionnaireTimingState();
}

class _QuestionnaireTimingState extends State<QuestionnaireTiming> {
  late DateTime _timing;
  late final DailyQuestionnaireService _dailyQuestionnaireService;

  final LocalNotificationsService _localNotificationsService =
      LocalNotificationsService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this._dailyQuestionnaireService = Provider.of(context, listen: false);
    this._timing = this._dailyQuestionnaireService.fetchNotificationDate();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.03,
            vertical: MediaQuery.of(context).size.height * 0.01,
          ),
          child: GestureDetector(
            onTap: this.onTimingSelect,
            child: Column(
              children: [
                Text('Questionnaire Reminder Timing'),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.03,
                    vertical: MediaQuery.of(context).size.height * 0.01,
                  ),
                  padding: EdgeInsets.all(
                    responsiveConfig(
                      context: context,
                      large: MediaQuery.of(context).size.width * 0.01,
                      medium: MediaQuery.of(context).size.width * 0.01,
                      small: MediaQuery.of(context).size.width * 0.02,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Palette.secondary,
                    borderRadius: BorderRadius.circular(
                      15.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(DateFormat.jm().format(this._timing).toString()),
                      Icon(
                        Icons.timelapse,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> onTimingSelect() async {

    DateTime now = DateTime.now();

    TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(this._timing),
    );

    if (timeOfDay != null) {
      DateTime dateTime = new DateTime(
        now.year,
        now.month,
        now.day,
        timeOfDay.hour,
        timeOfDay.minute,
      );

      this._dailyQuestionnaireService.saveTiming(dateTime);
      this._localNotificationsService.scheduledNotification(dateTime);

      setState(() {
        this._timing = dateTime;
      });
    }
  }
}
