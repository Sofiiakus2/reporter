import 'package:reporter/models/report_model.dart';

class UserModel{
  final String? id;
  final String? role;
  final String? name;
  final String? department;
  final String email;
  final String? password;
  final Map<String, bool>? plansToDo;
  final int? countTaskForToday;
  final int? countDoneTasksForToday;
  final int? countMonthTasks;
  final int? countDoneManthTasks;
  final ReportModel? todayReport;

  UserModel({
    this.id,
    this.role,
   this.name,
    this.department,
   required this.email,
   this.password,
    this.plansToDo,
    this.countTaskForToday,
    this.countDoneTasksForToday,
    this.countMonthTasks,
    this.countDoneManthTasks,
    this.todayReport
});
}