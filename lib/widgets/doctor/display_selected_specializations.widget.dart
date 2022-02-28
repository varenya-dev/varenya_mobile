import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/exceptions/server.exception.dart';
import 'package:varenya_mobile/models/specialization/specialization.model.dart';
import 'package:varenya_mobile/services/doctor.service.dart';
import 'package:varenya_mobile/utils/logger.util.dart';
import 'package:varenya_mobile/utils/palette.util.dart';
import 'package:varenya_mobile/utils/responsive_config.util.dart';

class DisplaySelectedSpecializations extends StatefulWidget {
  final List<Specialization> selectedSpecializations;
  final Function addOrRemoveSpecialization;

  const DisplaySelectedSpecializations({
    Key? key,
    required this.selectedSpecializations,
    required this.addOrRemoveSpecialization,
  }) : super(key: key);

  @override
  _DisplaySelectedSpecializationsState createState() =>
      _DisplaySelectedSpecializationsState();
}

class _DisplaySelectedSpecializationsState
    extends State<DisplaySelectedSpecializations> {
  late final DoctorService _doctorService;

  List<Specialization>? _fetchedSpecializations;

  @override
  void initState() {
    super.initState();

    this._doctorService = Provider.of<DoctorService>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: this._doctorService.fetchSpecializations(),
        builder: (
          BuildContext context,
          AsyncSnapshot<List<Specialization>> snapshot,
        ) {
          if (snapshot.hasError) {
            switch (snapshot.error.runtimeType) {
              case ServerException:
                {
                  ServerException exception = snapshot.error as ServerException;
                  return Text(exception.message);
                }
              default:
                {
                  log.e(
                    "DisplaySelectedSpecializations Error",
                    snapshot.error,
                    snapshot.stackTrace,
                  );
                  return Text("Something went wrong, please try again later");
                }
            }
          }

          if (snapshot.connectionState == ConnectionState.done) {
            this._fetchedSpecializations = snapshot.data!;

            return _buildSpecializationsList();
          }

          return this._fetchedSpecializations == null
              ? CircularProgressIndicator()
              : _buildSpecializationsList();
        },
      ),
    );
  }

  Widget _buildSpecializationsList() {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: responsiveConfig(
          context: context,
          large: MediaQuery.of(context).size.height * 0.05,
          medium: MediaQuery.of(context).size.height * 0.05,
          small: 0,
        ),
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        children: this._fetchedSpecializations!.map(
          (specialization) {
            bool checkSelected = this
                .widget
                .selectedSpecializations
                .where((s) => specialization.id == s.id)
                .isNotEmpty;

            return GestureDetector(
              onTap: () {
                this.widget.addOrRemoveSpecialization(specialization);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: !checkSelected
                      ? Palette.secondary
                      : Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(
                    15.0,
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.02,
                  horizontal: MediaQuery.of(context).size.width * 0.05,
                ),
                margin: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.01,
                  horizontal: MediaQuery.of(context).size.width * 0.015,
                ),
                child: Text(
                  specialization.specialization,
                  style: TextStyle(
                    color: checkSelected ? Colors.black : Colors.white,
                  ),
                ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}
