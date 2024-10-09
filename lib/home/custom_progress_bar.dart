
import 'package:flutter/material.dart';

class CustomProgressBar extends StatelessWidget {
  const CustomProgressBar({
    super.key,
    required this.value, required this.width, required this.height, required this.strokeWidth, required this.strokeAlign,
  });

  final double value;
  final double width;
  final double height;
  final double strokeWidth;
  final double strokeAlign;


  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Container(
      width: width,
      height: height,
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
                  tween: Tween<double>(begin: 0, end: value),
                  duration: const Duration(seconds: 4),
                  builder: (context, double vale, child) => Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          strokeWidth: strokeWidth,
                          strokeAlign: strokeAlign,
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
    );
  }
}
