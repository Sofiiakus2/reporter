import 'dart:async';

import 'package:flutter/material.dart';
import 'package:reporter/home/progress_painter.dart';

import '../services/statistic_service.dart';
import '../theme.dart';

class MainProgresView extends StatefulWidget {
  const MainProgresView({super.key});


  @override
  State<MainProgresView> createState() => _MainProgresViewState();
}

class _MainProgresViewState extends State<MainProgresView> with SingleTickerProviderStateMixin{
  double progress = 0;
  late AnimationController _controller;
  late Animation<double> _progressAnimation;
  Timer? _timer;

  Future<void> _updateProgress() async {
    double progress1 = await StatisticService.countMyTodayProgress();
    setState(() {
      progress = progress1;
      updateProgress(progress);
    });

  }

    void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _updateProgress();
    });
  }

  @override
  void initState() {
    super.initState();
    _updateProgress();
    _startTimer();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: progress).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void updateProgress(double newProgress) {
    setState(() {
      progress = newProgress;
      _progressAnimation = Tween<double>(begin: _progressAnimation.value, end: newProgress).animate(_controller);
      _controller.reset();
      _controller.forward();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 25,
                spreadRadius: 1,
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 120,
            backgroundColor: thirdColor,
            child: ClipOval(
              child: SizedBox(
                width: 240,
                height: 240,
                child: Image.network('https://e2.hespress.com/wp-content/uploads/2022/01/E_wooELVkAM6Sun-800x600.jpeg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        Container(
          width: 240,
          height: 240,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                primaryColor.withOpacity(0.8),
                Colors.transparent,
              ],
              stops: [0.0, 1.0],
            ),
          ),
        ),
        SizedBox(
          height: 300,
          width: 300,
          child: CustomPaint(
            painter: ProgressPainter(_progressAnimation.value),
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 38,
              backgroundColor: primaryColor,
              child: Center(
                child: Text('${(progress*100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    color: backgroundColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w900
                  ),
                ),
              ),
            ),
          ),
        )

      ],
    );
  }
}
