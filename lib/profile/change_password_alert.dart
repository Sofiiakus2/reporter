import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reporter/services/auth_service.dart';

import '../theme.dart';

class ChangePasswordAlert extends StatefulWidget {
  const ChangePasswordAlert({super.key});

  @override
  State<ChangePasswordAlert> createState() => _ChangePasswordAlertState();
}

class _ChangePasswordAlertState extends State<ChangePasswordAlert> {
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: backgroundColor,
      title: Text('Введіть новий пароль',
        style: Theme.of(context).textTheme.labelMedium,),
      content: Container(
        height: 60,
        margin: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextField(
              controller: passwordController,
              style: Theme.of(context).textTheme.labelSmall,
              decoration: InputDecoration(
                labelText: 'Новий пароль',
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
            Navigator.pop(context);
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
            'Відмінити',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),

        ElevatedButton(
          onPressed: () {
            AuthService.changePassword(passwordController.text);
            Navigator.pop(context);
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
