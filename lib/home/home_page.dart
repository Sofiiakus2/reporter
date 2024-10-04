import 'dart:async';
import 'package:flutter/material.dart';
import 'package:reporter/services/statistic_service.dart';
import 'package:reporter/today_date_widget/today_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double value1 = 0;
  double value2 = 1;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _updateProgress();
    _startTimer();
  }

  Future<void> _updateProgress() async {
    double progress = await StatisticService.countTodayProgress();
    setState(() {
      value1 = progress;
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
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
            crossAxisAlignment: CrossAxisAlignment.center, // Центруємо вміст
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
              Container(
                margin: const EdgeInsets.only(top: 10),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Сьогодні',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.black.withOpacity(0.3),
                  ),
                ),
              ),
              Container(
                width: screenSize.width / 1.2,
                height: screenSize.width / 1.5,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 10),
                          TweenAnimationBuilder(
                            tween: Tween<double>(begin: 0, end: value1),
                            duration: const Duration(seconds: 4),
                            builder: (context, double vale, child) => Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    strokeWidth: 20,
                                    strokeAlign: 8,
                                    strokeCap: StrokeCap.round,
                                    value: vale,
                                    color: Colors.black,
                                    backgroundColor: Colors.white,
                                  ),
                                  Text(
                                    '${(vale * 100).toStringAsFixed(0)}%',
                                    style: TextStyle(
                                      fontSize: 26,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              Container(
                margin: const EdgeInsets.only(top: 10),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Місяць',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.black.withOpacity(0.3),
                  ),
                ),
              ),
              Container(
                width: screenSize.width / 1.2,
                height: screenSize.width / 1.5,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 10),
                          TweenAnimationBuilder(
                            tween: Tween<double>(begin: 0, end: value2),
                            duration: const Duration(seconds: 4),
                            builder: (context, double vale, child) => Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    strokeWidth: 20,
                                    strokeAlign: 8,
                                    strokeCap: StrokeCap.round,
                                    value: vale,
                                    color: Colors.black,
                                    backgroundColor: Colors.white,
                                  ),
                                  Text(
                                    '${(vale * 100).toStringAsFixed(0)}%',
                                    style: TextStyle(
                                      fontSize: 26,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
