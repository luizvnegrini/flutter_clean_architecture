import 'dart:io';

import 'package:flutter/material.dart';

ThemeData makeAppTheme() {
  const primaryColor = Color.fromRGBO(255, 122, 9, 1);
  const primaryColorDark = Color.fromRGBO(213, 0, 0, 1);
  const primaryColorLight = Color.fromRGBO(253, 154, 40, 1);

  final buttonTheme = ButtonThemeData(
      colorScheme: const ColorScheme.light(primary: primaryColor),
      buttonColor: primaryColor,
      splashColor: primaryColorLight,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ));

  const textTheme = TextTheme(
    headline1: TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: primaryColorDark,
    ),
  );

  final appBarTheme = AppBarTheme(
      brightness: Platform.isIOS ? Brightness.light : Brightness.dark,
      color: Colors.white,
      // textTheme: GoogleFonts.latoTextTheme(
      //   Theme.of(context).textTheme,
      // ),
      iconTheme: const IconThemeData(
        color: primaryColorLight,
      ));

  const inputDecorationTheme = InputDecorationTheme(
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: primaryColorLight),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: primaryColor),
      ),
      alignLabelWithHint: true);

  return ThemeData(
    primaryColor: primaryColor,
    primaryColorDark: primaryColorDark,
    primaryColorLight: primaryColorLight,
    fontFamily: 'Montserrat',
    accentColor: primaryColor,
    backgroundColor: Colors.white,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textTheme: textTheme,
    appBarTheme: appBarTheme,
    inputDecorationTheme: inputDecorationTheme,
    buttonTheme: buttonTheme,
  );
}
