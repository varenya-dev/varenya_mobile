import 'package:flutter/material.dart';
import 'package:varenya_mobile/models/doctor/doctor.model.dart';
import 'package:varenya_mobile/pages/doctor/doctor_details.page.dart';
import 'package:varenya_mobile/widgets/common/profile_picture_widget.dart';

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05,
                  vertical: MediaQuery.of(context).size.height * 0.03,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ProfilePictureWidget(
                      imageUrl: doctor.imageUrl,
                      size: MediaQuery.of(context).size.height * 0.13,
                    ),
                    Text(doctor.fullName),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05,
                  vertical: MediaQuery.of(context).size.height * 0.03,
                ),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Position:',
                      ),
                      TextSpan(
                        text: this.doctor.jobTitle,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  children: this
                      .doctor
                      .specializations
                      .map(
                        (specialization) => Container(
                          margin: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.005,
                          ),
                          child: Chip(
                            label: Text(
                              specialization.specialization,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
