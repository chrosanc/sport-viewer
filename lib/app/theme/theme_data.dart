import 'package:flutter/material.dart';
import 'package:streamed_mobile/app/theme/text_theme.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
    elevation: 0,
    titleTextStyle: TextStyle(
      fontFamily: 'Inter',
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.white,
      decoration: TextDecoration.none,
    ),
  ),
  scaffoldBackgroundColor: Colors.black,
  textTheme: AppTextTheme.darkTextTheme,
);