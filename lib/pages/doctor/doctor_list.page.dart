import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/enum/job.enum.dart';
import 'package:varenya_mobile/enum/specialization.enum.dart';
import 'package:varenya_mobile/models/doctor/doctor.model.dart';
import 'package:varenya_mobile/services/doctor.service.dart';

class DoctorList extends StatefulWidget {
  const DoctorList({Key? key}) : super(key: key);

  static const routeName = "/doctor-list";

  @override
  _DoctorListState createState() => _DoctorListState();
}

class _DoctorListState extends State<DoctorList> {
  late final DoctorService _doctorService;

  Job? _jobFilter;
  List<Specialization> _specializationsFilter = [];
  late final List<Doctor> _doctors;

  @override
  void initState() {
    super.initState();

    this._doctorService = Provider.of<DoctorService>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctors'),
      ),
      body: StreamBuilder(
        stream: this
            ._doctorService
            .fetchDoctorsStream(_jobFilter, _specializationsFilter),
        builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
        ) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return Text('Error');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              children: [
                CircularProgressIndicator(),
              ],
            );
          }

          this._doctors = snapshot.data!.docs
              .map((data) => Doctor.fromJson(data.data()))
              .toList();

          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Placeholder'),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: this._doctors.length,
                  itemBuilder: (BuildContext context, int index) {
                    Doctor doctor = this._doctors[index];

                    return Text(doctor.fullName);
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
