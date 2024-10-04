import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/report_model.dart';

class ReportService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> saveReport(ReportModel report) async {
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      try {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(currentUser.uid).get();

        List<dynamic> currentReports = [];
        if (userDoc.exists) {
          Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?; // Приведення до Map
          if (userData != null && userData.containsKey('reports')) {
            currentReports = userData['reports'] as List<dynamic>;
          }
        }

        if (currentReports.length >= 5) {
          currentReports.sort((a, b) => DateTime.parse(a['date']).compareTo(DateTime.parse(b['date'])));
          currentReports.removeAt(0);
        }

        currentReports.add({
          'date': report.date.toIso8601String(),
          'countOfTasks': report.countOfTasks,
          'doneTasks': report.doneTasks,
          'plansToDo': report.plansToDo,
        });

        await _firestore.collection('users').doc(currentUser.uid).set({
          'reports': currentReports,
        }, SetOptions(merge: true));

      } catch (e) {
        print('Error saving report: $e');
      }
    }
  }



  static Stream<List<ReportModel>> getReportsStream() async* {
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      try {
        DocumentReference userDocRef = _firestore.collection('users').doc(currentUser.uid);

        yield* userDocRef.snapshots().asyncMap((userDoc) {
          Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
          List<dynamic>? reportsData = userData?['reports'] as List<dynamic>?;

          if (reportsData != null) {
            return reportsData
                .map((report) => ReportModel.fromJson(report as Map<String, dynamic>))
                .toList();
          } else {
            return [];
          }
        });
      } catch (e) {
        print('Error fetching reports: $e');
        yield [];
      }
    } else {
      yield [];
    }
  }


}
