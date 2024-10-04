class ReportModel{
  final DateTime date;
  final int countOfTasks;
  final int doneTasks;
  final List<String> plansToDo;

  ReportModel({
    required this.date,
    required this.countOfTasks,
    required this.doneTasks,
    required this.plansToDo
});

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      date: DateTime.parse(json['date']),
      countOfTasks: json['countOfTasks'],
      plansToDo: List<String>.from(json['plansToDo']),
      doneTasks: json['doneTasks'],
    );
  }
}