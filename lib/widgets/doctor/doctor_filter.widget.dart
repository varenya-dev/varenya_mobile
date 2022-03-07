import 'package:flutter/material.dart';
import 'package:varenya_mobile/models/specialization/specialization.model.dart';
import 'package:varenya_mobile/utils/responsive_config.util.dart';
import 'package:varenya_mobile/widgets/doctor/display_selected_jobs.widget.dart';
import 'package:varenya_mobile/widgets/doctor/display_selected_specializations.widget.dart';

class DoctorFilter extends StatelessWidget {
  final List<Specialization> selectedSpecializations;
  final String selectedJob;
  final Function addOrRemoveSpecialization;
  final Function addOrRemoveJob;

  DoctorFilter({
    Key? key,
    required this.selectedSpecializations,
    required this.selectedJob,
    required this.addOrRemoveSpecialization,
    required this.addOrRemoveJob,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.03,
        left: MediaQuery.of(context).size.width * 0.03,
        right: MediaQuery.of(context).size.width * 0.03,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: responsiveConfig(
          context: context,
          large: MediaQuery.of(context).size.width * 0.25,
          medium: MediaQuery.of(context).size.width * 0.25,
          small: MediaQuery.of(context).size.width * 0.03,
        ),
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            15.0,
          ),
          topRight: Radius.circular(
            15.0,
          ),
        ),
      ),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.filter_list_outlined,
                  size: responsiveConfig(
                    context: context,
                    large: MediaQuery.of(context).size.width * 0.03,
                    medium: MediaQuery.of(context).size.width * 0.03,
                    small: MediaQuery.of(context).size.width * 0.08,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.02,
                  ),
                  child: Text(
                    'Filters',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.03,
                    ),
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.02,
              ),
              child: Text(
                'Specializations',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.03,
                ),
              ),
            ),
            DisplaySelectedSpecializations(
              selectedSpecializations: selectedSpecializations,
              addOrRemoveSpecialization: addOrRemoveSpecialization,
            ),
            Divider(),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.02,
              ),
              child: Text(
                'Jobs',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.03,
                ),
              ),
            ),
            DisplaySelectedJobs(
              selectedJob: selectedJob,
              addOrRemoveJob: addOrRemoveJob,
            ),
          ],
        ),
      ),
    );
  }
}
