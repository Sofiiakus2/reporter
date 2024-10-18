import 'package:flutter/material.dart';
import 'package:reporter/home/task_block_view.dart';
import '../services/user_service.dart';

class TasksListView extends StatelessWidget {
  TasksListView({super.key, required this.day});
  final DateTime day;
  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: UserService().getPlanToDoStream(day),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        List<Map<String, dynamic>> planToDoList = snapshot.data ?? [];

        if (planToDoList.isEmpty) {
          return Text('Не знайдено задач', style: Theme.of(context).textTheme.bodySmall);
        }

        bool isToday = false;
        if(day.year == now.year && day.month == now.month && day.day == now.day){
          isToday = true;
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: planToDoList.length,
          itemBuilder: (context, index) {
            String task = planToDoList[index]['task'];
            String description = planToDoList[index]['description'];
            bool isChecked = planToDoList[index]['completed'] ?? false;

            return Column(
              children: [
                TaskBlockView(title: task, description: description, isChecked: isChecked, isToday: isToday,),
                const SizedBox(height: 25),
              ],
            );
          },
        );
      },
    );
  }
}
