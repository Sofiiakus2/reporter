import 'dart:async';
import 'package:flutter/material.dart';
import 'package:reporter/home/main_progres_view.dart';
import 'package:reporter/home/progress_painter.dart';
import 'package:reporter/home/task_block_view.dart';
import 'package:reporter/services/auth_service.dart';
import 'package:reporter/services/statistic_service.dart';
import 'package:reporter/services/user_service.dart';
import 'package:reporter/theme.dart';
import 'package:reporter/today_date_widget/today_widget.dart';

import 'check_progress_painter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, bool> planToDo = {};
  List<bool> isCheckedToDo = [];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: EdgeInsets.only(top: 70),
            child: Column(
              children: [
                MainProgresView(),
                SizedBox(height: 70,),
                Text('Задачi на сьогоднi',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                StreamBuilder<Map<String, bool>>(
                    stream: UserService().getPlanToDoStream(),
                    builder: (context, snapshot){
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
        
                      planToDo = snapshot.data ?? {};
                      isCheckedToDo = planToDo.values.toList();
        
                      return planToDo.isNotEmpty
                          ? ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: planToDo.length,
                          itemBuilder: (context, index){
                            String task = planToDo.keys.elementAt(index);
                            bool isChecked = isCheckedToDo[index];
                            return Column(
                              children: [
                                TaskBlockView(title: task, isChecked: isChecked,),
                                SizedBox(height: 25,)
                              ],
                            );
                          }
                      )
                          : Text('Не знайдено задач', style: Theme.of(context).textTheme.bodySmall,);
                    }
                ),
                SizedBox(height: kBottomNavigationBarHeight/2)
        
              ],
            ),
          ),
        ),
      ),
    );
  }
}
