import 'package:flutter/material.dart';
import 'package:reporter/models/user_model.dart';
import 'package:reporter/services/auth_service.dart';

import '../../theme.dart';


class EnterPage extends StatefulWidget {
  const EnterPage({super.key});

  @override
  State<EnterPage> createState() => _EnterPageState();
}

class _EnterPageState extends State<EnterPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Вхід',
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w600)
                ),
                const SizedBox(
                  height: 60,
                ),
                TextField(
                  controller: emailController,
                  style: Theme.of(context).textTheme.labelSmall,
                  decoration: InputDecoration(
                    labelText: 'Email',
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
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: passwordController,
                  obscureText: !isPasswordVisible,
                  style: Theme.of(context).textTheme.labelSmall,
                  decoration: InputDecoration(
                    labelText: 'Пароль',
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
                const SizedBox(
                  height: 60,
                ),
                ElevatedButton(
                  onPressed: () async {
                    UserModel user = UserModel(
                        email: emailController.text,
                        password: passwordController.text
                    );
                    if(await AuthService.signInWithEmailAndPassword(user)){
                      Navigator.pushNamed(context, "/bottomNavBar");
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
                  child: Container(
                      width: 160,
                      margin: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      child: Center(
                        child: Text(
                          'Увійти',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white),
                        ),
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/registration");
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(dividerColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                  ),
                  child: Container(
                      width: 160,
                      margin: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      child: Center(
                        child: Text(
                          'Реєстрація',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      )),
                ),
              ],
            ),
          )),
    );
  }
}
