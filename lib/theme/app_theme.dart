import 'package:flutter/material.dart';

class AppTheme {
  static Color white = Color(0xffF5F5F5);
  static Color black = Color(0xff121312);
  static Color babyblue = Color(0xff004182);

  static ThemeData lighttheme = ThemeData(
    scaffoldBackgroundColor: white,
    textTheme: TextTheme(
      displayLarge: TextStyle(
        color: babyblue,
        fontSize: 28,
        fontFamily: 'myFonts',
        fontWeight: FontWeight.w700, // bold font
      ),
    ),
  );
}
