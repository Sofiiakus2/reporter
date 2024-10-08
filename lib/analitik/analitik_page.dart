import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reporter/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/dates.dart';
import '../models/report_model.dart';
import '../services/report_service.dart';
import '../today_date_widget/today_widget.dart';

class AnalitikPage extends StatefulWidget {
  const AnalitikPage({super.key});

  @override
  State<AnalitikPage> createState() => _AnalitikPageState();
}

class _AnalitikPageState extends State<AnalitikPage> with SingleTickerProviderStateMixin{

  late String? role;

  Future<void> _loadData() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    role = preferences.getString('role');

  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(30),
          child: FutureBuilder<String>(
              future: UserService().getUserDepartment(),
              builder: (context, snapshot){
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading department'));
                }

                final department = snapshot.data ?? '';
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TodayWidget(),
                    Text('Ваші результати:', style: TextStyle(fontSize: 18),),
                    ReportsView(funk: ReportService.getReportsStream()),
                    SizedBox(height: 30,),
                    if(role == 'subadmin' )
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Pезультати команди:', style: TextStyle(fontSize: 18),),
                          ReportsView(funk: ReportService.getReportsByDepartmentsStream(department)),
                        ],
                      ),

                    SizedBox(height: 30,),
                    if(role == 'admin' )
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Pезультати працівників:', style: TextStyle(fontSize: 18),),
                          ReportsView(funk: ReportService.getReportsForAdminStream()),
                        ],
                      ),

                  ],
                );
              }
          )
        ),
      ),
    );
  }
}

class ReportsView extends StatefulWidget {
  const ReportsView({
    super.key, required this.funk,
  });

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

                double persantage = (report.countOfTasks/report.doneTasks)*100;
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
    );
  }
}
