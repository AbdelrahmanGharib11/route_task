import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:selfdep/theme/app_theme.dart';
import 'package:selfdep/core/theme/theme_cubit.dart';

enum Theme { light, dark }

class ToggleSwitcherr extends StatefulWidget {
  const ToggleSwitcherr({super.key});

  @override
  State<ToggleSwitcherr> createState() => _ToggleSwitcherrState();
}

class _ToggleSwitcherrState extends State<ToggleSwitcherr> {
  Theme selectedTheme = Theme.light;
  final themeAssets = {
    Theme.light: 'assets/svg/Sun.svg',
    Theme.dark: 'assets/svg/Moon.svg',
  };

  @override
  void initState() {
    super.initState();
    // Initialize selectedTheme based on current theme cubit state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final themeCubit = context.read<ThemeCubit>();
      setState(() {
        selectedTheme = themeCubit.isDarkMode ? Theme.dark : Theme.light;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var screendim = MediaQuery.sizeOf(context);
    bool themeNow;

    return BlocListener<ThemeCubit, ThemeData>(
      listener: (context, state) {
        final themeCubit = context.read<ThemeCubit>();
        setState(() {
          selectedTheme = themeCubit.isDarkMode ? Theme.dark : Theme.light;
        });
      },
      child: AnimatedToggleSwitch<Theme>.rolling(
        current: selectedTheme,
        values: const [Theme.light, Theme.dark],
        onChanged: (value) {
          setState(() => selectedTheme = value);

          final themeCubit = context.read<ThemeCubit>();
          if ((value == Theme.dark && !themeCubit.isDarkMode) ||
              (value == Theme.light && themeCubit.isDarkMode)) {
            themeCubit.toggleTheme();
          }
        },
        iconBuilder: (value, isActive) {
          return SvgPicture.asset(
            themeAssets[value]!,
            width: 32,
            height: 32,
            colorFilter: ColorFilter.mode(
              isActive ? AppTheme.white : AppTheme.babyblue,
              BlendMode.srcIn,
            ),
          );
        },
        indicatorSize: Size(33, 33),
        style: ToggleStyle(
          backgroundColor: Colors.transparent,
          indicatorColor: AppTheme.babyblue,
          indicatorBorderRadius: BorderRadius.circular(30),
          borderColor: AppTheme.babyblue,
          borderRadius: BorderRadius.circular(30),
        ),
        spacing: 10,
        height: screendim.height * 0.043,
      ),
    );
  }
}
