import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeData> {
  static const String _themeKey = 'is_dark_mode';
  bool _isDarkMode = false;

  ThemeCubit() : super(_lightTheme) {
    _loadTheme();
  }

  bool get isDarkMode => _isDarkMode;

  static final ThemeData _lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xffF5F5F5),
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xff004182),
      brightness: Brightness.light,
    ),
  );

  static final ThemeData _darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xff121312),
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xff004182),
      brightness: Brightness.dark,
    ),
  );

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    emit(_isDarkMode ? _darkTheme : _lightTheme);
    _saveTheme();
  }

  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode = prefs.getBool(_themeKey) ?? false;
      emit(_isDarkMode ? _darkTheme : _lightTheme);
    } catch (e) {
      print('Error loading theme: $e');
    }
  }

  Future<void> _saveTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, _isDarkMode);
    } catch (e) {
      print('Error saving theme: $e');
    }
  }
}
