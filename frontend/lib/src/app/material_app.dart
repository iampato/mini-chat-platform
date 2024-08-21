import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/src/app/router.dart';
import 'package:frontend/src/core/styles.dart';
import 'package:frontend/src/core/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 640),
      child: MaterialApp.router(
        title: 'Maji safi app',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: false,
          primarySwatch: majiColor,
          brightness: getTheme(0),
          fontFamily: TextStyles.nunitoSans().fontFamily,
          appBarTheme: AppBarTheme(
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
              fontSize: 18,
              fontFamily: TextStyles.nunitoSans().fontFamily,
              fontWeight: FontWeight.w600,
            ),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: AppTheme.by(getTheme(0)).primary,
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor:
                getTheme(0) == Brightness.dark ? Colors.black : Colors.white,
          ),
          scaffoldBackgroundColor: getTheme(0) == Brightness.dark
              ? null
              : AppTheme.by(getTheme(0)).bg,
        ),
        themeMode: ThemeMode.system,
        routeInformationProvider: router.routeInformationProvider,
        routeInformationParser: router.routeInformationParser,
        routerDelegate: router.routerDelegate,
        builder: (context, child) {
          return ScrollConfiguration(
            behavior: MyBehavior(),
            child: child!,
          );
        },
      ),
      builder: (context, child) {
        return child!;
      },
    );
  }

  Brightness getTheme(int value) {
    if (value == 0) {
      return Brightness.light;
    } else if (value == 1) {
      return Brightness.dark;
    } else {
      return Brightness.light;
    }
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
