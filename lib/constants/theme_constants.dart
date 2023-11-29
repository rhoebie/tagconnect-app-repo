import 'package:TagConnect/constants/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ThemeNotifier extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _updateSystemNavigationBarColor(); // Update system navigation bar color
    notifyListeners();
  }

  void _updateSystemNavigationBarColor() {
    final ThemeData currentTheme = _isDarkMode ? darkTheme : lightTheme;
    final Color navigationBarColor = currentTheme.scaffoldBackgroundColor;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: navigationBarColor,
    ));
  }
}

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

final ThemeData taguigTheme = ThemeData(
  platform: TargetPlatform.android,
  scaffoldBackgroundColor: tcWhite,
  textTheme: TextTheme(
    // Display
    displayLarge: TextStyle(
      fontFamily: 'PublicSans',
      fontSize: 32.sp,
      fontWeight: FontWeight.w900,
    ),
    displayMedium: TextStyle(
      fontFamily: 'PublicSans',
      fontSize: 30.sp,
      fontWeight: FontWeight.w700,
    ),
    displaySmall: TextStyle(
      fontFamily: 'PublicSans',
      fontSize: 28.sp,
      fontWeight: FontWeight.w700,
    ),

    // Headline
    headlineLarge: TextStyle(
      fontFamily: 'PublicSans',
      fontSize: 36.sp,
      fontWeight: FontWeight.w900,
    ),
    headlineMedium: TextStyle(
      fontFamily: 'PublicSans',
      fontSize: 26.sp,
      fontWeight: FontWeight.w700,
    ),
    headlineSmall: TextStyle(
      fontFamily: 'PublicSans',
      fontSize: 24.sp,
      fontWeight: FontWeight.w700,
    ),

    // Title
    titleLarge: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 22.sp,
      fontWeight: FontWeight.w400,
    ),
    titleMedium: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 20.sp,
      fontWeight: FontWeight.w400,
    ),
    titleSmall: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 18.sp,
      fontWeight: FontWeight.w400,
    ),

    // Body
    bodyLarge: TextStyle(
      fontFamily: 'PublicSans',
      fontSize: 18.sp,
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'PublicSans',
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
    ),
    bodySmall: TextStyle(
      fontFamily: 'PublicSans',
      fontSize: 12.sp,
      fontWeight: FontWeight.w300,
    ),

    // Label
    labelLarge: TextStyle(
      fontFamily: 'PublicSans',
      fontSize: 16.sp,
      fontWeight: FontWeight.w600,
    ),
    labelMedium: TextStyle(
      fontFamily: 'PublicSans',
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
    ),
    labelSmall: TextStyle(
      fontFamily: 'PublicSans',
      fontSize: 10.sp,
      fontWeight: FontWeight.w200,
    ),
  ),

  // Button
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: tcViolet,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: tcViolet,
      textStyle: TextStyle(
        fontSize: 15,
      ),
    ),
  ),
);
