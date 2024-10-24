import 'package:flutter/material.dart';
import 'package:reporter/models/user_model.dart';
import 'package:reporter/services/auth_service.dart';

import '../../theme.dart';


class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool isChecked = false;
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 200),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Реєстрація',
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w600)

                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  TextField(
                    controller: usernameController,
                    style: Theme.of(context).textTheme.labelSmall,
                    decoration: InputDecoration(
                      labelText: 'Ім\'я',
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
                    style: Theme.of(context).textTheme.labelSmall,
                    decoration: InputDecoration(
                      labelText: 'Пароль',
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.remove_red_eye_outlined,
                          color: Colors.grey,
                        ),
                        onPressed: () {},
                      ),
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
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Checkbox(
                  //       activeColor: Colors.black,
                  //       value: isChecked,
                  //       onChanged: (bool? value) {
                  //         setState(() {
                  //           isChecked = value!;
                  //         });
                  //       },
                  //     ),
                  //     Text('я директор',
                  //     style: TextStyle(fontSize: 16),)
                  //   ],
                  // ),
                  const SizedBox(
                    height: 60,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      UserModel newUser = UserModel(
                          name: usernameController.text,
                          email: emailController.text,
                          password: passwordController.text,
                          role: isChecked ? 'admin' : 'user'
                      );
                      AuthService.createUser(newUser);
                      Navigator.pushReplacementNamed(context, '/enter');
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
                      margin: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      child: Text(
                        'Зареєструватися',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white),

                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/enter');
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
                            'Увійти',
                            style: Theme.of(context).textTheme.labelSmall,

                          ),
                        )),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
