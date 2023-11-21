import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:path_provider/path_provider.dart';
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

    try {
      // Check if the firstOpenApplication.txt file exists
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      File file = File('${documentsDirectory.path}/firstOpenApplication.txt');

      bool hasStoragePermission =
          await RequestService.storagePermission(androidInfo);

      if (!hasStoragePermission) {
        // If storage permission is not granted, request it
        bool storagePermissionGranted =
            await RequestService.storagePermission(androidInfo);

        if (!storagePermissionGranted) {
          // Handle if storage permission is not granted
          print('Storage permission not granted');
          return;
        }
      }

      bool isFirstTimeOpen = !file.existsSync();

      if (isFirstTimeOpen) {
        bool checkPermission =
            await RequestService.checkAllPermission(androidInfo);

        if (checkPermission) {
          print('Permission Granted');

          // Create the firstOpenApplication.txt file
          file.writeAsStringSync('First Open');

          Future.delayed(
            const Duration(seconds: 2),
            () {
              Navigator.of(context)
                  .pushReplacement(FadeAnimation(const WelcomeOneScreen()));
            },
          );
        } else {
          // Handle if permissions are not granted
          print('Permission not granted');
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
      print(e);
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
