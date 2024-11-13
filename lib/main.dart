import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:reporter/auth/enter/enter_page.dart';
import 'package:reporter/auth/registration/registration_page.dart';
import 'package:reporter/bottomNatigationBar/bottom_nav_bar.dart';
import 'package:reporter/firebase_api/firebase_api.dart';
import 'package:reporter/splash_screen/splash_screen.dart';
import 'package:reporter/theme.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: 'AIzaSyCQnA-isjKZwTVM-FRtaMZPZzWCATeOmYA',
        appId: '1:308385091696:android:7e938994844f29469324b5',
        messagingSenderId: '308385091696',
        projectId: 'reporter-a8a78'
    )
  );
  //await FirebaseApi().initNotifications();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: lightTheme,
     initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const SplashScreen()),
        GetPage(name: '/enter', page: () => const EnterPage()),
        GetPage(name: '/registration', page: () => const RegistrationPage()),
        GetPage(name: '/bottomNavBar', page: () => BottomNavBar()),
      ],

    );

  }
}
