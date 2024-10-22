import 'package:flutter/material.dart';
import 'package:flutter_circular_text/circular_text/model.dart';
import 'package:flutter_circular_text/circular_text/widget.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:reporter/home/avatar_block.dart';
import 'package:reporter/home/task_block_view.dart';
import 'package:reporter/services/statistic_service.dart';
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
                    // CircularText(
                    //   position: CircularTextPosition.outside,
                    //   children: [
                    //     TextItem(
                    //       text: Text(
                    //         'Початківець',
                    //         style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.black,),
                    //       ),
                    //       space: 10,
                    //       startAngle: -130,
                    //       startAngleAlignment: StartAngleAlignment.center,
                    //       direction: CircularTextDirection.clockwise,
                    //     ),
                    //   ],
                    // )
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
                FutureBuilder<Map<String, dynamic>>(
                  future: StatisticService.countMyPreviousWeekProgress(),
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return CircularProgressIndicator(color: primaryColor,);
                    }
                    double progress = snapshot.data!['progress'];
                    int countOfDoneTasks = snapshot.data!['countOfDoneTasks'];
                    int countOfTasks = snapshot.data!['countOfTasks'];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 180,
                          height: 200,
                          padding: EdgeInsets.only(top: 25, left: 20),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${(progress*100).toStringAsFixed(0)}%',
                              style: Theme.of(context).textTheme.labelLarge,),
                              Text(
                                'Ваша результативність за попередній тиждень',
                                style: Theme.of(context).textTheme.bodySmall,
                                maxLines: null,
                                overflow: TextOverflow.visible,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 180,
                          height: 200,
                          padding: EdgeInsets.only(top: 25, left: 20),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(countOfDoneTasks.toString(),
                                style: Theme.of(context).textTheme.labelLarge,),
                              Text(
                                'Задач було виконано з $countOfTasks поставлених',
                                style: Theme.of(context).textTheme.bodySmall,
                                maxLines: null,
                                overflow: TextOverflow.visible,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                ),
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



// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:reporter/models/user_model.dart';
// import 'package:reporter/profile/admin_funk/manager_settings.dart';
// import 'package:reporter/profile/subadmin_funk/worker_settings.dart';
// import 'package:reporter/services/auth_service.dart';
// import 'package:reporter/services/user_service.dart';
//
//
// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});
//
//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   TextEditingController nameController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Container(
//           margin: const EdgeInsets.only(left: 30, right: 30, top: 50),
//           child: StreamBuilder<UserModel?>(
//               stream: UserService().getUserData(),
//               builder: (context, snapshot){
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 }
//                 if (snapshot.hasError) {
//                   return Center(child: Text('Помилка при отриманні даних'));
//                 }
//                 final user = snapshot.data;
//                 if (user == null) {
//                   return Center(child: Text('Користувача не знайдено'));
//                 }
//                 nameController.text = user.name!;
//                 emailController.text = user.email!;
//                 return Column(
//                   children: [
//                     const Text(
//                       'Профіль',
//                       style: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           fontSize: 30,
//                           color: Colors.black),
//                     ),
//                     SizedBox(height: 20),
//                     Row(
//                       children: [
//                         CircleAvatar(
//                           backgroundColor: Colors.grey,
//                           radius: 34,
//                           child: Icon(Icons.person_rounded, size: 34, color: Colors.white,),
//                         ),
//                         SizedBox(width: 20,),
//                         Container(
//                           width: 250,
//                           height: 70,
//                           margin: EdgeInsets.only(top: 10),
//                           child: TextField(
//                             controller: nameController,
//                             onEditingComplete: (){
//                               UserService.updateUserName(nameController.text);
//                             },
//                             decoration: InputDecoration(
//                               filled: true,
//                               fillColor: Colors.white,
//                               hintText: 'Ім\'я',
//                               hintStyle: const TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.grey),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10.0),
//                                 borderSide: const BorderSide(
//                                   color: Colors.grey,
//                                   width: 0.5,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//
//                       ],
//                     ),
//                     SizedBox(height: 25,),
//                     if(user.role == 'admin')
//                       GestureDetector(
//                         onTap: (){
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context) => ManagerSettings()),
//                           );
//                         },
//                       child: Container(
//                         width: screenSize.width,
//                         height: 70,
//                         padding: EdgeInsets.symmetric(horizontal: 10),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(20),
//                           color: Colors.grey.withOpacity(0.3)
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text('Налаштування керівників',style: TextStyle(
//                               fontSize: 18
//                             ),),
//                             Icon(Icons.navigate_next, size: 26,)
//                           ],
//                         ),
//                       ),
//                     ),
//                     if(user.role == 'subadmin')
//                       GestureDetector(
//                         onTap: (){
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context) => WorkerSettings()),
//                           );
//                         },
//                         child: Container(
//                           width: screenSize.width,
//                           height: 70,
//                           padding: EdgeInsets.symmetric(horizontal: 10),
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(20),
//                               color: Colors.grey.withOpacity(0.3)
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text('Налаштування працівників',style: TextStyle(
//                                   fontSize: 18
//                               ),),
//                               Icon(Icons.navigate_next, size: 26,)
//                             ],
//                           ),
//                         ),
//                       ),
//                     SizedBox(height: 25,),
//                     Align(
//                       alignment: Alignment.bottomCenter,
//                       child: Padding(
//                         padding: const EdgeInsets.only(bottom: 15.0),
//                         child: ElevatedButton(
//                           onPressed: () {
//                             AuthService.leaveSession();
//                             Get.offAllNamed('/enter');
//
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.black,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8.0),
//                             ),
//                           ),
//                           child: Container(
//                             margin:
//                             const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
//                             child: const Text(
//                               'Вийти',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 18,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 );
//               }
//           )
//         ),
//       ),
//     );
//   }
// }
