import 'package:flutter/material.dart';
import 'package:reporter/models/dates.dart';
class TodayWidget extends StatelessWidget {
  const TodayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const List<String> daysOfWeek = DatesNames.daysOfWeek;
    const List<String> monthsOfYear = DatesNames.monthsOfYear;

    DateTime now = DateTime.now();

    String dayOfWeek = daysOfWeek[now.weekday - 1];
    String month = monthsOfYear[now.month - 1];

    String formattedDate = '$dayOfWeek - ${now.day} $month';

    return  Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Сьогодні:',
          style: TextStyle(
            fontSize: 18
          ),),
          Text(formattedDate,
              style: TextStyle(
                  fontSize: 32
              )),
        ],
      ),
    );
  }
}
