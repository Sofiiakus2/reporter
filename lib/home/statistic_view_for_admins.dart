import 'package:flutter/material.dart';

import 'custom_progress_bar.dart';

class StatisticViewForAdmins extends StatelessWidget {
  const StatisticViewForAdmins({super.key, required this.value1, required this.value2});

  final double value1;
  final double value2;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            CustomProgressBar(value: value1, width: screenSize.width / 2 - 40, height: screenSize.width / 2 - 40,strokeWidth: 12, strokeAlign: 6,),
          ],
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            CustomProgressBar(value: value2, width: screenSize.width / 2 - 40, height: screenSize.width / 2 - 40,strokeWidth: 12, strokeAlign: 6,),
          ],
        ),
      ],
    );
  }
}
