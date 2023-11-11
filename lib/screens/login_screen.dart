import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taguigconnect/animations/fade_animation.dart';
import 'package:taguigconnect/animations/slideLeft_animation.dart';
import 'package:taguigconnect/configs/network_config.dart';
import 'package:taguigconnect/constants/color_constant.dart';
import 'package:taguigconnect/screens/forgot-password_screen.dart';
import 'package:taguigconnect/screens/home_screen.dart';
import 'package:taguigconnect/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taguigconnect/services/user_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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

  Future<bool> loginUser(
      {required String email, required String password}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isConnnected = await NetworkService.isConnected();
    await prefs.remove('barangayData');
    if (isConnnected) {
      final authService = UserService();
      final token = await authService.login(email, password);

      if (token != null) {
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
            setState(
              () {
                stateTextWithIcon =
                    isLogin ? ButtonState.success : ButtonState.fail;
              },
            );
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
    setState(
      () {
        stateTextWithIcon = stateTextWithIcon;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tcWhite,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: tcWhite,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'TCONNECT',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: tcViolet,
                fontFamily: 'Roboto',
                fontSize: 20.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
            const Icon(
              Icons.location_pin,
              color: tcRed,
              size: 24,
            )
          ],
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
                        color: tcBlack,
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
                              color: tcBlack,
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
                                color: tcBlack,
                              ),
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 16),
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
                                  color: tcBlack,
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
                              color: tcBlack,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Password cannot be empty';
                              } else if (value.length < 6) {
                                return 'Password should atleast 6 characters or more';
                              }
                              return null; // Return null if the input is valid
                            },
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                fontFamily: 'PublicSans',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: tcBlack,
                              ),
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 16),
                              prefixIcon: Icon(
                                Icons.lock,
                                size: 20,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                    print(_passwordVisible);
                                  });
                                },
                                icon: Icon(
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: tcBlack,
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
                                  color: tcBlack,
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
                            mainAxisAlignment: MainAxisAlignment.end,
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
                                    fontFamily: 'PublicSans',
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: tcViolet,
                                  ),
                                ),
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
                      color: tcBlack,
                      fontFamily: 'Roboto',
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
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
