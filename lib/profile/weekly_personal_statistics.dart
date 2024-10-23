import 'package:flutter/material.dart';

import '../services/statistic_service.dart';
import '../theme.dart';

class WeeklyPersonalStatistics extends StatelessWidget {
  const WeeklyPersonalStatistics({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
        future: StatisticService.countMyPreviousWeekProgress(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return CircularProgressIndicator(color: primaryColor,);
          }
          double progress = snapshot.data!['progress'];
          int countOfDoneTasks = snapshot.data!['countOfDoneTasks'];
          int countOfTasks = snapshot.data!['countOfTasks'];
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 180,
                height: 200,
                padding: EdgeInsets.only(top: 25, left: 20),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${(progress*100).toStringAsFixed(0)}%',
                      style: Theme.of(context).textTheme.labelLarge,),
                    Text(
                      'Ваша результативність за попередній тиждень',
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: null,
                      overflow: TextOverflow.visible,
                    ),
                  ],
                ),
              ),
              Container(
                width: 180,
                height: 200,
                padding: EdgeInsets.only(top: 25, left: 20),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(countOfDoneTasks.toString(),
                      style: Theme.of(context).textTheme.labelLarge,),
                    Text(
                      'Задач було виконано з $countOfTasks поставлених',
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: null,
                      overflow: TextOverflow.visible,
                    ),
                  ],
                ),
              ),
            ],
          );
        }
    );
  }
}

