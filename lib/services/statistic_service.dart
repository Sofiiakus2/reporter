import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reporter/models/user_model.dart';
import 'package:reporter/services/report_service.dart';
import 'package:reporter/services/user_service.dart';

import '../models/report_model.dart';

class StatisticService{

  static FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<double> countMyProgressForDay(DateTime targetDate, String userId) async {

     List<Map<String, dynamic>> planForDay = await UserService.getPlanToDo(targetDate, userId);

      int completedTasks = 0;
      planForDay.forEach((task) {
        if (task['completed'] == true) {
          completedTasks++;
        }
      });

      if (completedTasks == 0) {
        return 0.0;
      } else {
        return completedTasks / planForDay.length;
      }

  }

  static Future<Map<String, dynamic>> countMyPreviousWeekProgress() async {
    double progress = 0.0;
    int countOfDoneTasks = 0;
    int countOfTasks = 0;

    User? currentUser = _auth.currentUser;
    DateTime now = DateTime.now();
    DateTime lastMonday = now.subtract(Duration(days: now.weekday + 6));
    DateTime lastFriday = lastMonday.add(Duration(days: 4));

    Stream<UserModel?> userDataStream = UserService().getUserData();

    await for (UserModel? userModel in userDataStream) {
      if (userModel != null) {
        for (DateTime day = lastMonday; day.isBefore(lastFriday) || day.isAtSameMomentAs(lastFriday); day = day.add(Duration(days: 1))) {
          List<Map<String, dynamic>> planForDay = await UserService.getPlanToDo(day, currentUser!.uid);

          countOfTasks += planForDay.length;
          planForDay.forEach((task) {
            if (task['completed'] == true) {
              countOfDoneTasks++;
            }
          });


          if (countOfTasks > 0) {
            progress = countOfDoneTasks / countOfTasks;
          }
        }

      }

      break;
    }

    return {
      'progress': progress,
      'countOfDoneTasks': countOfDoneTasks,
      'countOfTasks': countOfTasks,
    };
  }

  static Future<double> countTeamProgressForDay(DateTime targetDate, List<String> userIds) async {
    int totalTasks = 0;
    int completedTasks = 0;

   // print('--------------------------------');
  //  print(userIds.length);
    for (String userId in userIds) {
      List<Map<String, dynamic>> planForDay = await UserService.getPlanToDo(targetDate, userId);
     // print('--${userId}--------${planForDay}--------${targetDate}---');
      totalTasks += planForDay.length;

    //  print('=========================');
     // print(totalTasks);
      for (var task in planForDay) {
        if (task['completed'] == true) {
          completedTasks++;
        //  print('C $completedTasks');
        }
      }
    }

    if (totalTasks == 0) {
      return 0.0;
    } else {
      return completedTasks / totalTasks;
    }
  }


