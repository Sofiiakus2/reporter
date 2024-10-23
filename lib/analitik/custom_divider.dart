import 'package:flutter/material.dart';

import '../theme.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      width: double.infinity,
      child: Divider(
        height: 15,
        thickness: 1,
        color: dividerColor,
      ),
    );
  }
}
