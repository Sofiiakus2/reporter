import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:reporter/theme.dart';

import '../analitik/analitik_page.dart';
import '../home/home_page.dart';
import '../profile/profile_page.dart';
import '../tasks/adding_new_tasks/add_new_task_dialog.dart';
import '../tasks/tasks_page.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {

  final List<Widget> pages = [
      const HomePage(),
      const TasksPage(),
      const AnalitikPage(),
      const ProfilePage(),
  ];


  final List<IconData> iconList = [
    Icons.home,
    Icons.checklist,
    Icons.featured_play_list_outlined,
    Icons.person_rounded
  ];

  int _bottomNavIndex = 0;
  late FloatingActionButtonLocation buttonLocation = FloatingActionButtonLocation.miniCenterDocked;
  late bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        extendBody: true,
        body: pages[_bottomNavIndex],
        floatingActionButtonLocation: buttonLocation,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(4.0),
          child: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AddNewTaskDialog(isToday: false,);
                },
              );

              setState(() {
                if(isTapped){
                  buttonLocation = FloatingActionButtonLocation.miniCenterDocked;
                }else {
                  buttonLocation = FloatingActionButtonLocation.centerDocked;
                }
                isTapped = !isTapped;
              });
              // Navigator.pushNamed(context, "/addPost");
            },
            elevation: 10,
            backgroundColor: primaryColor,
            shape: const CircleBorder(),
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
        bottomNavigationBar: AnimatedBottomNavigationBar.builder(
          itemCount: iconList.length,
          tabBuilder: (int index, bool isActive){
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(iconList[index],
                  size: 32,
                  color: isActive
                    ? primaryColor
                    : dividerColor)
                ),
              ),

            );
          },
          leftCornerRadius: 34,
          rightCornerRadius: 34,
          height: 80,
          activeIndex: _bottomNavIndex,
          gapLocation: GapLocation.center,
          notchMargin: 8 ,
          elevation: 30,
          notchSmoothness: NotchSmoothness.smoothEdge,
          onTap: (index) => setState(() => _bottomNavIndex = index),
          backgroundColor: Colors.white,

        ),

      );

  }
}








// import 'package:flutter/material.dart';
// import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
// import 'package:reporter/analitik/analitik_page.dart';
// import 'package:reporter/home/home_page.dart';
// import 'package:reporter/profile/profile_page.dart';
// import 'package:reporter/tasks/tasks_page.dart';
//
// class BottomNavBar extends StatefulWidget {
//   const BottomNavBar({Key? key}) : super(key: key);
//
//   @override
//   State<BottomNavBar> createState() => _BottomNavBarState();
// }
//
// class _BottomNavBarState extends State<BottomNavBar> {
//   final PersistentTabController _controller =
//   PersistentTabController(initialIndex: 0);
//
//   List<PersistentBottomNavBarItem> _navBarsItems() {
//     return [
//       PersistentBottomNavBarItem(
//         icon: const Icon(Icons.home),
//         title: 'Головна',
//         activeColorPrimary: Colors.grey,
//         inactiveColorPrimary: Colors.black,
//       ),
//       PersistentBottomNavBarItem(
//         icon: const Icon(Icons.checklist),
//         title: 'Задачі',
//         activeColorPrimary: Colors.grey,
//         inactiveColorPrimary: Colors.black,
//       ),
//       PersistentBottomNavBarItem(
//         icon: const Icon(Icons.featured_play_list_outlined),
//         title: 'Аналітика',
//         activeColorPrimary: Colors.grey,
//         inactiveColorPrimary: Colors.black,
//       ),
//       PersistentBottomNavBarItem(
//         icon: const Icon(Icons.person_rounded),
//         title: 'Профіль',
//         activeColorPrimary: Colors.grey,
//         inactiveColorPrimary: Colors.black,
//       ),
//     ];
//   }
//
//   List<Widget> _buildScreens() {
//     return [
//       const HomePage(),
//       const TasksPage(),
//       const AnalitikPage(),
//       const ProfilePage(),
//     ];
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return PersistentTabView(
//       context,
//       controller: _controller,
//       screens: _buildScreens(),
//       navBarHeight: 65,
//       items: _navBarsItems(),
//       confineToSafeArea: true,
//       backgroundColor: Colors.white,
//       handleAndroidBackButtonPress: true,
//       resizeToAvoidBottomInset: true,
//       stateManagement: true,
//       //hideNavigationBarWhenKeyboardShows: true,
//       decoration: NavBarDecoration(
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(24.0),
//           topRight: Radius.circular(24.0),
//         ),
//         boxShadow: [
//           BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 6.0)
//         ],
//         colorBehindNavBar: Colors.white,
//       ),
//
//       // popAllScreensOnTapOfSelectedTab: true,
//       // itemAnimationProperties: const ItemAnimationProperties(
//       //   duration: Duration(milliseconds: 200),
//       //   curve: Curves.ease,
//       // ),
//       // screenTransitionAnimation: const ScreenTransitionAnimation(
//       //   animateTabTransition: true,
//       //   curve: Curves.ease,
//       //   duration: Duration(milliseconds: 200),
//       // ),
//       navBarStyle: NavBarStyle.style6,
//     );
//   }
// }
