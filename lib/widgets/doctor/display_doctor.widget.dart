import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:varenya_mobile/models/doctor/doctor.model.dart';
import 'package:varenya_mobile/utils/responsive_config.util.dart';
import 'package:varenya_mobile/widgets/doctor/display_popup_specialization.widget.dart';
import 'package:varenya_mobile/widgets/doctor/doctor_popup_button.widget.dart';
import 'package:varenya_mobile/widgets/doctor/doctor_popup_name_specialization.widget.dart';

class DisplayDoctor extends StatefulWidget {
  final Doctor doctor;

  const DisplayDoctor({
    Key? key,
    required this.doctor,
  }) : super(key: key);

  @override
  _DisplayDoctorState createState() => _DisplayDoctorState();
}

class _DisplayDoctorState extends State<DisplayDoctor> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      height: responsiveConfig(
        context: context,
        large: MediaQuery.of(context).size.height * 0.8,
        medium: MediaQuery.of(context).size.height * 0.8,
        small: MediaQuery.of(context).size.height * 0.7,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: responsiveConfig(
          context: context,
          large: MediaQuery.of(context).size.width * 0.25,
          medium: MediaQuery.of(context).size.width * 0.2,
          small: 0,
        ),
      ),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                height: responsiveConfig(
                  context: context,
                  large: MediaQuery.of(context).size.height * 0.4,
                  medium: MediaQuery.of(context).size.height * 0.4,
                  small: MediaQuery.of(context).size.height * 0.3,
                ),
                width: MediaQuery.of(context).size.width,
                imageUrl: this.widget.doctor.imageUrl,
              ),
            ),
            DoctorPopupNameSpecialization(
              doctor: this.widget.doctor,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.02,
              ),
              child: Text(
                this.widget.doctor.clinicAddress,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: MediaQuery.of(context).size.height * 0.03,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.02,
              ),
              child: Text(
                'Price: Rs. ${this.widget.doctor.cost.toStringAsFixed(2)}',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: MediaQuery.of(context).size.height * 0.03,
                ),
              ),
            ),
            Divider(),
            DisplayPopupSpecializations(
              doctor: this.widget.doctor,
            ),
            DoctorPopupButton(
              doctor: this.widget.doctor,
            ),
          ],
        ),
      ),
    );
  }
}
