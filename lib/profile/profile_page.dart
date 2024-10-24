import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reporter/home/avatar_block.dart';
import 'package:reporter/profile/weekly_personal_statistics.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import '../theme.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: screenSize.width,
        margin: EdgeInsets.only(top: 70),
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
            return Column(
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    AvatarBlock(),
                    Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Text(user.name!,
                      style: Theme.of(context).textTheme.titleLarge,),
                    ),
                  ],
                ),
                SizedBox(height: 15,),
                Text(
                  'Початківець',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Colors.black,
                    shadows: [
                      Shadow(
                        offset: Offset(4.0, 2.0), 
                        blurRadius: 5.0, 
                        color: Colors.grey.withOpacity(0.5), 
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30,),
                WeeklyPersonalStatistics(),
                Container(height: 80,
                width: screenSize.width,
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  padding: EdgeInsets.symmetric(horizontal: 30),
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
                      Text('Винагороди',
                        style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          color: Colors.black,
                          shadows: [
                            Shadow(
                              offset: Offset(4.0, 2.0),
                              blurRadius: 5.0,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ],
                        ),),
                      Icon(Icons.star_border_outlined, size: 34, color: dividerColor,),

                    ],
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    AuthService.leaveSession();
                    Get.offAllNamed('/enter');
                  },
                  child: Container(height: 80,
                    width: screenSize.width,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.symmetric(horizontal: 30),
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
                        Text('Вийти',
                          style: Theme.of(context).textTheme.labelMedium!.copyWith(
                            color: Colors.black,
                            shadows: [
                              Shadow(
                                offset: Offset(4.0, 2.0),
                                blurRadius: 5.0,
                                color: Colors.grey.withOpacity(0.5),
                              ),
                            ],
                          ),),
                        Icon(Icons.exit_to_app_outlined, size: 34, color: dividerColor,),

                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        )

        ),

    );
  }
}

