import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reporter/home/progress_painter.dart';

import '../services/statistic_service.dart';
import '../theme.dart';
import 'avatar_block.dart';

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
    FirebaseAuth auth = FirebaseAuth.instance;
    User? currentUser = auth.currentUser;
    double progress1 = await StatisticService.countMyProgressForDay(DateTime.now(), currentUser!.uid);
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
        AvatarBlock(),
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
