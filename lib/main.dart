//import 'package:firebase_core/firebase_core.dart';
import 'package:TagConnect/constants/provider_constant.dart';
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
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider(create: (_) => AutoLoginNotifier()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool _isDataLoaded;

  @override
  void initState() {
    _isDataLoaded = false;
    _loadData();
    super.initState();
  }

  Future<void> _loadData() async {
    await Provider.of<ThemeNotifier>(context, listen: false).loadDarkMode();
    setState(() {
      _isDataLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isDataLoaded) {
      return Container();
    }
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
