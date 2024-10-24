import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reporter/home/tasks_list_view.dart';
import 'package:reporter/tasks/day_in_calendar.dart';

import '../services/statistic_service.dart';
import 'adding_new_tasks/add_new_task_dialog.dart';
import 'daily_linear_progress.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> with SingleTickerProviderStateMixin {
  DateTime now = DateTime.now();
  int selectedIndex = 5;
  late ScrollController _scrollController;
  double progress = 0.0;

  Future<void> updateProgress() async {
    DateTime selectedDate = _getSelectedDate(selectedIndex);
    FirebaseAuth auth = FirebaseAuth.instance;
    User? currentUser = auth.currentUser;
    double progress1 = await StatisticService.countMyProgressForDay(selectedDate, currentUser!.uid);
    setState(() {
      progress = progress1;
    });
  }

  DateTime _getSelectedDate(int index) {
    List<DateTime> workDays = DayInCalendar.getWorkDays(now);

    return workDays[index];
  }


  @override
  void initState() {
    super.initState();
    updateProgress();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToToday();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToToday() {
    double targetScrollOffset = (selectedIndex - 2) * 85.0;
    _scrollController.animateTo(
      targetScrollOffset,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }




  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 70),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 100,
                margin: EdgeInsets.only(bottom: 40),
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    bool isSelected = selectedIndex == index;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                          updateProgress();
                        });
                      },
                      child: DayInCalendar(isSelected: isSelected, index: index),
                    );
                  },
                ),
              ),
        
              DayliLinearProgress(progress: progress),
              if(selectedIndex == 5)
              GestureDetector(
                onTap: (){
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AddNewTaskDialog(isToday: true);
                    },
                  );
                },
                child: Container(
                  width: screenSize.width,
                  height: 60,
                  margin: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 10),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    color: Colors.white,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xfff0f0f7),
                        Color(0xfff0f1f8),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        spreadRadius: 3,
                        blurRadius: 10,
                        offset: Offset(10, 10),
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(0.8),
                        spreadRadius: 0,
                        blurRadius: 10,
                        offset: Offset(-10, -8),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Додати нову задачу',
                        style: Theme.of(context).textTheme.labelMedium,
                      )

                    ],
                  ),
                ),
              ),
              TasksListView(day: _getSelectedDate(selectedIndex),),
        
            ],
          ),
        ),
      ),
    );
  }

}
