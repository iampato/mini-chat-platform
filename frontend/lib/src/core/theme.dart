import 'package:flutter/material.dart';

Map<int, Color> color = {
  50: const Color.fromRGBO(36, 87, 214, .1),
  100: const Color.fromRGBO(36, 87, 214, .2),
  200: const Color.fromRGBO(36, 87, 214, .3),
  300: const Color.fromRGBO(36, 87, 214, .4),
  400: const Color.fromRGBO(36, 87, 214, .5),
  500: const Color.fromRGBO(36, 87, 214, .6),
  600: const Color.fromRGBO(36, 87, 214, .7),
  700: const Color.fromRGBO(36, 87, 214, .8),
  800: const Color.fromRGBO(36, 87, 214, .9),
  900: const Color.fromRGBO(36, 87, 214, 1),
};

MaterialColor majiColor = MaterialColor(0xFF2457D6, color);

Color primaryColor = const Color(0xFF2457D6);

class AppTheme {
  Color? bg; //
  Color? white; //
  Color? surface; //
  Color? primary;
  Color? primaryLight;
  Color? secondary;
  Color? secondaryLight;
  Color? accent1;
  Color? accent2;
  Color? accent3;
  Color? accent4;
  Color? accent5;
  Color? accent6;
  Color? brown;
  Color? mutedBrown;
  Color? grey;
  Color? greyStrong;
  Color? greyWeak;
  Color? error;
  Color? focus;
  Color? txt;
  Color? primaryTxt;
  Color? accentTxt;

  static AppTheme of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? isDarkTheme()
          : isLightTheme();

  static AppTheme by(Brightness brightness) =>
      brightness == Brightness.dark ? isDarkTheme() : isLightTheme();

  static AppTheme isLightTheme() {
    return AppTheme()
      ..bg = Colors.white //const Color(0xFFE5E5E5)
      ..white = Colors.white
      ..primary = const Color(0xFF2457D6)
      ..primaryLight = const Color(0xFF417CFC)
      ..secondary = const Color(0xFF3B5A9A)
      ..secondaryLight = const Color(0xFF1BA8EF)
      ..accent1 = const Color(0xFF267DFF)
      ..accent2 = const Color(0xFFF9B200)
      ..accent3 = const Color(0xFFFE7D43)
      ..accent4 = const Color(0xFF4A669F)
      ..accent5 = const Color(0xFF6AB6D3)
      ..accent6 = Colors.green
      ..brown = const Color(0xFF5C4033)
      ..mutedBrown = const Color(0xFF964B00)
      ..surface = const Color(0xFFFBFBFB)
      ..greyWeak = const Color(0xFFD6D6D6)
      ..grey = const Color(0xff6B6B6B)
      ..greyStrong = const Color(0xff151918)
      ..error = const Color(0xffFF1717)
      ..txt = Colors.black
      ..primaryTxt = const Color(0xFF256186)
      ..accentTxt = Colors.black87;
  }

  static AppTheme isDarkTheme() {
    return AppTheme()
      ..bg = Colors.black
      ..white = Colors.black
      ..primary = const Color(0xFF0a06d4)
      ..primaryLight = const Color(0xFFFFE5E8)
      ..secondary = const Color(0xFF3B5A9A)
      ..secondaryLight = const Color(0xFF1BA8EF)
      ..accent1 = const Color(0xFF267DFF)
      ..accent2 = const Color(0xFFF9B200)
      ..accent3 = const Color(0xFFFE7D43)
      ..accent4 = const Color(0xFF4A669F)
      ..accent5 = const Color(0xFF6AB6D3)
      ..accent6 = Colors.green
      ..brown = const Color(0xFF5C4033)
      ..mutedBrown = const Color(0xFF964B00)
      ..surface = const Color(0xFFf7f7f7)
      ..greyWeak = const Color(0xffD8D8D8)
      ..grey = const Color(0xff515d5a)
      ..greyStrong = const Color(0xff151918)
      ..error = const Color(0xffFF1717)
      ..txt = Colors.black
      ..primaryTxt = const Color(0xFF256186)
      ..accentTxt = Colors.black87;
  }
}
