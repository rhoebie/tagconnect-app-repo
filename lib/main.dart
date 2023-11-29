//import 'package:firebase_core/firebase_core.dart';
import 'package:TagConnect/constants/color_constant.dart';
import 'package:TagConnect/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarColor: tcWhite,
        systemNavigationBarColor: tcWhite,
      ),
    );
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      builder: (context, child) {
        return MaterialApp(
          theme: lightTheme,
          themeMode: ThemeMode.light,
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
