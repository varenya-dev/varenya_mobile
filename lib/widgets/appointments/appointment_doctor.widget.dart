import 'package:flutter/material.dart';
import 'package:varenya_mobile/models/doctor/doctor.model.dart';

class AppointmentDoctor extends StatelessWidget {
  final Doctor doctor;

  const AppointmentDoctor({
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dr. ${this.doctor.fullName}',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.03,
            ),
          ),
          Text(
            this.doctor.jobTitle,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.02,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
