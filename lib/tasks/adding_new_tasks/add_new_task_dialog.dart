import 'package:flutter/material.dart';
import 'package:reporter/services/user_service.dart';
import 'package:reporter/theme.dart';

class AddNewTaskDialog extends StatelessWidget {
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime day = DateTime.now();

  AddNewTaskDialog({super.key, required this.isToday});
  final bool isToday;


  @override
  Widget build(BuildContext context) {
    if(isToday == false){
      day = day.add(Duration(days: 1));
    }
    return AlertDialog(
      backgroundColor: backgroundColor,
      title: Text('Додати нове завдання',
        style: Theme.of(context).textTheme.labelMedium,),
      content: Container(
        height: 130,
        margin: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextField(
              controller: _taskController,
              style: Theme.of(context).textTheme.labelSmall,
              decoration: InputDecoration(
                labelText: 'Назва завдання',
                labelStyle: Theme.of(context).textTheme.labelSmall,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: const BorderSide(),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(
                    color: primaryColor,
                    width: 2.0,
                  ),
                ),
              ),
            ),
            TextField(
              controller: _descriptionController,
              style: Theme.of(context).textTheme.labelSmall,
              decoration: InputDecoration(
                labelText: 'Опис завдання',
                labelStyle: Theme.of(context).textTheme.labelSmall,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: const BorderSide(),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(
                    color: primaryColor,
                    width: 2.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            if (_taskController.text.isNotEmpty && _descriptionController.text.isNotEmpty) {
              UserService.setPlanToDo(_taskController.text, _descriptionController.text, day);
              _taskController.clear();
              _descriptionController.clear();
            }
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(dividerColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
            ),
          ),
          child: Text(
            'Додати ще',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),

        ElevatedButton(
          onPressed: () {
            if (_taskController.text.isNotEmpty && _descriptionController.text.isNotEmpty) {
              UserService.setPlanToDo(_taskController.text, _descriptionController.text, day);
              Navigator.pop(context);
            }
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(primaryColor.withOpacity(0.7)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
            ),
          ),
          child: Text(
            'Зберегти',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

