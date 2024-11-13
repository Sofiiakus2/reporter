import 'package:flutter/material.dart';

import '../theme.dart';


class AvatarBlock extends StatelessWidget {
  const AvatarBlock({
    super.key,
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                child: Image.asset(
                  'assets/images/$id.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/defaultImage.jpeg',
                      fit: BoxFit.cover,
                    );
                  },
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
      ],
    );
  }
}
