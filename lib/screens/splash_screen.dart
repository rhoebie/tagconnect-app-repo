import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taguigconnect/animations/fade_animation.dart';
import 'package:taguigconnect/configs/network_config.dart';
import 'package:taguigconnect/configs/request_service.dart';
import 'package:taguigconnect/constants/color_constant.dart';
import 'package:taguigconnect/screens/login_screen.dart';
import 'package:taguigconnect/screens/one_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

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
    _checkInternet();
  }

  Future<void> _checkInternet() async {
    bool isConnnected = await NetworkService.isConnected();

    if (isConnnected) {
      _checkPermissionAndFirstTimeOpen();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('No Internet'),
          content: const Text('Check your internet connection in settings'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _checkPermissionAndFirstTimeOpen() async {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTimeOpen = prefs.getBool('firstOpen') ?? true;
    print(isFirstTimeOpen);
    try {
      if (isFirstTimeOpen) {
        bool checkPermission =
            await RequestService.checkAllPermission(androidInfo);

        if (checkPermission) {
          print('Permission Granted');
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
                  .pushReplacement(FadeAnimation(const WelcomeOneScreen()));
            },
          );
        }
      } else {
        print('Already Opened');
        Future.delayed(
          const Duration(seconds: 2),
          () {
            Navigator.of(context)
                .pushReplacement(FadeAnimation(const LoginScreen()));
          },
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tcWhite,
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
                Text(
                  'TaguigConnect',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'PublicSans',
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w700,
                    color: tcViolet,
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
