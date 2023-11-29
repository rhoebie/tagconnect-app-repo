//import 'package:firebase_core/firebase_core.dart';
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

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: statusBarIconBrightness,
      systemNavigationBarIconBrightness: navigationBarIconBrightness,
      statusBarColor: statusBarColor,
      systemNavigationBarColor: navigationBarColor,
    ));

    return ScreenUtilInit(
      designSize: const Size(360, 800),
      builder: (context, child) {
        return MaterialApp(
          theme: lightTheme,
          darkTheme: darkTheme,
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
