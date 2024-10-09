import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/dates.dart';
import '../models/report_model.dart';

class ReportsView extends StatefulWidget {
  const ReportsView({
    super.key, required this.funk, required this.isMine,
  });

  final bool isMine;
  final Stream<List<ReportModel>> funk;
  @override
  State<ReportsView> createState() => _ReportsViewState();
}

class _ReportsViewState extends State<ReportsView> {
  List<String> daysOfWeek = DatesNames.daysOfWeek;
  List<String> monthsOfYear = DatesNames.monthsOfYear;


  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return StreamBuilder<List<ReportModel>>(
      stream: widget.funk,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final reports = snapshot.data ?? [];

        if (reports.isEmpty) {
          return Text('Ще немає звітів про роботу') ;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: reports.length,
              itemBuilder: (context, index) {
                final report = reports[index];
                String dayOfWeek = daysOfWeek[report.date.weekday - 1];
                String month = monthsOfYear[report.date.month - 1];

                String formattedDate = '${report.date.day} $month - $dayOfWeek';
                double persantage = (report.doneTasks/report.countOfTasks*100);
                if(persantage.isNaN){
                  persantage = 0;
                }
                return  GestureDetector(
                  onTap: () async {},
                  child: Container(
                    margin: const EdgeInsets.only(top: 5),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    height: screenSize.width / 3,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if(!widget.isMine)
                          Text('Name'),
                        Text(formattedDate,
                          style: TextStyle(fontSize: 18),),
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Кількість поставлених задач: ',
                              style: TextStyle(fontSize: 16),),
                            Text(report.countOfTasks.toString(),
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Кількість виконаних задач: ',
                              style: TextStyle(fontSize: 16),),
                            Text(report.doneTasks.toString(),
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Відсоток виконаної роботи: ',
                              style: TextStyle(fontSize: 16),),
                            Text('${persantage.toStringAsFixed(1)}%',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
