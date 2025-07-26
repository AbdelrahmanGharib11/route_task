import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:selfdep/theme/app_theme.dart';
// import 'package:movieapp/core/LocalizationCubit.dart';
// import 'package:movieapp/theme/apptheme.dart';

enum Theme { light, dark }

class ToggleSwitcher extends StatefulWidget {
  const ToggleSwitcher({super.key});

  @override
  State<ToggleSwitcher> createState() => _ToggleSwitcherState();
}

class _ToggleSwitcherState extends State<ToggleSwitcher> {
  Theme selectedTheme = Theme.light;
  final themeAssets = {
    Theme.light: 'assets/svg/Sun.svg',
    Theme.dark: 'assets/svg/Moon.svg',
  };
  @override
  Widget build(BuildContext context) {
    var screendim = MediaQuery.sizeOf(context);
    return AnimatedToggleSwitch<Theme>.rolling(
      current: selectedTheme,
      values: const [Theme.light, Theme.dark],
      onChanged: (value) {
        setState(() => selectedTheme = value);
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
    );
  }
}
