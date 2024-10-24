import 'package:flutter/material.dart';
import 'package:reporter/theme.dart';

class CommentDialog extends StatefulWidget {
  CommentDialog({super.key});

  @override
  State<CommentDialog> createState() => _CommentDialogState();
}

class _CommentDialogState extends State<CommentDialog> {
  TextEditingController textController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Введіть коментар',style: Theme.of(context).textTheme.labelMedium,),
      backgroundColor: backgroundColor,
      content:  TextField(
        controller: textController,
        style: Theme.of(context).textTheme.labelSmall,
        decoration: InputDecoration(
          labelText: 'Коментар',
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
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(null);
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
            'Пропустити',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(textController.text);
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
