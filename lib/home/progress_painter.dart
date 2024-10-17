import 'package:flutter/material.dart';

import '../theme.dart';

class ProgressPainter extends CustomPainter {
  final double progress;

  ProgressPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    double strokeWidth = 12.0;

    Paint backgroundPaint = Paint()
      ..color = dividerColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    Paint progressPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);

    double startAngle = 2.2;
    double sweepAngle = 3.14 * 1.6;
    canvas.drawArc(rect, startAngle, sweepAngle, false, backgroundPaint);

    double progressSweepAngle = progress * sweepAngle;
    canvas.drawArc(rect, 1, -progressSweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
