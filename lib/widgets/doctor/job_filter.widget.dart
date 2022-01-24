import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/exceptions/server.exception.dart';
import 'package:varenya_mobile/services/doctor.service.dart';
import 'package:varenya_mobile/utils/logger.util.dart';

class JobFilter extends StatefulWidget {
  final Function setJobFilter;
  final VoidCallback resetJobFilter;
  final String jobFilter;

  const JobFilter({
    Key? key,
    required this.setJobFilter,
    required this.resetJobFilter,
    required this.jobFilter,
  }) : super(key: key);

  @override
  _JobFilterState createState() => _JobFilterState();
}

class _JobFilterState extends State<JobFilter> {
  late final DoctorService _doctorService;
  List<String>? _jobs;

  @override
  void initState() {
    super.initState();

    this._doctorService = Provider.of<DoctorService>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        FutureBuilder(
          future: this._doctorService.fetchJobTitles(),
          builder:
              (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
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
                      "DoctorList:_openJobFilters Error",
                      snapshot.error,
                      snapshot.stackTrace,
                    );
                    return Text(
                      "Something went wrong, please try again later",
                    );
                  }
              }
            }

            if (snapshot.connectionState == ConnectionState.done) {
              this._jobs = snapshot.data!;
              return this._buildFilterBody();
            }

            return this._jobs == null
                ? Column(
                    children: [
                      CircularProgressIndicator(),
                    ],
                  )
                : this._buildFilterBody();
          },
        ),
        Center(
          child: TextButton(
            child: Text('Clear Filters'),
            onPressed: this.widget.resetJobFilter,
          ),
        )
      ],
    );
  }

  ListView _buildFilterBody() {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: this
          ._jobs!
          .map(
            (job) => ListTile(
              title: Text(
                job,
              ),
              leading: Radio(
                value: job,
                groupValue: this.widget.jobFilter,
                onChanged: (String? value) {
                  this.widget.setJobFilter(value);
                },
              ),
            ),
          )
          .toList(),
    );
  }
}
