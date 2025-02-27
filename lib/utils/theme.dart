import 'package:flutter/material.dart';
import 'package:hosco_shop_2/utils/constants.dart';

class AppTheme {
  AppTheme._();
  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff2F98F5)),
    useMaterial3: true,
    appBarTheme: AppBarTheme(
        backgroundColor: Color(0xff2F98F5),
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 21
        ),
        centerTitle: true
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shape: RoundedRectangleBorder(side: BorderSide(color: primaryColor, width: 1), borderRadius: BorderRadius.circular(4)),
        backgroundColor: primaryColor,
        disabledBackgroundColor: Colors.grey,
        foregroundColor: Colors.white,
      )
    )
  );
}