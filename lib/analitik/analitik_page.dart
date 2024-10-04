import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/dates.dart';
import '../models/report_model.dart';
import '../services/report_service.dart';
import '../today_date_widget/today_widget.dart';

class AnalitikPage extends StatefulWidget {
  const AnalitikPage({super.key});

  @override
  State<AnalitikPage> createState() => _AnalitikPageState();
}

class _AnalitikPageState extends State<AnalitikPage> {
  List<String> daysOfWeek = DatesNames.daysOfWeek;
  List<String> monthsOfYear = DatesNames.monthsOfYear;


  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TodayWidget(),
              StreamBuilder<List<ReportModel>>(
                stream: ReportService.getReportsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final reports = snapshot.data ?? [];

                  if (reports.isEmpty) {
                    return Center(child: Text('No reports available.'));
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ваші результати:', style: TextStyle(fontSize: 18),),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: reports.length,
                        itemBuilder: (context, index) {
                          final report = reports[index];
                          String dayOfWeek = daysOfWeek[report.date.weekday - 1];
                          String month = monthsOfYear[report.date.month - 1];

                          String formattedDate = '${report.date.day} $month - $dayOfWeek';

                          double persantage = (report.countOfTasks/report.doneTasks)*100;
                          return  GestureDetector(
                            onTap: () async {},
                            child: Container(
                              margin: const EdgeInsets.only(top: 20),
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
                                      Text('${persantage.toString()}%',
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
