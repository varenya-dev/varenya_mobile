import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/exceptions/server.exception.dart';
import 'package:varenya_mobile/models/activity/activity.model.dart' as AM;
import 'package:varenya_mobile/services/activity.service.dart';
import 'package:varenya_mobile/utils/logger.util.dart';
import 'package:varenya_mobile/widgets/appointments/appointment_card.widget.dart';
import 'package:varenya_mobile/widgets/daily_questionnaire/mood_chart.widget.dart';
import 'package:varenya_mobile/widgets/posts/post_card.widget.dart';

class Activity extends StatefulWidget {
  const Activity({Key? key}) : super(key: key);

  static const routeName = "/activity";

  @override
  _ActivityState createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  late final ActivityService _activityService;

  @override
  void initState() {
    super.initState();

    this._activityService =
        Provider.of<ActivityService>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Your Mood Cycle'),
            MoodChart(),
            FutureBuilder(
              future: this._activityService.fetchActivity(),
              builder: (
                BuildContext context,
                AsyncSnapshot<List<AM.Activity>> snapshot,
              ) {
                if (snapshot.hasError) {
                  switch (snapshot.error.runtimeType) {
                    case ServerException:
                      {
                        ServerException exception =
                            snapshot.error as ServerException;
                        return Text(exception.message);
                      }
                    default:
                      {
                        log.e(
                          "Activity Error",
                          snapshot.error,
                          snapshot.stackTrace,
                        );
                        return Text(
                            "Something went wrong, please try again later");
                      }
                  }
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  List<AM.Activity> activities = snapshot.data!;

                  return Flexible(
                    fit: FlexFit.loose,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: activities.length,
                      itemBuilder: (BuildContext context, int index) {
                        AM.Activity activity = activities[index];

                        return activity.activityType == "POST"
                            ? PostCard(post: activity.post!)
                            : activity.activityType == "APPOINTMENT"
                                ? AppointmentCard(
                                    appointment: activity.appointment!,
                                    refreshAppointments: () {
                                      setState(() {});
                                    })
                                : SizedBox();
                      },
                    ),
                  );
                }

                return Column(
                  children: [
                    CircularProgressIndicator(),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
