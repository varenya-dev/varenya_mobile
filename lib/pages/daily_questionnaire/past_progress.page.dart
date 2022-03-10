import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/models/daily_progress_data/daily_progress_data.model.dart';
import 'package:varenya_mobile/pages/daily_questionnaire/single_progress.page.dart';
import 'package:varenya_mobile/services/daily_questionnaire.service.dart';
import 'package:varenya_mobile/utils/palette.util.dart';
import 'package:varenya_mobile/utils/responsive_config.util.dart';
import 'package:varenya_mobile/widgets/daily_questionnaire/past_progress_item.widget.dart';

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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Palette.black,
                width: MediaQuery.of(context).size.width,
                height: responsiveConfig(
                  context: context,
                  large: MediaQuery.of(context).size.height * 0.3,
                  medium: MediaQuery.of(context).size.height * 0.3,
                  small: MediaQuery.of(context).size.height * 0.24,
                ),
                padding: EdgeInsets.all(
                  responsiveConfig(
                    context: context,
                    large: MediaQuery.of(context).size.width * 0.03,
                    medium: MediaQuery.of(context).size.width * 0.03,
                    small: MediaQuery.of(context).size.width * 0.05,
                  ),
                ),
                child: Text(
                  'Past\nProgress',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.07,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: this._dailyProgressList.length,
                itemBuilder: (BuildContext context, int index) {
                  DailyProgressData dailyProgressData =
                      this._dailyProgressList[index];

                  return PastProgressItem(
                    dailyProgressData: dailyProgressData,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
