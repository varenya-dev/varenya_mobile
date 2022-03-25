import 'package:flutter/material.dart';
import 'package:varenya_mobile/models/doctor/doctor.model.dart';
import 'package:varenya_mobile/utils/palette.util.dart';

class DisplaySpecializations extends StatelessWidget {
  const DisplaySpecializations({
    Key? key,
    required this.doctor,
  }) : super(key: key);

  final Doctor doctor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: this
            .doctor
            .specializations
            .map((specialization) => Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.01,
                  ),
                  child: Chip(
                    backgroundColor: Palette.primary,
                    label: Text(
                      specialization.specialization,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
