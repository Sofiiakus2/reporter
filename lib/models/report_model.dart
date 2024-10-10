class ReportModel{
  final DateTime date;
  final int countOfTasks;
  final int doneTasks;
  final List<String> plansToDo;
  final String? userName;

  ReportModel({
    required this.date,
    required this.countOfTasks,
    required this.doneTasks,
    required this.plansToDo,
    this.userName,
});

  ReportModel copyWith({
    String? userName,
    DateTime? date,
    int? countOfTasks,
    int? doneTasks,
    List<String>? plansToDo,
  }) {
    return ReportModel(
      userName: userName ?? this.userName,
      date: date ?? this.date,
      countOfTasks: countOfTasks ?? this.countOfTasks,
      doneTasks: doneTasks ?? this.doneTasks,
      plansToDo: plansToDo ?? this.plansToDo,
    );
  }

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      date: DateTime.parse(json['date']),
      countOfTasks: json['countOfTasks'],
      plansToDo: List<String>.from(json['plansToDo']),
      doneTasks: json['doneTasks'],
    );
  }
}