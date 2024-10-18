import 'package:flutter/material.dart';

import '../theme.dart';

class DayInCalendar extends StatelessWidget {
  DayInCalendar({super.key, required this.isSelected, required this.index});
  final bool isSelected;
  final int index;
  DateTime now = DateTime.now();

  String getDayOfWeek(DateTime date) {
    List<String> days = ['НД', 'ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ','СБ'];
    return days[date.weekday % 7];
  }

  List<DateTime> getDates() {
    List<DateTime> workDays = [];
    DateTime currentDate = now;

    if(now.add(Duration(days: 1)).weekday == DateTime.saturday){
      currentDate = now.add(Duration(days: 3));
    }else if(now.add(Duration(days: 1)).weekday == DateTime.sunday){
      currentDate = now.add(Duration(days: 2));
    }
    else{
      currentDate = now.add(Duration(days: 1));
    }

    while (workDays.length < 7) {
      if (currentDate.weekday != DateTime.saturday && currentDate.weekday != DateTime.sunday) {
        workDays.add(currentDate);
      }
      currentDate = currentDate.subtract(Duration(days: 1));
    }

    return workDays.reversed.toList();
  }

  static List<DateTime> getWorkDays(DateTime now) {
    List<DateTime> workDays = [];
    DateTime currentDate = now;
    if(now.add(Duration(days: 1)).weekday == DateTime.saturday){
      currentDate = now.add(Duration(days: 3));
    }else if(now.add(Duration(days: 1)).weekday == DateTime.sunday){
      currentDate = now.add(Duration(days: 2));
    }
    else{
      currentDate = now.add(Duration(days: 1));
    }


    while (workDays.length < 7) {
      if (currentDate.weekday != DateTime.saturday && currentDate.weekday != DateTime.sunday) {
        workDays.add(currentDate);
      }
      currentDate = currentDate.subtract(Duration(days: 1));
    }
    return workDays.reversed.toList();
  }

  Widget build(BuildContext context) {
    List<DateTime> dates = getDates();

    return Container(
      width: 70,
      margin: EdgeInsets.symmetric(horizontal: 7.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: isSelected ? primaryColor.withOpacity(0.55) : Colors.grey.withOpacity(0.2),
        border: Border.all(
          color: isSelected ? primaryColor : Colors.transparent,
          width: 2.0,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            getDayOfWeek(dates[index]),
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey,
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
          Text(
            dates[index].day.toString(),
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey,
              fontWeight: FontWeight.w900,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
