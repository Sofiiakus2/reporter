import 'package:flutter/material.dart';

import 'custom_progress_bar.dart';

class StatisticsForUser extends StatelessWidget {
  const StatisticsForUser({
    super.key,
    required this.value1,
    required this.value2,
  });

  final double value1;
  final double value2;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Column(
      children: [

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
        CustomProgressBar(value: value1, width: screenSize.width / 1.2, height: screenSize.width / 1.5,strokeWidth: 20, strokeAlign: 8,),
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
        CustomProgressBar(value: value2, width: screenSize.width / 1.2, height: screenSize.width / 1.5,strokeWidth: 20, strokeAlign: 8,),
      ],
    );
  }
}
