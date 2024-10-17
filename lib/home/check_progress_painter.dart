import 'package:flutter/material.dart';

import '../theme.dart';

class CheckProgressPainter extends CustomPainter {
  final double progress;
  final bool isChecked;

  CheckProgressPainter({required this.progress, required this.isChecked});

  @override
  void paint(Canvas canvas, Size size) {
    double strokeWidth = 4.0;

    Paint backgroundPaint = Paint()
      ..color = dividerColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    Paint progressPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.drawArc(rect, 0, 3.14 * 2, false, backgroundPaint);

    double sweepAngle = progress * 3.14 * 2;
    canvas.drawArc(rect, -3.14 / 2, sweepAngle, false, progressPaint); // Sweeping arc for progress
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
