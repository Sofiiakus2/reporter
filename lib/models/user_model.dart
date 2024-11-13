import 'package:reporter/models/report_model.dart';

class UserModel{
  final String? id;
  final String? role;
  final String? name;
  final String? department;
  final String? position;
  final String email;
  final String? password;
  final Map<String, bool>? plansToDo;
  final int? countOfTasks;
  final int? countOfDoneTasks;

  UserModel({
    this.id,
    this.role,
   this.name,
    this.department,
    this.position,
   required this.email,
   this.password,
    this.plansToDo,
    this.countOfTasks,
    this.countOfDoneTasks,

});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String?,
      role: json['role'] as String?,
      name: json['name'] as String?,
      department: json['department'] as String?,
      email: json['email'] as String,
      plansToDo: (json['plansToDo'] as Map<String, dynamic>?)
          ?.map((key, value) => MapEntry(key, value as bool)),
      countOfTasks: json['countOfTasks'] as int?,
      countOfDoneTasks: json['countOfDoneTasks'] as int?,

    );
  }
}