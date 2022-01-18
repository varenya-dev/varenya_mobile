import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/constants/emoji_mood.constant.dart';
import 'package:varenya_mobile/models/daily_progress_data/daily_progress_data.model.dart';
import 'package:varenya_mobile/services/daily_questionnaire.service.dart';

class MoodChart extends StatefulWidget {
  const MoodChart({Key? key}) : super(key: key);

  @override
  _MoodChartState createState() => _MoodChartState();
}

class _MoodChartState extends State<MoodChart> {
  late final DailyQuestionnaireService _dailyQuestionnaireService;
  late List<DailyProgressData> _dailyProgressData;

  @override
  void initState() {
    super.initState();

    this._dailyQuestionnaireService =
        Provider.of<DailyQuestionnaireService>(context, listen: false);

    this._dailyProgressData =
        this._dailyQuestionnaireService.fetchDailyProgressData();

    this._dailyProgressData = this._dailyProgressData.length > 7
        ? this._dailyProgressData.sublist(
              this._dailyProgressData.length - 7,
              this._dailyProgressData.length,
            )
        : this._dailyProgressData;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.40,
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height * 0.07,
        left: MediaQuery.of(context).size.width * 0.03,
        right: MediaQuery.of(context).size.width * 0.03,
      ),
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
            enabled: true,
          ),
          lineBarsData: [
            LineChartBarData(
              preventCurveOverShooting: true,
              colors: [
                Colors.yellow,
              ],
              spots: this
                  ._dailyProgressData
                  .map(
                    (e) => FlSpot(
                      this._dailyProgressData.indexOf(e).toDouble(),
                      e.moodRating.toDouble(),
                    ),
                  )
                  .toList(),
              isCurved: true,
              barWidth: 5,
              dotData: FlDotData(
                show: true,
              ),
              belowBarData: BarAreaData(
                show: true,
                colors: [
                  Colors.yellow.withOpacity(
                    0.1,
                  ),
                ],
              ),
            ),
          ],
          minY: 0,
          maxY: 6,
          titlesData: FlTitlesData(
            topTitles: SideTitles(
              showTitles: false,
            ),
            rightTitles: SideTitles(
              showTitles: false,
            ),
            bottomTitles: SideTitles(
              interval: 1,
              showTitles: true,
              rotateAngle: 90.0,
              getTitles: (value) => DateFormat.yMMMd()
                  .format(this._dailyProgressData[value.toInt()].createdAt),
              margin: 20,
              getTextStyles: (BuildContext context, _) => TextStyle(
                fontSize: 11.0,
              ),
            ),
            leftTitles: SideTitles(
              showTitles: true,
              getTitles: (value) {
                if (value.toInt() > EMOJIS.length || (value.toInt() - 1) < 0)
                  return '';
                return EMOJIS[value.toInt() - 1];
              },
              interval: 1,
              margin: 12,
              getTextStyles: (BuildContext context, _) => TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          gridData: FlGridData(
            show: false,
          ),
        ),
      ),
    );
  }
}
