import 'dart:convert';
import 'dart:io';

import 'package:TagConnect/configs/request_service.dart';
import 'package:TagConnect/constants/provider_constant.dart';
import 'package:TagConnect/models/credential_model.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:TagConnect/animations/fade_animation.dart';
import 'package:TagConnect/animations/slideLeft_animation.dart';
import 'package:TagConnect/configs/network_config.dart';
import 'package:TagConnect/constants/color_constant.dart';
import 'package:TagConnect/screens/forgot-password_screen.dart';
import 'package:TagConnect/screens/home_screen.dart';
import 'package:TagConnect/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:TagConnect/services/user_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  ButtonState stateOnlyText = ButtonState.idle;
  ButtonState stateTextWithIcon = ButtonState.idle;
  bool _passwordVisible = false;
  bool isFailed = false;
  bool isLoading = false;
  bool rememberMe = false;
  late AutoLoginNotifier autoLoginNotifier;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    autoLoginNotifier = Provider.of<AutoLoginNotifier>(context, listen: false);
    loadSavedCredentials();
  }

  Future<void> saveCredentials() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    // Create a CredentialModel instance
    final credentialModel = CredentialModel(email: email, password: password);

    // Convert CredentialModel to JSON
    final jsonCredentials = json.encode(credentialModel.toJson());

    // Save JSON to a text file
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/credentials.txt');
    await file.writeAsString(jsonCredentials);
    print('Save');
  }

  Future<void> loadSavedCredentials() async {
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
        _emailController.text = credentialModel.email ?? '';
        _passwordController.text = credentialModel.password ?? '';
        if (autoLoginNotifier.isAutoLogin) {
          Future.delayed(
            Duration(seconds: 1),
            () async {
              onPressedIconWithText(
                  email: _emailController.text,
                  password: _passwordController.text);
            },
          );
        }
      } else {
        print('Credentials file does not exist.');
      }
    } catch (e) {
      print('Error loading credentials: $e');
    }
  }

  Future<bool> loginUser(
      {required String email, required String password}) async {
    try {
      bool isConnnected = await NetworkService.isConnected();
      if (isConnnected) {
        final authService = UserService();
        final token = await authService.login(email, password);

        if (token != null) {
          if (rememberMe) {
            saveCredentials();
          }
          print('User Token: $token');
          _emailController.clear();
          _passwordController.clear();
          return true;
        } else {
          return false;
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
        return false;
      }
    } catch (e) {
      print('Error $e');
    }
    return false;
  }

  void onPressedIconWithText(
      {required String email, required String password}) {
    switch (stateTextWithIcon) {
      case ButtonState.idle:
        stateTextWithIcon = ButtonState.loading;
        Future.delayed(
          Duration(seconds: 1),
          () async {
            bool isLogin = await loginUser(email: email, password: password);
            if (mounted) {
              setState(
                () {
                  stateTextWithIcon =
                      isLogin ? ButtonState.success : ButtonState.fail;
                },
              );
            }

            if (isLogin) {
              Future.delayed(
                Duration(seconds: 1),
                () async {
                  Navigator.pushAndRemoveUntil(
                    context,
                    FadeAnimation(HomeScreen()),
                    (route) => false,
                  );
                },
              );
            }
          },
        );
        break;
      case ButtonState.loading:
        break;
      case ButtonState.success:
        stateTextWithIcon = ButtonState.idle;
        break;
      case ButtonState.fail:
        stateTextWithIcon = ButtonState.idle;
        break;
    }
    if (mounted) {
      setState(
        () {
          stateTextWithIcon = stateTextWithIcon;
        },
      );
    }
  }

  Future<void> checkPermission() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      bool checkPermission =
          await RequestService.checkAllPermission(androidInfo);

      await prefs.setBool('firstCheck', true);
      if (checkPermission) {
        print('Permission Granted');
      } else {
        print('Permission not granted');
      }
    } catch (e) {
      print('Error $e');
    }
  }

  Future<void> promptUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      bool isFirstTimeOpen = prefs.getBool('firstCheck') ?? false;
      if (!isFirstTimeOpen) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Permission'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('For the best experience, we need these permissions:'),
                  SizedBox(height: 10),
                  Text('- Camera'),
                  Text('- Gallery'),
                  Text('- Storage'),
                  Text('- Location'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text('Ok'),
                ),
              ],
            );
          },
        ).then((value) {
          if (value != null && value) {
            checkPermission();
            print('User pressed "Ok"');
          }
        });
      }
    } catch (e) {
      print('Error $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    promptUser();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color backgroundColor = theme.scaffoldBackgroundColor;
    final Color textColor = theme.colorScheme.onBackground;

    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: RichText(
          textAlign: TextAlign.start,
          text: TextSpan(
            style: TextStyle(
              fontFamily: 'PublicSans',
              fontSize: 20.sp,
              fontWeight: FontWeight.w900,
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
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'WELCOME',
                      style: TextStyle(
                        fontFamily: 'PublicSans',
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w900,
                        color: textColor,
                      ),
                    ),
                    Text(
                      'Sign in to continue.',
                      style: TextStyle(
                        fontFamily: 'PublicSans',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: tcGray,
                      ),
                    ),
                    Divider(
                      color: Colors.transparent,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: _emailController,
                            focusNode: _emailFocus,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: textColor,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an email address.';
                              } else if (!isValidEmail(value)) {
                                return 'Please enter a valid email address.';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(
                                fontFamily: 'PublicSans',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: textColor,
                              ),
                              prefixIcon: Icon(
                                Icons.email,
                                size: 20,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1.w,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: textColor,
                                  width: 1.w,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: tcViolet,
                                  width: 2.w,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: tcRed,
                                  width: 2.w,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: tcGray,
                                  width: 2.w,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.transparent,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.visiblePassword,
                            controller: _passwordController,
                            focusNode: _passwordFocus,
                            obscureText: !_passwordVisible,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: textColor,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Password cannot be empty';
                              } else if (value.length < 6) {
                                return 'Password should atleast 6 characters or more';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                fontFamily: 'PublicSans',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: textColor,
                              ),
                              prefixIcon: Icon(
                                Icons.lock,
                                size: 20,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  if (mounted) {
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  }
                                },
                                icon: Icon(
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: textColor,
                                  size: 20,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1.w,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: textColor,
                                  width: 1.w,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: tcViolet,
                                  width: 2.w,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: tcRed,
                                  width: 2.w,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: tcGray,
                                  width: 2.w,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Checkbox(
                                    value: rememberMe,
                                    onChanged: (value) {
                                      if (mounted) {
                                        setState(() {
                                          rememberMe = value!;
                                        });
                                      }
                                    },
                                  ),
                                  Text('Remember Me'),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        SlideLeftAnimation(
                                          const ForgotPasswordScreen(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Forgot your password?',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w400,
                                        color: tcViolet,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.transparent,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ProgressButton.icon(
                            iconedButtons: {
                              ButtonState.idle: IconedButton(
                                  text: 'Login',
                                  icon: Icon(Icons.login, color: Colors.white),
                                  color: tcViolet),
                              ButtonState.loading: IconedButton(
                                  text: 'Loading', color: tcViolet),
                              ButtonState.fail: IconedButton(
                                  text: 'Failed',
                                  icon: Icon(Icons.cancel, color: Colors.white),
                                  color: Colors.red.shade300),
                              ButtonState.success: IconedButton(
                                  text: 'Success',
                                  icon: Icon(
                                    Icons.check_circle,
                                    color: Colors.white,
                                  ),
                                  color: Colors.green.shade400)
                            },
                            onPressed: () async {
                              if (_formKey.currentState != null &&
                                  _formKey.currentState!.validate()) {
                                onPressedIconWithText(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                );
                              }
                            },
                            state: stateTextWithIcon),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Dont have an account?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: textColor,
                      fontFamily: 'Roboto',
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      //promptUser();
                      Navigator.push(
                        context,
                        SlideLeftAnimation(
                          const RegisterScreen(),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: tcViolet,
                      textStyle: TextStyle(
                        fontFamily: 'PublicSans',
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: Text('Sign up'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

bool isValidEmail(String email) {
  final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
  return emailRegex.hasMatch(email);
}
