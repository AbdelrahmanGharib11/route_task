import 'package:flutter/material.dart';

class AppTheme {
  static Color white = const Color(0xffF5F5F5);
  static Color black = const Color(0xff121312);
  static Color babyblue = const Color(0xff004182);

  static ThemeData lighttheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: white,
    colorScheme: ColorScheme.fromSeed(
      seedColor: babyblue,
      brightness: Brightness.light,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        color: babyblue,
        fontSize: 28,
        fontFamily: 'myFonts',
        fontWeight: FontWeight.w700,
      ),
    ),
  );

  static ThemeData darktheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: black,
    colorScheme: ColorScheme.fromSeed(
      seedColor: babyblue,
      brightness: Brightness.dark,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        color: white,
        fontSize: 28,
        fontFamily: 'myFonts',
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}
