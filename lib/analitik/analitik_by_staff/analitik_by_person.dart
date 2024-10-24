import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_common/get_reset.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:reporter/analitik/analitik_by_staff/task_block_view_expanded.dart';
import 'package:reporter/home/task_block_view.dart';

import '../../services/user_service.dart';
import '../../theme.dart';
import '../analitik_bar_chart.dart';
import '../custom_divider.dart';

class AnalitikByPerson extends StatefulWidget {
  const AnalitikByPerson({super.key, required this.userId});
  final String userId;

  @override
  State<AnalitikByPerson> createState() => _AnalitikByPersonState();
}

class _AnalitikByPersonState extends State<AnalitikByPerson> {
  int touchedGroupIndex = -1;

  DateTime day = DateTime.now();
  DateTime? selectedDate = DateTime.now();


  void _updateSelectedDate(DateTime date) {
    setState(() {
      selectedDate = date;
    });

  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 50),
            child: Column(
              children: [
                GestureDetector(
                  onTap: (){
                    Get.back();
                  },
                  child: Row(
                    children: [
                      Icon(Icons.navigate_before_rounded, size: 30, color: dividerColor,),
                      Text('Назад', style: Theme.of(context).textTheme.labelSmall!.copyWith(color: dividerColor),)
                    ],
                  ),
                ),
                TabBar(
                  tabs: [
                    Tab(text: 'Тиждень'),
                    Tab(text: 'Місяць'),
                  ],
                  labelStyle: Theme.of(context).textTheme.labelMedium,
                  unselectedLabelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.grey),
                  indicatorColor: primaryColor,
                  indicatorSize: TabBarIndicatorSize.label,
                  dividerColor: Colors.transparent,
                ),
                SizedBox(height: 50),
                SizedBox(
                  height: 400,
                  child: TabBarView(
                    children: [
                      AnalitikBarChart(isWeek: true, onDateSelected: _updateSelectedDate, userId: widget.userId,),
                      AnalitikBarChart(isWeek: false, onDateSelected: _updateSelectedDate, userId: widget.userId,),
                    ],
                  ),
                ),
                CustomDivider(),
                StreamBuilder<List<Map<String, dynamic>>>(
                    stream: UserService().getPlanToDoStream(selectedDate!, widget.userId),
                    builder: (context, snapshot){
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      List<Map<String, dynamic>> planToDoList = snapshot.data ?? [];

                      if (planToDoList.isEmpty) {
                        return Text('Не знайдено задач', style: Theme.of(context).textTheme.bodySmall);
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: planToDoList.length,
                        itemBuilder: (context, index) {
                          String task = planToDoList[index]['task'];
                          String description = planToDoList[index]['description'];
                          String comment = planToDoList[index]['comment'] ?? '';
                          bool isChecked = planToDoList[index]['completed'] ?? false;

                          return Column(
                            children: [
                              TaskBlockViewExpanded(title: task, description: description, isChecked: isChecked, isToday: false, comment: comment),
                              const SizedBox(height: 25),
                            ],
                          );
                        },
                      );
                    }
                )
            ],
            ),
          ),
        ),
      ),
    );
  }
}
