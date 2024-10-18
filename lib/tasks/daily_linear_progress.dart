import 'package:flutter/material.dart';

import '../theme.dart';

class DayliLinearProgress extends StatelessWidget {
  const DayliLinearProgress({
    super.key,
    required this.progress,
  });

  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Ваші результати за день',
                style: Theme.of(context).textTheme.labelSmall,),
              Text('${(progress*100).toStringAsFixed(0)}%',
                style: Theme.of(context).textTheme.labelSmall,),
            ],
          ),
          SizedBox(height: 20,),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: progress),
            duration: Duration(seconds: 1),
            builder: (context, value, child) {
              return LinearProgressIndicator(
                value: value,
                minHeight: 12,
                backgroundColor: dividerColor,
                color: primaryColor,
                borderRadius: BorderRadius.circular(20),
              );
            },
          ),
        ],
      ),
    );
  }
}


