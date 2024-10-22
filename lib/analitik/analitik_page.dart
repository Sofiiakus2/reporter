import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reporter/analitik/analitik_bar_chart.dart';
import 'package:reporter/analitik/analitik_by_staff/analitik_by_staff.dart';
import 'package:reporter/tasks/day_in_calendar.dart';
import 'package:reporter/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/statistic_service.dart';

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
                            AnalitikBarChart(isWeek: true,  onDateSelected: _updateSelectedDate,),
                            AnalitikBarChart(isWeek: false, onDateSelected: _updateSelectedDate,),
                          ])),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    width: double.infinity,
                    child: Divider(
                      height: 15,
                      thickness: 1,
                      color: dividerColor,
                    ),
                  ),
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


// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:reporter/analitik/reports_view.dart';
// import 'package:reporter/services/user_service.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../services/report_service.dart';
// import '../today_date_widget/today_widget.dart';
//
// class AnalitikPage extends StatefulWidget {
//   const AnalitikPage({super.key});
//
//   @override
//   State<AnalitikPage> createState() => _AnalitikPageState();
// }
//
// class _AnalitikPageState extends State<AnalitikPage> with SingleTickerProviderStateMixin{
//
//   late String? role;
//
//   Future<void> _loadData() async{
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     role = preferences.getString('role');
//
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Container(
//           margin: const EdgeInsets.all(30),
//           child: FutureBuilder<String>(
//               future: UserService().getUserDepartment(),
//               builder: (context, snapshot){
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (snapshot.hasError) {
//                   return const Center(child: Text('Error loading department'));
//                 }
//
//                 final department = snapshot.data ?? '';
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     TodayWidget(),
//                     Text('Ваші результати:', style: TextStyle(fontSize: 18),),
//                     ReportsView(funk: ReportService.getReportsStream(), isMine: true,),
//                     SizedBox(height: 30,),
//                     if(role == 'subadmin' )
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('Pезультати команди:', style: TextStyle(fontSize: 18),),
//                           ReportsView(funk: ReportService.getReportsByDepartmentsStream(department), isMine: false,),
//                         ],
//                       ),
//
//                     SizedBox(height: 30,),
//                     if(role == 'admin' )
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('Pезультати працівників:', style: TextStyle(fontSize: 18),),
//                           ReportsView(funk: ReportService.getReportsForAdminStream(), isMine: false,),
//                         ],
//                       ),
//
//                   ],
//                 );
//               }
//           )
//         ),
//       ),
//     );
//   }
// }
