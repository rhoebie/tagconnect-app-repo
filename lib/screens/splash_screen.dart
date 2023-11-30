import 'dart:convert';
import 'dart:io';

import 'package:TagConnect/animations/fade_animation.dart';
import 'package:TagConnect/configs/network_config.dart';
import 'package:TagConnect/constants/color_constant.dart';
import 'package:TagConnect/constants/provider_constant.dart';
import 'package:TagConnect/models/credential_model.dart';
import 'package:TagConnect/screens/home_screen.dart';
import 'package:TagConnect/screens/login_screen.dart';
import 'package:TagConnect/screens/splash-one_screen.dart';
import 'package:TagConnect/services/user_service.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  late AutoLoginNotifier autoLoginNotifier;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    autoLoginNotifier = Provider.of<AutoLoginNotifier>(context, listen: false);
  }

  Future<void> loadSavedCredentials() async {
    String email = '';
    String pass = '';
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/credentials.txt');

      if (await file.exists()) {
        // Load JSON from the text file
        final jsonCredentials = await file.readAsString();

        // Parse JSON into a CredentialModel instance
        final credentialModel =
            CredentialModel.fromJson(json.decode(jsonCredentials));

        // Set email and password from CredentialModel
        email = credentialModel.email ?? '';
        pass = credentialModel.password ?? '';

        if (autoLoginNotifier.isAutoLogin) {
          await loginUser(email: email, password: pass);
        } else {
          Navigator.of(context)
              .pushReplacement(FadeAnimation(const LoginScreen()));
        }
      } else {
        print('Credentials file does not exist.');
      }
    } catch (e) {
      print('Error loading credentials: $e');
    }
  }

  Future<void> loginUser(
      {required String email, required String password}) async {
    try {
      bool isConnnected = await NetworkService.isConnected();
      if (isConnnected) {
        final authService = UserService();
        final token = await authService.login(email, password);

        if (token != null) {
          Navigator.of(context)
              .pushReplacement(FadeAnimation(const HomeScreen()));
          print('User Token: $token');
        } else {
          print('Error');
        }
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
    } catch (e) {
      print('Error $e');
    }
  }

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
        print('first time open');
        Future.delayed(
          const Duration(seconds: 2),
          () {
            Navigator.of(context)
                .pushReplacement(FadeAnimation(const WelcomeOneScreen()));
          },
        );
      } else {
        loadSavedCredentials();
        print('not first time open');
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
