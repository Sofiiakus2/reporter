import 'package:flutter/material.dart';
import 'package:reporter/profile/admin_funk/departments_dialog.dart';
import 'package:reporter/services/admin_service.dart';

import '../../models/user_model.dart';
import '../../services/user_service.dart';

class ManagerSettings extends StatefulWidget {
  const ManagerSettings({super.key});

  @override
  _ManagerSettingsState createState() => _ManagerSettingsState();
}

class _ManagerSettingsState extends State<ManagerSettings> {
  final UserService userService = UserService();

  // Map для збереження стану чекбоксів кожного користувача
  Map<String, bool> checkedUsers = {};

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: StreamBuilder<List<UserModel>>(
          stream: userService.getAllUsersStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Error loading users'));
            }

            final users = snapshot.data ?? [];

            // Переконайтесь, що для кожного користувача створено запис у `checkedUsers`
            for (var user in users) {
              if (!checkedUsers.containsKey(user.email)) {
                checkedUsers[user.email] = false; // Початкове значення чекбокса
              }
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Позначте керівників',
                  style: TextStyle(fontSize: 28),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];

                      return Container(
                        width: screenSize.width,
                        height: 70,
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              user.name ?? 'No Name',
                              style: const TextStyle(fontSize: 22),
                            ),
                            Checkbox(
                              value: checkedUsers[user.email],
                              activeColor: Colors.black,
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return DepartmentsDialog(user: user);
                                      },
                                    );
                                  }else{
                                    AdminService.deleteManager(user.id!);
                                  }
                                  checkedUsers[user.email] = value ?? false;
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

