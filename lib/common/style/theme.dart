import 'package:flutter/material.dart';
import 'package:learn_teacher_bloc/common/values/colors.dart';

class AppTheme {
  static const horizontalMargin = 16.0;
  static const radius = 10.0;

  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.primaryBackground,
    backgroundColor: AppColors.primaryBackground,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    primaryColor: AppColors.primaryText,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: AppColors.primaryText,
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(
        color: AppColors.primaryText,
      ),
      titleTextStyle: TextStyle(
        color: AppColors.primaryText,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      toolbarTextStyle: TextStyle(
        color: AppColors.primaryText,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.primaryBackground,
      unselectedLabelStyle: TextStyle(fontSize: 12),
      selectedLabelStyle: TextStyle(fontSize: 12),
      unselectedItemColor: Color(0xffA2A5B9),
      selectedItemColor: AppColors.primaryElement,
    ),
    tabBarTheme: TabBarTheme(
      indicatorSize: TabBarIndicatorSize.label,
      labelColor: AppColors.primaryThirdElementText,
      unselectedLabelColor: AppColors.primaryElement,
    ),
  );
}
