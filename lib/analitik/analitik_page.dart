import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reporter/analitik/analitik_bar_chart.dart';
import 'package:reporter/analitik/analitik_by_staff/analitik_by_staff.dart';
import 'package:reporter/tasks/day_in_calendar.dart';
import 'package:reporter/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/statistic_service.dart';
import 'custom_divider.dart';

class AnalitikPage extends StatefulWidget {
  const AnalitikPage({super.key});

  @override
  State<AnalitikPage> createState() => _AnalitikPageState();
}

class _AnalitikPageState extends State<AnalitikPage> {

  List<DateTime> days = DayInCalendar.getWorkDays(DateTime.now());
  int touchedGroupIndex = -1;
  String? role = 'user';
  DateTime day = DateTime.now();
  DateTime? selectedDate = DateTime.now();
  String userId = FirebaseAuth.instance.currentUser!.uid;

    Future<void> _loadData() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    role = preferences.getString('role');
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

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
                  TabBar(
                    tabs: [
                      Tab(text: 'Тиждень',),
                      Tab(text: 'Місяць',)
                    ],
                    labelStyle: Theme.of(context).textTheme.labelMedium,
                    unselectedLabelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.grey),
                    indicatorColor: primaryColor,
                    indicatorSize: TabBarIndicatorSize.label,
                    dividerColor: Colors.transparent,
                  ),
                  SizedBox(height: 50,),
                  SizedBox(
                    height: 400,
                      child: TabBarView(
                          children: [
                            AnalitikBarChart(isWeek: true,  onDateSelected: _updateSelectedDate, userId: userId,),
                            AnalitikBarChart(isWeek: false, onDateSelected: _updateSelectedDate, userId: userId,),
                          ])),
                  CustomDivider(),

                   if(role == 'admin' )
                     AnalitikByStaff(day: selectedDate!,)
                ],
              ),
            ),
          ),
        )
    );
  }


}

