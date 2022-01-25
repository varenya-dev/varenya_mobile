import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/models/daily_progress_data/daily_progress_data.model.dart';
import 'package:varenya_mobile/pages/daily_questionnaire/single_progress.page.dart';
import 'package:varenya_mobile/services/daily_questionnaire.service.dart';

class PastProgress extends StatefulWidget {
  const PastProgress({Key? key}) : super(key: key);

  // Page Route Name.
  static const routeName = "/past-progress";

  @override
  _PastProgressState createState() => _PastProgressState();
}

class _PastProgressState extends State<PastProgress> {
  // Daily Questionnaire Service.
  late final DailyQuestionnaireService _dailyQuestionnaireService;

  // Daily Progress Data List.
  late final List<DailyProgressData> _dailyProgressList;

  @override
  void initState() {
    super.initState();

    // Injecting daily questionnaire service from global state.
    this._dailyQuestionnaireService =
        Provider.of<DailyQuestionnaireService>(context, listen: false);

    // Fetching daily progress data from device.
    this._dailyProgressList =
        this._dailyQuestionnaireService.fetchDailyProgressData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Past Progress Data'),
      ),
      body: ListView.builder(
        itemCount: this._dailyProgressList.length,
        itemBuilder: (BuildContext context, int index) {
          DailyProgressData dailyProgressData = this._dailyProgressList[index];

          return ListTile(
            onTap: () {
              Navigator.of(context).pushNamed(
                SingleProgress.routeName,
                arguments: dailyProgressData,
              );
            },
            title: Text(
              DateFormat.yMMMd().add_jm().format(
                    dailyProgressData.createdAt,
                  ),
            ),
            subtitle: Text("Mood Score: ${dailyProgressData.moodRating}"),
          );
        },
      ),
    );
  }
}
