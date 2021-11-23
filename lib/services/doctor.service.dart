import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:varenya_mobile/enum/job.enum.dart';
import 'package:varenya_mobile/enum/specialization.enum.dart';

class DoctorService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchDoctorsStream(
    Job? jobFilter,
    List<Specialization> specializationsFilter,
  ) {
    if (jobFilter != null && specializationsFilter.length == 0) {
      return this
          ._firestore
          .collection('doctors')
          .where('jobTitle', isEqualTo: jobFilter.toString().split('.')[1])
          .snapshots();
    } else if (jobFilter == null && specializationsFilter.length > 0) {
      return this
          ._firestore
          .collection('doctors')
          .where('specializations',
              arrayContainsAny: specializationsFilter
                  .map((s) => s.toString().split('.')[1])
                  .toList())
          .snapshots();
    } else if (jobFilter != null && specializationsFilter.length > 0) {
      return this
          ._firestore
          .collection('doctors')
          .where('jobTitle', isEqualTo: jobFilter.toString().split('.')[1])
          .where('specializations',
              arrayContainsAny: specializationsFilter
                  .map((s) => s.toString().split('.')[1])
                  .toList())
          .snapshots();
    } else {
      return this._firestore.collection('doctors').snapshots();
    }
  }
}
