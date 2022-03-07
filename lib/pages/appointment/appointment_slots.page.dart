import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:varenya_mobile/models/doctor/doctor.model.dart';
import 'package:varenya_mobile/utils/palette.util.dart';
import 'package:varenya_mobile/utils/responsive_config.util.dart';
import 'package:varenya_mobile/widgets/appointments/appointment_doctor.widget.dart';
import 'package:varenya_mobile/widgets/appointments/appointment_slot_list.widget.dart';

class AppointmentSlots extends StatefulWidget {
  const AppointmentSlots({Key? key}) : super(key: key);

  // Page Route Name
  static const routeName = "/appointment-slots";

  @override
  _AppointmentSlotsState createState() => _AppointmentSlotsState();
}

class _AppointmentSlotsState extends State<AppointmentSlots> {
  // Doctor details.
  Doctor? doctorDetails;

  @override
  Widget build(BuildContext context) {
    // Save doctor details data from previous route as an argument.
    if (this.doctorDetails == null) {
      this.doctorDetails = ModalRoute.of(context)!.settings.arguments as Doctor;
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: responsiveConfig(
              context: context,
              large: MediaQuery.of(context).size.width * 0.25,
              medium: MediaQuery.of(context).size.width * 0.25,
              small: 0,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  imageUrl: this.doctorDetails!.imageUrl,
                  height: responsiveConfig(
                    context: context,
                    large: MediaQuery.of(context).size.height * 0.4,
                    medium: MediaQuery.of(context).size.height * 0.4,
                    small: MediaQuery.of(context).size.height * 0.3,
                  ),
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fitWidth,
                ),
                Container(
                  color: Palette.black,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: AppointmentDoctor(
                          doctor: this.doctorDetails!,
                        ),
                      ),
                      Divider(),
                    ],
                  ),
                ),
                AppointmentSlotList(
                  doctor: this.doctorDetails!,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
