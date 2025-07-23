import 'package:chat_app/core/theme/colors.dart';
import 'package:flutter/material.dart';

class Pallete {
  static ThemeData get lightTheme => ThemeData(
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: Colors.transparent,
    ),
    scaffoldBackgroundColor: whiteColor,
    cardColor: blackColor,
    primaryColor: primaryColor,
    useMaterial3: true,
    fontFamily: 'Encode Sans',
    inputDecorationTheme: InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: blackColor),
      ),
    ),
  );

  static ThemeData get darkTheme => ThemeData(
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: Colors.transparent,
    ),
    brightness: Brightness.dark,
    scaffoldBackgroundColor: blackColor,
    cardColor: whiteColor,
    primaryColor: primaryColor,
    useMaterial3: true,
    fontFamily: 'Encode Sans',
    inputDecorationTheme: InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: whiteColor),
      ),
    ),
    snackBarTheme: SnackBarThemeData(behavior: SnackBarBehavior.floating),
  );
}
