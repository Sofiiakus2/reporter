import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reporter/models/report_model.dart';
import 'package:reporter/services/report_service.dart';
import 'package:reporter/services/user_service.dart';
import 'package:reporter/today_date_widget/today_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  List<TextEditingController> taskWidgets = [TextEditingController()];
  Map<String, bool> planToDo = {};
  List<bool> isCheckedToDo = [];
  bool tasksScheduled = false;


  @override
  void initState() {
    super.initState();
    _loadTasksScheduled();
  }

  Future<void> _loadTasksScheduled() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime today = DateTime.now();
    String todayKey = '${today.year}-${today.month}-${today.day}';

    setState(() {
      tasksScheduled = prefs.getBool(todayKey) ?? false;
    });
  }

  Future<void> _setTasksScheduled(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime today = DateTime.now();
    String todayKey = '${today.year}-${today.month}-${today.day}';
    await prefs.setBool(todayKey, value);
  }

  @override
  void dispose() {
    for (var controller in taskWidgets) {
      controller.dispose();
    }
    super.dispose();
  }

  int countCompletedTasks() {
    return isCheckedToDo.where((isChecked) => isChecked).length;
  }

  Stream<Map<String, bool>> _getPlanToDoStream() async* {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      yield* FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .snapshots()
          .map((snapshot) {
        if (snapshot.exists) {
          Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

          if (data != null && data.containsKey('planToDo')) {
            Map<String, dynamic> planToDoData = data['planToDo'];
            if (planToDoData.containsKey('date')) {
              DateTime storedDate = DateTime.parse(planToDoData['date']);
              DateTime today = DateTime.now();
              if (storedDate.year == today.year &&
                  storedDate.month == today.month &&
                  storedDate.day == today.day &&
                  planToDoData.containsKey('tasks')) {
                return Map<String, bool>.from(planToDoData['tasks']);
              }
            }
          }
        }
        return {};
      });
    } else {
      yield {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              margin: const EdgeInsets.only(left: 30, right: 30, top: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TodayWidget(),
                  Text(
                    tasksScheduled
                      ? 'Звіт за сьогодні сформовано.\n\nЗавтра тут з\'являться нові задачі'
                      : 'Створіть звіт',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 30,
                        color: Colors.black),
                  ),
                  StreamBuilder<Map<String, bool>>(
                    stream: _getPlanToDoStream(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      planToDo = snapshot.data ?? {};
                      isCheckedToDo = planToDo.values.toList();

                      return planToDo.isNotEmpty
                          ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          const Text(
                            'Відмітьте виконане за день',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 22,
                                color: Colors.black),
                          ),
                          const SizedBox(height: 10),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: planToDo.length,
                            itemBuilder: (context, index) {
                              String task = planToDo.keys.elementAt(index);
                              bool isChecked = isCheckedToDo[index];

                              return CheckboxListTile(
                                title: Text(
                                  task,
                                  style: const TextStyle(color: Colors.black),
                                ),
                                value: isChecked,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isCheckedToDo[index] = value ?? false;
                                  });
                                  UserService.updateTaskStatus(task, value ?? false);
                                },
                                controlAffinity: ListTileControlAffinity.leading,
                                activeColor: Colors.black,
                                checkColor: Colors.white,
                              );
                            },
                          ),
                        ],
                      )
                          : Text(
                            tasksScheduled
                              ? ''
                              : 'Ви не поставили задачі на сьогодні. Заплануйте їх на завтра',
                          style: TextStyle(fontSize: 20));
                    },
                  ),
                  const SizedBox(height: 30),
                  tasksScheduled
                  ? SizedBox()
                  : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateTime.now().weekday == DateTime.friday || DateTime.now().weekday == DateTime.saturday
                            ? 'Плануйте на понеділок'
                            : 'Заплануйте роботу на завтра',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 22,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ListView.builder(
                        padding: const EdgeInsets.only(top: 20.0),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: taskWidgets.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    child: TextField(
                                      controller: taskWidgets[index],
                                      decoration: InputDecoration(
                                        suffixIcon: index == taskWidgets.length - 1
                                            ? Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  taskWidgets.removeAt(index);
                                                });
                                              },
                                              icon: const Icon(Icons.remove_circle_outline),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  taskWidgets.add(TextEditingController());
                                                });
                                              },
                                              icon: const Icon(Icons.add_circle_outline),
                                            ),
                                          ],
                                        )
                                            : IconButton(
                                          onPressed: () {
                                            setState(() {
                                              taskWidgets.removeAt(index);
                                            });
                                          },
                                          icon: const Icon(Icons.remove_circle_outline),
                                        ),
                                        hintText: 'Завдання',
                                        hintStyle: const TextStyle(
                                            fontSize: 16, fontWeight: FontWeight.bold),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(6.0),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
              SizedBox(
                height: WidgetsBinding.instance.window.viewInsets.bottom / WidgetsBinding.instance.window.devicePixelRatio,
              )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: ElevatedButton(
                onPressed: tasksScheduled
                    ? null
                    : () {
                  List<String> tasks = taskWidgets.map((controller) => controller.text).toList();
                  ReportModel newReport = ReportModel(
                    date: DateTime.now(),
                    countOfTasks: planToDo.length,
                    doneTasks: countCompletedTasks(),
                    plansToDo: tasks,
                  );
                  ReportService.saveReport(newReport);
                  UserService.setPlanToDo(tasks);
                  for (var controller in taskWidgets) {
                    controller.clear();
                  }
                  setState(() {
                    taskWidgets.clear();
                    taskWidgets.add(TextEditingController());
                    tasksScheduled = true;
                  });
                  _setTasksScheduled(true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: const Text(
                    'Сформувати звіт',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
