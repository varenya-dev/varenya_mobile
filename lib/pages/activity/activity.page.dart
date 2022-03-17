import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/animations/error.animation.dart';
import 'package:varenya_mobile/animations/loading.animation.dart';
import 'package:varenya_mobile/animations/no_data.animation.dart';
import 'package:varenya_mobile/exceptions/server.exception.dart';
import 'package:varenya_mobile/models/activity/activity.model.dart' as AM;
import 'package:varenya_mobile/providers/user_provider.dart';
import 'package:varenya_mobile/services/activity.service.dart';
import 'package:varenya_mobile/services/alerts_service.dart';
import 'package:varenya_mobile/utils/logger.util.dart';
import 'package:varenya_mobile/utils/palette.util.dart';
import 'package:varenya_mobile/utils/responsive_config.util.dart';
import 'package:varenya_mobile/utils/snackbar.dart';
import 'package:varenya_mobile/widgets/appointments/appointment_card.widget.dart';
import 'package:varenya_mobile/widgets/daily_questionnaire/mood_chart.widget.dart';
import 'package:varenya_mobile/widgets/posts/post_card.widget.dart';
import 'package:varenya_mobile/widgets/user/user_options_modal.widget.dart';

class Activity extends StatefulWidget {
  const Activity({Key? key}) : super(key: key);

  // Activity Page Route Name.
  static const routeName = "/activity";

  @override
  _ActivityState createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  // Activity Service to fetch recent activities from.
  late final ActivityService _activityService;

  late final AlertsService _alertsService;

  // Fetched activities.
  List<AM.Activity>? _activities;

  @override
  void initState() {
    super.initState();

    // Inject Activity Service from global state.
    this._activityService =
        Provider.of<ActivityService>(context, listen: false);

    this._alertsService = Provider.of<AlertsService>(context, listen: false);
  }

  void _openUserOptions() {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            15.0,
          ),
          topRight: Radius.circular(
            15.0,
          ),
        ),
      ),
      backgroundColor: kIsWeb
          ? Colors.transparent
          : Theme.of(context).scaffoldBackgroundColor,
      context: context,
      builder: (BuildContext context) => UserOptionsModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.black54,
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05,
                    vertical: MediaQuery.of(context).size.height * 0.05,
                  ),
                  child: Consumer<UserProvider>(
                    builder:
                        (BuildContext context, UserProvider userProvider, _) {
                      User user = userProvider.user;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: Text(
                                  'Hello, ${user.displayName != null ? user.displayName!.split(' ')[0] : 'user'}',
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.height * 0.05,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.visible,
                                  maxLines: 5,
                                ),
                              ),
                              IconButton(
                                iconSize:
                                    MediaQuery.of(context).size.height * 0.056,
                                onPressed: this._openUserOptions,
                                icon: Icon(
                                  Icons.account_circle_rounded,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Here is your activity!',
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.03,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.01,
                    horizontal: MediaQuery.of(context).size.width * 0.05,
                  ),
                  child: Text(
                    'Your Mood Cycle',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                MoodChart(),
                Divider(),
                Container(
                  margin: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.01,
                    horizontal: MediaQuery.of(context).size.width * 0.05,
                  ),
                  child: Text(
                    'Emergency',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Center(
                  child: GestureDetector(
                    onTap: () async {
                      await this._alertsService.sendSOSNotifications();

                      displaySnackbar("SOS Notification sent", context);
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.width * 0.01,
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.015,
                        horizontal: MediaQuery.of(context).size.width * 0.1,
                      ),
                      decoration: BoxDecoration(
                        color: Palette.primary,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Text(
                        'SOS For Help',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Divider(),
                Container(
                  margin: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.01,
                    horizontal: MediaQuery.of(context).size.width * 0.05,
                  ),
                  child: Text(
                    'Your Activity',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                FutureBuilder(
                  future: this._activityService.fetchActivity(),
                  builder: _handleActivityFutureBuild,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /*
   * Method to build page based on the future results.
   */
  Widget _handleActivityFutureBuild(
    BuildContext context,
    AsyncSnapshot<List<AM.Activity>> snapshot,
  ) {
    // Check for errors
    if (snapshot.hasError) {
      // Check for error type and handle them accordingly.
      switch (snapshot.error.runtimeType) {
        case ServerException:
          {
            ServerException exception = snapshot.error as ServerException;
            return Error(message: exception.message);
          }
        default:
          {
            log.e(
              "Activity Error",
              snapshot.error,
              snapshot.stackTrace,
            );
            return Error(
                message: "Something went wrong, please try again later");
          }
      }
    }

    // Check if data has been loaded
    if (snapshot.connectionState == ConnectionState.done) {
      // Save fetched activities in local state.
      this._activities = snapshot.data!;

      // Returning page build function.
      return _buildActivitiesBody();
    }

    // If previously fetched activities exist,
    // display them else display loading indicator.
    return this._activities == null
        ? Loading(message: 'Loading your activities')
        : _buildActivitiesBody();
  }

  /*
   * Method to build activity page body.
   */
  Widget _buildActivitiesBody() {
    return this._activities!.length != 0
        ? Flexible(
            fit: FlexFit.loose,
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: this._activities!.length,
              itemBuilder: (BuildContext context, int index) {
                AM.Activity activity = this._activities![index];

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
          )
        : NoData(message: 'No activity to display');
  }
}
