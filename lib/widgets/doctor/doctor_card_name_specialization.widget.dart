import 'package:flutter/material.dart';
import 'package:varenya_mobile/models/doctor/doctor.model.dart';

class DoctorCardNameSpecialization extends StatelessWidget {
  final Doctor doctor;

  const DoctorCardNameSpecialization({
    Key? key,
    required this.doctor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.02,
          ),
          child: Text(
            'Dr. ${this.doctor.fullName}',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.03,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.02,
          ),
          child: Text(
            this.doctor.jobTitle,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.023,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
