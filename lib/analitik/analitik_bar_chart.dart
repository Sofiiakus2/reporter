import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:reporter/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/dates.dart';
import '../services/statistic_service.dart';
import '../tasks/day_in_calendar.dart';
import '../theme.dart';

class AnalitikBarChart extends StatefulWidget {
  const AnalitikBarChart({super.key, required this.isWeek, required this.onDateSelected, required this.userId,});
  final bool isWeek;
  final Function(DateTime) onDateSelected;
  final String userId;

  @override
  State<AnalitikBarChart> createState() => _AnalitikBarChartState();
}

class _AnalitikBarChartState extends State<AnalitikBarChart> {
  List<DateTime> days = [];
  int touchedGroupIndex = -1;
  List<double>? progressData;
  int countOfDays = 0;
  bool isLoading = true;
  DateTime selectedDate = DateTime.now();

  String day = '';
  String month = '';


  String? role = 'user';

  Future<void> _loadData() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    role = preferences.getString('role');
  }

  Future<void> fetchDataWeek() async {
    days = DayInCalendar.getWorkDays(DateTime.now());
    countOfDays = days.length;
    List<double> progress = [];
    for (int i = 0; i < 7; i++) {
      if(role == 'admin'){
        List<String> allUserIds = await UserService.getAllUserIds();
        progress.add((await StatisticService.countTeamProgressForDay(days[i], allUserIds) * 100));
      }
      else if(role == 'subadmin'){
        progress.add((await StatisticService.countProgressForRole(days[i], widget.userId, role!) * 100));
      }
      else
      {
        progress.add((await StatisticService.countMyProgressForDay(days[i], widget.userId) * 100));
      }
    }

    setState(() {
      progressData = progress;
      isLoading = false;
    });
  }

  Future<void> fetchDataMonth() async {
    DateTime now = DateTime.now();
    List<double> progress = [];
    int daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);
    for(int i = 0; i < daysInMonth; i++){
      DateTime day = DateTime(now.year, now.month, i);
      if (day.weekday >= DateTime.monday && day.weekday <= DateTime.friday) {
        days.add(day);
        if(role == 'admin'){
          List<String> allUserIds = await UserService.getAllUserIds();
          progress.add((await StatisticService.countTeamProgressForDay(day, allUserIds) * 100));
        }
        else if(role == 'subadmin'){
          progress.add((await StatisticService.countProgressForRole(day, widget.userId, role!) * 100));
        }
        else{
          progress.add((await StatisticService.countMyProgressForDay(
                  day, widget.userId) *
              100));
        }
      }
    }

    countOfDays = progress.length;
    setState(() {
      progressData = progress;
      isLoading = false;
    });
  }

  void getSelectedDate() {
    if (touchedGroupIndex != -1 && touchedGroupIndex < days.length) {
      selectedDate = days[touchedGroupIndex];
      widget.onDateSelected(selectedDate);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData();
    widget.isWeek
      ? fetchDataWeek()
      : fetchDataMonth();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: primaryColor,),
                    SizedBox(height: 20,),
                    Text('Зачейте, дані завантажуються', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: primaryColor),)
                  ],
                )
                : Container(
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(touchedGroupIndex != -1 && progressData != null
                              ? '${progressData![touchedGroupIndex].toStringAsFixed(0)}%'
                              : '0%',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          Text('Результативність',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(day,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          Text(month,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),

                  Container(
                      height: 300,
                      margin: EdgeInsets.only(top: 30),
                      child: BarChart(
                          BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              maxY: 100,
                              titlesData: FlTitlesData(
                                show: true,
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 40,
                                    getTitlesWidget: (double value, TitleMeta meta) {
                                      var style = Theme.of(context).textTheme.bodySmall;
                                      if (widget.isWeek) {
                                        return Text(DayInCalendar.getDayOfWeek(days[value.toInt()]), style: style);
                                      } else {
                                        return value.toInt() % 5 == 0
                                            ? Text('${value.toInt() + 1}', style: style)
                                            : const SizedBox();
                                      }
                                    },
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 40,
                                    interval: 25,
                                    getTitlesWidget: (double value, TitleMeta meta) {
                                      return Text('${value.toInt()}',
                                        style: Theme.of(context).textTheme.bodySmall,);
                                    },
                                  ),
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              barGroups:  List.generate(countOfDays, (i) {
                                return makeGroupData(i, progressData![i], touchedGroupIndex == i, widget.isWeek);
                              }),

                              borderData: FlBorderData(
                                show: false,
                              ),
                              gridData: FlGridData(show: false),
                              barTouchData: BarTouchData(
                                  touchTooltipData: BarTouchTooltipData(
                                      getTooltipItem: (group, groupIndex, rod, rodIndex){
                                        return null;
                                      }
                                  ),
                                  touchCallback: (FlTouchEvent event, barTouchResponse){
                                    setState(() {
                                      if (!event.isInterestedForInteractions ||
                                          barTouchResponse == null ||
                                          barTouchResponse.spot == null) {
                                        //touchedGroupIndex = -1;
                                        return;
                                      }
                                      touchedGroupIndex = barTouchResponse.spot!.touchedBarGroupIndex;
                                      getSelectedDate();
                                      day = selectedDate.day.toString();
                                      month = DatesNames.monthsOfYear[selectedDate.month - 1];

                                    });
                                  }
                              )
                          )
                      )
                  )

                ],
              ),
            );

  }

  BarChartGroupData makeGroupData(int x, double y, bool isTouched, bool isWeek) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: isTouched ? primaryColor : dividerColor,
          width: isWeek ? 22 : 10,
          borderRadius: BorderRadius.circular(10),
        ),
      ],
    );
  }
}
