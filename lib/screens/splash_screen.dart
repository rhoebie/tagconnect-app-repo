import 'package:TagConnect/animations/fade_animation.dart';
import 'package:TagConnect/constants/color_constant.dart';
import 'package:TagConnect/screens/login_screen.dart';
import 'package:TagConnect/screens/splash-one_screen.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkPermissionAndFirstTimeOpen();
  }

  Future<void> _checkPermissionAndFirstTimeOpen() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      bool isFirstTimeOpen = prefs.getBool('firstOpen') ?? false;
      if (!isFirstTimeOpen) {
        Future.delayed(
          const Duration(seconds: 2),
          () {
            Navigator.of(context)
                .pushReplacement(FadeAnimation(const WelcomeOneScreen()));
          },
        );
      } else {
        Future.delayed(
          const Duration(seconds: 2),
          () {
            Navigator.of(context)
                .pushReplacement(FadeAnimation(const LoginScreen()));
          },
        );
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color backgroundColor = theme.scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.location_pin,
                  color: tcRed,
                  size: 50,
                ),
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'PublicSans',
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w700,
                      color: tcViolet,
                    ),
                    children: [
                      TextSpan(
                        text: 'TAG',
                      ),
                      TextSpan(
                        text: 'CONNECT',
                        style: TextStyle(
                          color: tcRed,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 250.w,
                  child: Text(
                    'An efficient incident reporting and analytics system for Taguig City',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PublicSans',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w300,
                      color: tcGray,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                const CircularProgressIndicator(
                  color: tcViolet,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
