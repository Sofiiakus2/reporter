import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reporter/models/user_model.dart';
import 'package:reporter/services/user_service.dart';
import '../models/report_model.dart';

class ReportService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> saveReport(ReportModel report) async {
    User? currentUser = _auth.currentUser;
    int countOfTasks = 0;
    int countOfDoneTasks = 0;

    if (currentUser != null) {
      try {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(currentUser.uid).get();

        List<dynamic> currentReports = [];
        if (userDoc.exists) {
          Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
          if (userData != null && userData.containsKey('reports')) {
            currentReports = userData['reports'] as List<dynamic>;

            if (_isFirstWeekdayOfMonth()) {
              countOfTasks = 0;
              countOfDoneTasks = 0;
            } else {
              countOfTasks = userData['countOfTasks'] ?? 0;
              countOfDoneTasks = userData['countOfDoneTasks'] ?? 0;
            }
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
          'countOfTasks': countOfTasks + report.countOfTasks,
          'countOfDoneTasks': countOfDoneTasks + report.doneTasks,
        }, SetOptions(merge: true));

      } catch (e) {
        Exception('Error saving report: $e');
      }
    }
  }

  static bool _isFirstWeekdayOfMonth() {
    DateTime today = DateTime.now();
    DateTime firstDayOfMonth = DateTime(today.year, today.month, 1);

    while (firstDayOfMonth.weekday == DateTime.saturday || firstDayOfMonth.weekday == DateTime.sunday) {
      firstDayOfMonth = firstDayOfMonth.add(Duration(days: 1));
    }

    return today.year == firstDayOfMonth.year &&
        today.month == firstDayOfMonth.month &&
        today.day == firstDayOfMonth.day;
  }



  static Stream<List<ReportModel>> getReportsStream() async* {

    try {
      User? currentUser = _auth.currentUser;
        DocumentReference userDocRef = _firestore.collection('users').doc(currentUser!.uid);

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
        Exception('Error fetching reports: $e');
        yield [];
      }

  }


  static Stream<List<ReportModel>> getReportsByDepartmentsStream(String department) async* {
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      try {
        yield* _firestore
            .collection('users')
            .where('department', isEqualTo: department)
            .snapshots()
            .asyncMap((snapshot) {
          List<ReportModel> reports = [];

          for (var userDoc in snapshot.docs) {
            if (userDoc.id != currentUser.uid) {
              Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
              List<dynamic>? reportsData = userData?['reports'] as List<dynamic>?;
              String? userName = userData?['name'];

              if (reportsData != null) {
                reports.addAll(
                  reportsData.map((report) {
                    var reportModel = ReportModel.fromJson(report as Map<String, dynamic>);

                    reportModel = reportModel.copyWith(userName: userName);

                    return reportModel;
                  }).toList(),
                );
              }
            }
          }

          return reports;
        });
      } catch (e) {
        Exception('Error fetching reports: $e');
        yield [];
      }
    } else {
      yield [];
    }
  }


  static Stream<List<UserModel>> getReportsForAdminStream() async* {
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      try {
        yield* _firestore.collection('users').snapshots().asyncMap((snapshot) {
          List<UserModel> users = [];

          for (var userDoc in snapshot.docs) {
            if (userDoc.id != currentUser.uid) {
              Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;

              users.add(UserModel.fromJson(userData!));
            }
          }

          return users;
        });
      } catch (e) {
        Exception('Error fetching reports: $e');
        yield [];
      }
    } else {
      yield [];
    }
  }

  static Stream<List<UserModel>> getReportsForSameDepartmentStream() async* {
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      try {
        String? userDepartment = await UserService.getUserDepartment();

        if (userDepartment != null) {
          yield* _firestore
              .collection('users')
              .where('department', isEqualTo: userDepartment)
              .snapshots()
              .asyncMap((snapshot) {
            List<UserModel> users = [];

            for (var userDoc in snapshot.docs) {
              if (userDoc.id != currentUser.uid) {
                Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;

                users.add(UserModel.fromJson(userData!));
              }
            }

            return users;
          });
        } else {
          yield [];
        }
      } catch (e) {
        print('Error fetching reports: $e');
        yield [];
      }
    } else {
      yield [];
    }
  }



}
