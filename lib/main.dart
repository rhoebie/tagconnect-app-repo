//import 'package:firebase_core/firebase_core.dart';
import 'package:TagConnect/constants/color_constant.dart';
import 'package:TagConnect/constants/theme_constants.dart';
import 'package:TagConnect/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final ThemeData currentTheme =
        themeNotifier.isDarkMode ? darkTheme : lightTheme;
    final Color statusBarColor = currentTheme.scaffoldBackgroundColor;
    final Color navigationBarColor = currentTheme.scaffoldBackgroundColor;
    final Brightness statusBarIconBrightness =
        currentTheme.brightness != Brightness.light
            ? Brightness.light
            : Brightness.dark;
    final Brightness navigationBarIconBrightness =
        currentTheme.brightness != Brightness.light
            ? Brightness.light
            : Brightness.dark;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarIconBrightness: statusBarIconBrightness,
        systemNavigationBarIconBrightness: navigationBarIconBrightness,
        statusBarColor: statusBarColor,
        systemNavigationBarColor: navigationBarColor,
      ),
    );
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      builder: (context, child) {
        return MaterialApp(
          theme: currentTheme,
          themeMode:
              themeNotifier.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          debugShowCheckedModeBanner: false,
          title: 'System',
          home: const SplashScreen(),
        );
      },
    );
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
