import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:reporter/analitik/analitik_page.dart';
import 'package:reporter/home/home_page.dart';
import 'package:reporter/profile/profile_page.dart';
import 'package:reporter/tasks/tasks_page.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final PersistentTabController _controller =
  PersistentTabController(initialIndex: 0);

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: 'Головна',
        activeColorPrimary: Colors.grey,
        inactiveColorPrimary: Colors.black,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.checklist),
        title: 'Задачі',
        activeColorPrimary: Colors.grey,
        inactiveColorPrimary: Colors.black,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.featured_play_list_outlined),
        title: 'Аналітика',
        activeColorPrimary: Colors.grey,
        inactiveColorPrimary: Colors.black,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.person_rounded),
        title: 'Профіль',
        activeColorPrimary: Colors.grey,
        inactiveColorPrimary: Colors.black,
      ),
    ];
  }

  List<Widget> _buildScreens() {
    return [
      const HomePage(),
      const TasksPage(),
      const AnalitikPage(),
      const ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      navBarHeight: 65,
      items: _navBarsItems(),
      confineToSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      //hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 6.0)
        ],
        colorBehindNavBar: Colors.white,
      ),

      // popAllScreensOnTapOfSelectedTab: true,
      // itemAnimationProperties: const ItemAnimationProperties(
      //   duration: Duration(milliseconds: 200),
      //   curve: Curves.ease,
      // ),
      // screenTransitionAnimation: const ScreenTransitionAnimation(
      //   animateTabTransition: true,
      //   curve: Curves.ease,
      //   duration: Duration(milliseconds: 200),
      // ),
      navBarStyle: NavBarStyle.style6,
    );
  }
}
