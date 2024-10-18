import 'package:firebase_auth/firebase_auth.dart';
import 'package:reporter/models/user_model.dart';
import 'package:reporter/services/report_service.dart';
import 'package:reporter/services/user_service.dart';

import '../models/report_model.dart';

class StatisticService{

  static Future<double> countMyProgressForDay(DateTime targetDate) async {

     List<Map<String, dynamic>> planForDay = await UserService.getPlanToDo(targetDate);

      if (planForDay.isEmpty) {
        Stream<List<ReportModel>> reportsStream = ReportService.getReportsStream();
        List<ReportModel> reports = await reportsStream.first;

        ReportModel dayReport = reports.firstWhere(
              (report) => report.date.year == targetDate.year &&
              report.date.month == targetDate.month &&
              report.date.day == targetDate.day,
          orElse: () => ReportModel(
            date: targetDate,
            countOfTasks: 0,
            doneTasks: 0,
            plansToDo: [],
          ),
        );

        if (dayReport.countOfTasks > 0) {
          return dayReport.doneTasks / dayReport.countOfTasks;
        } else {
          return 0.0;
        }
      }

      // Count completed tasks
      int completedTasks = 0;
      planForDay.forEach((task) {
        if (task['completed'] == true) {
          completedTasks++;
        }
      });

      // Return the progress
      if (completedTasks == 0) {
        return 0.0;
      } else {
        return completedTasks / planForDay.length;
      }


    return 0.0;
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