  static Future<double> countProgressForRole(DateTime targetDate, String userId, String role) async {
    List<String> userIds = [];

    if (role == 'admin') {
      userIds = await UserService.getAllUserIds();
    } else if (role == 'subadmin') {
      String? department = await UserService.getUserDepartment();
      if (department != null) {
        userIds = await UserService.getUserIdsByDepartment(department);
      }
    }

    int totalTasks = 0;
    int completedTasks = 0;

    for (String uid in userIds) {
      List<Map<String, dynamic>> planForDay = await UserService.getPlanToDo(targetDate, uid);

      totalTasks += planForDay.length;

      for (var task in planForDay) {
        if (task['completed'] == true) {
          completedTasks++;
        }
      }
    }

    if (totalTasks == 0) {
      return 0.0;
    } else {
      return completedTasks / totalTasks;
    }
  }






// static Future<double> countMyMonthProgress() async {
  //   double progress = 0.0;
  //
  //   Stream<UserModel?> userDataStream = UserService().getUserData();
  //
  //   await for (UserModel? userModel in userDataStream) {
  //     if (userModel != null) {
  //       int countOfTasks = userModel.countOfTasks!;
  //       int countOfDoneTasks = userModel.countOfDoneTasks!;
  //
  //        if (countOfTasks > 0) {
  //          progress = (countOfDoneTasks / countOfTasks);
  //        }
  //     }
  //
  //     break;
  //   }
  //
  //
  //
  //   return progress;
  // }
  //
  // static Future<double> countAllUsersTodayProgressExceptCurrent() async {
  //   int globalCountOfTasks = 0;
  //   int globalCountOfDoneTasks = 0;
  //   User? currentUser = _auth.currentUser;
  //
  //   Stream<List<UserModel?>> allUsersStream = UserService().getAllUsersData();
  //
  //   await for (List<UserModel?> userList in allUsersStream) {
  //     for (UserModel? userModel in userList) {
  //
  //       if (userModel != null && userModel.id != currentUser?.uid) {
  //         Map<String, bool> planForToday = await UserService.getPlanToDo(userModel.id!);
  //         if (planForToday.isEmpty) {
  //           Stream<List<ReportModel>> reportsStream = ReportService.getReportsStream(userModel.id!);
  //           List<ReportModel> reports = await reportsStream.first;
  //
  //           DateTime today = DateTime.now();
  //
  //           ReportModel todayReport = reports.firstWhere(
  //                 (report) => report.date.year == today.year &&
  //                 report.date.month == today.month &&
  //                 report.date.day == today.day,
  //             orElse: () => ReportModel(
  //                 date: today,
  //                 countOfTasks: 0,
  //                 doneTasks: 0,
  //                 plansToDo: []
  //             ),
  //
  //           );
  //
  //           if (todayReport != null && todayReport.countOfTasks > 0) {
  //             globalCountOfTasks += todayReport.countOfTasks;
  //             globalCountOfDoneTasks += todayReport.doneTasks;
  //           }
  //         }
  //         globalCountOfTasks += planForToday.length;
  //         planForToday.forEach((key, value){
  //           if(value==true) globalCountOfDoneTasks++;
  //         });
  //       }
  //     }
  //     if(globalCountOfTasks == 0){
  //       return 0;
  //     }else{
  //       return (globalCountOfDoneTasks/globalCountOfTasks);
  //     }
  //   }
  //
  //   return 0;
  //
  // }
  //
  // static Future<double> countAllUsersProgressExceptCurrent() async {
  //   double totalProgress = 0.0;
  //   int totalCountOfTasks = 0;
  //   int totalCountOfDoneTasks = 0;
  //   User? currentUser = _auth.currentUser;
  //
  //   Stream<List<UserModel?>> allUsersStream = UserService().getAllUsersData();
  //
  //   await for (List<UserModel?> userList in allUsersStream) {
  //     for (UserModel? userModel in userList) {
  //       if (userModel != null && userModel.id != currentUser?.uid) {
  //         totalCountOfTasks += userModel.countOfTasks ?? 0;
  //         totalCountOfDoneTasks += userModel.countOfDoneTasks ?? 0;
  //       }
  //     }
  //
  //     break;
  //   }
  //
  //   if (totalCountOfTasks > 0) {
  //     totalProgress = (totalCountOfDoneTasks / totalCountOfTasks) ;
  //   }
  //
  //   return totalProgress;
  // }
  //
  //
  // static Future<double> countAllUsersTodayProgressByDepartmentExceptCurrent() async {
  //   int globalCountOfTasks = 0;
  //   int globalCountOfDoneTasks = 0;
  //   User? currentUser = _auth.currentUser;
  //   String department = await UserService().getUserDepartment();
  //   Stream<List<UserModel?>> allUsersStream = UserService().getAllUsersData();
  //
  //   await for (List<UserModel?> userList in allUsersStream) {
  //
  //     for (UserModel? userModel in userList) {
  //
  //       if (userModel != null && userModel.id != currentUser?.uid && userModel.department == department) {
  //         Map<String, bool> planForToday = await UserService.getPlanToDo(userModel.id!);
  //         if (planForToday.isEmpty) {
  //           Stream<List<ReportModel>> reportsStream = ReportService.getReportsStream(userModel.id!);
  //           List<ReportModel> reports = await reportsStream.first;
  //
  //           DateTime today = DateTime.now();
  //
  //           ReportModel todayReport = reports.firstWhere(
  //                 (report) => report.date.year == today.year &&
  //                 report.date.month == today.month &&
  //                 report.date.day == today.day,
  //             orElse: () => ReportModel(
  //                 date: today,
  //                 countOfTasks: 0,
  //                 doneTasks: 0,
  //                 plansToDo: []
  //             ),
  //
  //           );
  //
  //           if (todayReport != null && todayReport.countOfTasks > 0) {
  //             globalCountOfTasks += todayReport.countOfTasks;
  //             globalCountOfDoneTasks += todayReport.doneTasks;
  //           }
  //         }
  //         globalCountOfTasks += planForToday.length;
  //         planForToday.forEach((key, value){
  //           if(value==true) globalCountOfDoneTasks++;
  //         });
  //       }
  //     }
  //     if(globalCountOfTasks == 0){
  //       return 0;
  //     }else{
  //       return (globalCountOfDoneTasks/globalCountOfTasks);
  //     }
  //   }
  //
  //   return 0;
  //
  // }
  //
  // static Future<double> countAllUsersProgressByDepartmentExceptCurrent() async {
  //   double totalProgress = 0.0;
  //   int totalCountOfTasks = 0;
  //   int totalCountOfDoneTasks = 0;
  //   User? currentUser = _auth.currentUser;
  //   String department = await UserService().getUserDepartment();
  //
  //   Stream<List<UserModel?>> allUsersStream = UserService().getAllUsersData();
  //
  //   await for (List<UserModel?> userList in allUsersStream) {
  //     for (UserModel? userModel in userList) {
  //       if (userModel != null && userModel.id != currentUser?.uid && userModel.department == department) {
  //         totalCountOfTasks += userModel.countOfTasks ?? 0;
  //         totalCountOfDoneTasks += userModel.countOfDoneTasks ?? 0;
  //       }
  //     }
  //
  //     break;
  //   }
  //
  //   if (totalCountOfTasks > 0) {
  //     totalProgress = (totalCountOfDoneTasks / totalCountOfTasks) ;
  //   }
  //
  //   return totalProgress;
  // }




}