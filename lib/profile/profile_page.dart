import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:reporter/models/user_model.dart';
import 'package:reporter/profile/admin_funk/manager_settings.dart';
import 'package:reporter/profile/subadmin_funk/worker_settings.dart';
import 'package:reporter/services/auth_service.dart';
import 'package:reporter/services/user_service.dart';

import '../auth/enter/enter_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 30, right: 30, top: 50),
          child: StreamBuilder<UserModel?>(
              stream: UserService().getUserData(),
              builder: (context, snapshot){
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Помилка при отриманні даних'));
                }
                final user = snapshot.data;
                if (user == null) {
                  return Center(child: Text('Користувача не знайдено'));
                }
                nameController.text = user.name!;
                emailController.text = user.email!;
                return Column(
                  children: [
                    const Text(
                      'Профіль',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 30,
                          color: Colors.black),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: 34,
                          child: Icon(Icons.person_rounded, size: 34, color: Colors.white,),
                        ),
                        SizedBox(width: 20,),
                        Container(
                          width: 250,
                          height: 70,
                          margin: EdgeInsets.only(top: 10),
                          child: TextField(
                            controller: nameController,
                            onEditingComplete: (){
                              UserService.updateUserName(nameController.text);
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Ім\'я',
                              hintStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                  width: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                    SizedBox(height: 25,),
                    if(user.role == 'admin')
                      GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ManagerSettings()),
                          );
                        },
                      child: Container(
                        width: screenSize.width,
                        height: 70,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey.withOpacity(0.3)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Налаштування керівників',style: TextStyle(
                              fontSize: 18
                            ),),
                            Icon(Icons.navigate_next, size: 26,)
                          ],
                        ),
                      ),
                    ),
                    if(user.role == 'subadmin')
                      GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => WorkerSettings()),
                          );
                        },
                        child: Container(
                          width: screenSize.width,
                          height: 70,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey.withOpacity(0.3)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Налаштування працівників',style: TextStyle(
                                  fontSize: 18
                              ),),
                              Icon(Icons.navigate_next, size: 26,)
                            ],
                          ),
                        ),
                      ),
                    SizedBox(height: 25,),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: ElevatedButton(
                          onPressed: () {
                            AuthService.leaveSession();
                            Get.offAllNamed('/enter');

                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: Container(
                            margin:
                            const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                            child: const Text(
                              'Вийти',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
          )
        ),
      ),
    );
  }
}
