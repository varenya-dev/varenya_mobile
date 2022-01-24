import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/exceptions/server.exception.dart';
import 'package:varenya_mobile/models/specialization/specialization.model.dart';
import 'package:varenya_mobile/services/doctor.service.dart';
import 'package:varenya_mobile/utils/logger.util.dart';

class SpecializationFilter extends StatefulWidget {
  final List<String> specializationsFilter;
  final Function addOrRemoveSpecializationFilter;
  final Function resetSpecializationFilter;

  SpecializationFilter({
    Key? key,
    required this.specializationsFilter,
    required this.addOrRemoveSpecializationFilter,
    required this.resetSpecializationFilter,
  }) : super(key: key);

  @override
  _SpecializationFilterState createState() => _SpecializationFilterState();
}

class _SpecializationFilterState extends State<SpecializationFilter> {
  late final DoctorService _doctorService;

  List<Specialization>? _specializations;

  @override
  void initState() {
    super.initState();

    this._doctorService = Provider.of<DoctorService>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setStateInner) => Wrap(
        children: [
          FutureBuilder(
            future: this._doctorService.fetchSpecializations(),
            builder: (BuildContext context,
                AsyncSnapshot<List<Specialization>> snapshot) {
              if (snapshot.hasError) {
                switch (snapshot.error.runtimeType) {
                  case ServerException:
                    {
                      ServerException exception =
                          snapshot.error as ServerException;
                      return Text(exception.message);
                    }
                  default:
                    {
                      log.e(
                        "SpecializationFilter Error",
                        snapshot.error,
                        snapshot.stackTrace,
                      );
                      return Text(
                          "Something went wrong, please try again later");
                    }
                }
              }

              if (snapshot.connectionState == ConnectionState.done) {
                this._specializations = snapshot.data!;
                return _buildFilterBody(setStateInner);
              }

              return this._specializations == null
                  ? Column(
                      children: [
                        CircularProgressIndicator(),
                      ],
                    )
                  : _buildFilterBody(setStateInner);
            },
          ),
          Center(
            child: TextButton(
              child: Text('Clear Filters'),
              onPressed: () {
                setStateInner(() {});
              },
            ),
          )
        ],
      ),
    );
  }

  ListView _buildFilterBody(StateSetter setStateInner) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: this
          ._specializations!
          .map(
            (s) => ListTile(
              title: Text(
                s.specialization,
              ),
              leading: Checkbox(
                value: this
                    .widget
                    .specializationsFilter
                    .contains(s.specialization),
                onChanged: (bool? value) {
                  this.widget.addOrRemoveSpecializationFilter(value, s);
                  setStateInner(() {});
                },
              ),
            ),
          )
          .toList(),
    );
  }
}
