import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:varenya_mobile/models/doctor/doctor.model.dart';
import 'package:varenya_mobile/pages/doctor/doctor_details.page.dart';
import 'package:varenya_mobile/widgets/doctor/display_specializations.widget.dart';
import 'package:varenya_mobile/widgets/doctor/doctor_card_name_specialization.widget.dart';

class DoctorCard extends StatelessWidget {
  final Doctor doctor;

  const DoctorCard({
    Key? key,
    required this.doctor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.02,
        vertical: MediaQuery.of(context).size.height * 0.02,
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            DoctorDetails.routeName,
            arguments: this.doctor,
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              15.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.01,
                ),
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
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width * 0.6,
                        imageUrl: this.doctor.imageUrl,
                      ),
                    ),
                    DoctorCardNameSpecialization(
                      doctor: doctor,
                    ),
                  ],
                ),
              ),
              Divider(),
              DisplaySpecializations(
                doctor: doctor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
