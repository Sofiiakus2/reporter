import 'package:flutter/material.dart';
import 'package:reporter/theme.dart';

class TaskBlockViewExpanded extends StatefulWidget {
  TaskBlockViewExpanded({
    super.key,
    required this.title,
    required this.isChecked,
    required this.description,
    required this.comment,
    required this.isToday,
  });

  final String title;
  final String description;
  final String comment;
  bool isChecked;
  final bool isToday;

  @override
  State<TaskBlockViewExpanded> createState() => _TaskBlockViewExpandedState();
}

class _TaskBlockViewExpandedState extends State<TaskBlockViewExpanded> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 400),
        width: screenSize.width,
        margin: EdgeInsets.symmetric(horizontal: 15),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          color: Colors.white,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xfff0f0f7),
              Color(0xfff0f1f8),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 3,
              blurRadius: 10,
              offset: Offset(10, 10),
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.8),
              spreadRadius: 0,
              blurRadius: 10,
              offset: Offset(-10, -8),
            ),
          ],
        ),
        height: _isExpanded ? 250 : 80,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.title,
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),
                  ),
                  widget.isChecked
                    ? Icon(Icons.check, color: primaryColor,)
                      : Icon(Icons.close, color: dividerColor,)
                ],
              ),
              if (_isExpanded)
                Container(
                  width: screenSize.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30),
                      Text(
                        'Додаткова інформація:',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Опис: ${widget.description}',
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: _isExpanded ? null : 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Результат : ${widget.comment}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
