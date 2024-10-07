import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reporter/auth/enter/enter_page.dart';
import 'package:reporter/auth/registration/registration_page.dart';
import 'package:reporter/bottomNatigationBar/bottom_nav_bar.dart';
import 'package:reporter/splash_screen/splash_screen.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: 'AIzaSyAT8V02yMkfCQVP5mlxVz95K63kfEw8Gbw',
        appId: '1:342745680331:android:c9601aaf80621a1c4fce4e',
        messagingSenderId: '342745680331',
        projectId: 'reporter-app-f0ec6'
    )
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
     initialRoute: '/',
     // home: const BottomNavBar(),
      getPages: [
        GetPage(name: '/', page: () => const SplashScreen()),
        GetPage(name: '/enter', page: () => const EnterPage()),
        GetPage(name: '/registration', page: () => const RegistrationPage()),
        GetPage(name: '/bottomNavBar', page: () => const BottomNavBar()),
      ],

    );

  }
}
