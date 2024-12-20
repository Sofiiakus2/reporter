import 'package:flutter/material.dart';
import 'package:reporter/services/subadmin_service.dart';

import '../../models/user_model.dart';
import '../../services/user_service.dart';

class WorkerSettings extends StatefulWidget {
  const WorkerSettings({super.key});

  @override
  State<WorkerSettings> createState() => _WorkerSettingsState();
}

class _WorkerSettingsState extends State<WorkerSettings> {
  final UserService userService = UserService();

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
        child: FutureBuilder<String>(
            future: UserService.getUserDepartment(),
            builder: (context, snapshot){
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(child: Text('Error loading department'));
              }

              final department = snapshot.data ?? '';
              print('DEPARTMENT $department');
              return StreamBuilder<List<UserModel>>(
                stream: userService.getAllWorkersStream(department),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text('Error loading users'));
                  }

                  final users = snapshot.data ?? [];

                  for (var user in users) {
                    if (!checkedUsers.containsKey(user.email)) {
                      if(user.department == department){
                        checkedUsers[user.email] = true;
                      }else{
                        checkedUsers[user.email] = false;
                      }

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
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: user.name ?? 'No Name',
                                          style: TextStyle(
                                            fontSize: 22,
                                            // fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        if(checkedUsers[user.email]==true)
                                          TextSpan(
                                            text: ' - ${user.department}',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontStyle: FontStyle.italic,
                                              color: Colors.grey,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  Checkbox(
                                    value: checkedUsers[user.email],
                                    activeColor: Colors.black,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        if (value == true) {
                                          SubadminService.makeNewWorker(user.id!, department);
                                        }else{
                                          SubadminService.deleteWorker(user.id!);
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
              );
            }
        )
      ),
    );
  }
}
