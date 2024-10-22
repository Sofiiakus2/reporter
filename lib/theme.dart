import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


const primaryColor = Color(0xFFFF543e);
const secondaryColor = Color(0xFF2b2ba3);
const thirdColor = Color(0xFFfbb503);
const fourthColor = Color(0xFF000000);
const backgroundColor = Color(0xFFf1f0f6);
const dividerColor = Color(0xFFdedce5);

final themeData = ThemeData();

final lightTheme = ThemeData(
  useMaterial3: true,
  primaryColor: primaryColor,
  secondaryHeaderColor: secondaryColor,
  dividerColor: dividerColor,
  textTheme: textTheme,

  scaffoldBackgroundColor: backgroundColor,
  colorScheme: ColorScheme.fromSeed(
    seedColor: primaryColor,
    brightness: Brightness.dark,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
  //  backgroundColor: dividerColor,
    selectedItemColor: primaryColor,
    unselectedItemColor: Colors.grey,
    showSelectedLabels: false,
    showUnselectedLabels: false,
    elevation: 8,
    type: BottomNavigationBarType.fixed,
  ),
);

final textTheme = TextTheme(
  titleMedium: GoogleFonts.montserrat(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: Colors.black
  ),
  titleLarge: GoogleFonts.montserrat(
      fontSize: 26,
      fontWeight: FontWeight.w700,
      color: backgroundColor
  ),

  labelSmall: GoogleFonts.montserrat(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.black
  ),
  labelMedium: GoogleFonts.montserrat(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Colors.black
  ),
  labelLarge: GoogleFonts.montserrat(
      fontSize: 30,
      fontWeight: FontWeight.w800,
      color: Colors.black
  ),
  bodySmall: GoogleFonts.montserrat(
      fontSize: 16,
      fontWeight: FontWeight.w300,
      color: Colors.black
  ),

);