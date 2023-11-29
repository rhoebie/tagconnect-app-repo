import 'package:TagConnect/constants/color_constant.dart';
import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: tcWhite,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: tcViolet,
    onPrimary: tcWhite,
    secondary: tcViolet,
    onSecondary: tcWhite,
    background: tcWhite,
    surface: Colors.white,
    onBackground: tcBlack,
    onSurface: tcBlack,
    error: tcRed,
    onError: tcWhite,
  ),
);

final ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: tcBlack,
  brightness: Brightness.dark,
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: tcViolet,
    onPrimary: tcWhite,
    secondary: tcViolet,
    onSecondary: tcWhite,
    background: tcBlack,
    surface: Colors.black,
    onBackground: tcWhite,
    onSurface: tcWhite,
    error: tcRed,
    onError: tcWhite,
  ),
);
