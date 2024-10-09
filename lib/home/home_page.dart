import 'dart:async';
import 'package:flutter/material.dart';
import 'package:reporter/home/statistic_view_for_admins.dart';
import 'package:reporter/home/statistic_view_for_user.dart';
import 'package:reporter/services/statistic_service.dart';
import 'package:reporter/today_date_widget/today_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double myTodayResult = 0;
  double myMonthResult = 0;

  double staffTodayResult = 0;
  double staffMonthResult = 0;
  Timer? _timer;
  late String? role;

  Future<void> _loadData() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    role = preferences.getString('role');
  }

  @override
  void initState() {
    _loadData();
    super.initState();
    _updateProgress();
    _startTimer();
  }

  Future<void> _updateProgress() async {
    double progress1 = await StatisticService.countMyTodayProgress();
    double progress2 = await StatisticService.countMyMonthProgress();
    setState(() {
      myTodayResult = progress1;
      myMonthResult = progress2;
    });

    if(role == 'admin'){
      double progress3 = await StatisticService.countAllUsersTodayProgressExceptCurrent();
      double progress4 = await StatisticService.countAllUsersProgressExceptCurrent();

      setState(() {
        staffTodayResult = progress3;
        staffMonthResult = progress4;
      });
    }

    if(role == 'subadmin'){
      double progress3 = await StatisticService.countAllUsersTodayProgressByDepartmentExceptCurrent();
      double progress4 = await StatisticService.countAllUsersProgressByDepartmentExceptCurrent();

      setState(() {
        staffTodayResult = progress3;
        staffMonthResult = progress4;
      });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 20), (timer) {
      _updateProgress();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TodayWidget(),
              Container(
                margin: const EdgeInsets.only(top: 10),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Ваші результати',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black.withOpacity(0.3),
                  ),
                ),
              ),

              if(role == 'user')
                StatisticsForUser(value1: myTodayResult, value2: myMonthResult),

              if(role == 'admin' || role == 'subadmin')
                Column(
                  children: [
                    StatisticViewForAdmins(value1: myTodayResult, value2: myMonthResult),
                    Container(
                      margin: const EdgeInsets.only(top: 50),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Результати працівників',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black.withOpacity(0.3),
                        ),
                      ),
                    ),
                    StatisticViewForAdmins(value1: staffTodayResult, value2: staffMonthResult),
                  ],
                ),


            ],
          ),
        ),
      ),
    );
  }
}
