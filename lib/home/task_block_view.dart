import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../theme.dart';
import 'check_progress_painter.dart';

class TaskBlockView extends StatefulWidget {
  TaskBlockView({
    super.key,
    required this.title,
    required this.isChecked,
    required this.description,
    required this.isToday,
  });

  final String title;
  final String description;
  bool isChecked;
  final bool isToday;

  @override
  State<TaskBlockView> createState() => _TaskBlockViewState();
}

class _TaskBlockViewState extends State<TaskBlockView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    if (widget.isChecked) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      width: screenSize.width,
      margin: EdgeInsets.symmetric(horizontal: 15),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Зміна padding для динамічної висоти
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Динамічна ширина тексту з переносом
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                SizedBox(height: 5), // Невеликий відступ між текстами
                Text(
                  widget.description,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: null, // Дозволяє переносити текст на новий рядок
                  overflow: TextOverflow.visible, // Текст буде розширювати блок
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                if (widget.isToday) {
                  widget.isChecked = !widget.isChecked;
                  if (widget.isChecked) {
                    _controller.forward();
                  } else {
                    _controller.reverse();
                  }
                  UserService.updateTaskStatus(widget.title, widget.isChecked);
                }
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 30,
                  width: 30,
                  child: CustomPaint(
                    painter: CheckProgressPainter(
                      progress: _progressAnimation.value,
                      isChecked: widget.isChecked,
                    ),
                  ),
                ),
                Icon(
                  Icons.done,
                  size: 18,
                  color: widget.isChecked ? primaryColor : dividerColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
