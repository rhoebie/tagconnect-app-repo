import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:TagConnect/animations/slideLeft_animation.dart';
import 'package:TagConnect/constants/color_constant.dart';
import 'package:TagConnect/screens/login_screen.dart';
import 'package:TagConnect/services/user_service.dart';

final TextEditingController _emailController = TextEditingController();
final TextEditingController txtOne = TextEditingController();
final TextEditingController txtTwo = TextEditingController();
final TextEditingController txtThree = TextEditingController();
final TextEditingController txtFour = TextEditingController();
final TextEditingController txtFive = TextEditingController();
final TextEditingController txtSix = TextEditingController();
final TextEditingController _passwordController = TextEditingController();

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _emailFocus = FocusNode();
  bool isLoading = false;

  Future<void> sendCode(String email) async {
    try {
      final userService = UserService();
      final response = await userService.sendCode(email);
      if (response) {
        Navigator.push(
          context,
          SlideLeftAnimation(
            const VerifyOtpScreen(),
          ),
        );
        print('Code sent');
      } else {
        print('Code sent failed');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color backgroundColor = theme.scaffoldBackgroundColor;
    final Color textColor = theme.colorScheme.onBackground;
    return Scaffold(
      backgroundColor: backgroundColor,
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
              const TextSpan(
                text: 'TAG',
              ),
              const TextSpan(
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'EMAIL OTP',
                    style: TextStyle(
                      fontFamily: 'PublicSans',
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w900,
                      color: textColor,
                    ),
                  ),
                  Text(
                    'This will send you code to your email',
                    style: TextStyle(
                      fontFamily: 'PublicSans',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: tcGray,
                    ),
                  ),
                  const Divider(
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
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 10),
                            labelText: 'Email',
                            labelStyle: TextStyle(
                              fontFamily: 'PublicSans',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                            hintText: 'Enter your Email Address',
                            hintStyle: TextStyle(
                              fontFamily: 'PublicSans',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: tcGray,
                            ),
                            prefixIcon: const Icon(
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
                      ],
                    ),
                  ),
                ],
              ),
              const Icon(
                Icons.email,
                size: 150,
                color: tcViolet,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Back',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: tcViolet,
                          fontFamily: 'PublicSans',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      width: 80.w,
                      height: 50.h,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (mounted) {
                              setState(() {
                                isLoading = true;
                              });
                            }
                            await sendCode(_emailController.text);

                            if (mounted) {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: tcViolet,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 2,
                        ),
                        child: isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    backgroundColor,
                                  ),
                                  strokeWidth: 3,
                                ),
                              )
                            : Icon(
                                Icons.arrow_right_alt_outlined,
                                size: 40,
                                color: backgroundColor,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode fnOne = FocusNode();
  final FocusNode fnTwo = FocusNode();
  final FocusNode fnThree = FocusNode();
  final FocusNode fnFour = FocusNode();
  final FocusNode fnFive = FocusNode();
  final FocusNode fnSix = FocusNode();
  bool isLoading = false;

  Future<void> verifyCode({
    required String code,
  }) async {
    final userService = UserService();
    try {
      final response = await userService.verify(_emailController.text, code);
      if (response) {
        Navigator.push(
          context,
          SlideLeftAnimation(
            const ResetPasswordScreen(),
          ),
        );
        print('code is correct');
      } else {
        print('code is not correct');
      }
    } catch (e) {
      print('Error creating user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color backgroundColor = theme.scaffoldBackgroundColor;
    final Color textColor = theme.colorScheme.onBackground;
    return Scaffold(
      backgroundColor: backgroundColor,
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
              const TextSpan(
                text: 'TAG',
              ),
              const TextSpan(
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'OTP VERIFICATION',
                    style: TextStyle(
                      fontFamily: 'PublicSans',
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w900,
                      color: textColor,
                    ),
                  ),
                  Text(
                    'Provide the 6 digit code',
                    style: TextStyle(
                      fontFamily: 'PublicSans',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: tcGray,
                    ),
                  ),
                  Divider(
                    color: backgroundColor,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 50,
                              child: TextFormField(
                                controller: txtOne,
                                focusNode: fnOne,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(
                                    fontSize: 25,
                                    color: tcViolet,
                                    fontWeight: FontWeight.w700),
                                maxLength: 1,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 14, horizontal: 10),
                                  counterText: '',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: tcGray,
                                      width: 2.w,
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
                                ),
                                onChanged: (value) {
                                  if (value.length == 1) {
                                    FocusScope.of(context).requestFocus(fnTwo);
                                  }
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Empty';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Container(
                              width: 50,
                              child: TextFormField(
                                controller: txtTwo,
                                focusNode: fnTwo,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(
                                    fontSize: 25,
                                    color: tcViolet,
                                    fontWeight: FontWeight.w700),
                                maxLength: 1,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 14, horizontal: 10),
                                  counterText: '',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: tcGray,
                                      width: 2.w,
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
                                ),
                                onChanged: (value) {
                                  if (value.length == 1) {
                                    FocusScope.of(context)
                                        .requestFocus(fnThree);
                                  }
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Empty';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Container(
                              width: 50,
                              child: TextFormField(
                                controller: txtThree,
                                focusNode: fnThree,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(
                                    fontSize: 25,
                                    color: tcViolet,
                                    fontWeight: FontWeight.w700),
                                maxLength: 1,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 14, horizontal: 10),
                                  counterText: '',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: tcGray,
                                      width: 2.w,
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
                                ),
                                onChanged: (value) {
                                  if (value.length == 1) {
                                    FocusScope.of(context).requestFocus(fnFour);
                                  }
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Empty';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Container(
                              width: 50,
                              child: TextFormField(
                                controller: txtFour,
                                focusNode: fnFour,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(
                                    fontSize: 25,
                                    color: tcViolet,
                                    fontWeight: FontWeight.w700),
                                maxLength: 1,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 14, horizontal: 10),
                                  counterText: '',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: tcGray,
                                      width: 2.w,
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
                                ),
                                onChanged: (value) {
                                  if (value.length == 1) {
                                    FocusScope.of(context).requestFocus(fnFive);
                                  }
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Empty';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Container(
                              width: 50,
                              child: TextFormField(
                                controller: txtFive,
                                focusNode: fnFive,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(
                                    fontSize: 25,
                                    color: tcViolet,
                                    fontWeight: FontWeight.w700),
                                maxLength: 1,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 14, horizontal: 10),
                                  counterText: '',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: tcGray,
                                      width: 2.w,
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
                                ),
                                onChanged: (value) {
                                  if (value.length == 1) {
                                    FocusScope.of(context).requestFocus(fnSix);
                                  }
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Empty';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Container(
                              width: 50,
                              child: TextFormField(
                                controller: txtSix,
                                focusNode: fnSix,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(
                                    fontSize: 25,
                                    color: tcViolet,
                                    fontWeight: FontWeight.w700),
                                maxLength: 1,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 14, horizontal: 10),
                                  counterText: '',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: tcGray,
                                      width: 2.w,
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
                                ),
                                onChanged: (value) {
                                  if (value.length == 1) {
                                    FocusScope.of(context).unfocus();
                                  }
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Empty';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Icon(
                Icons.verified_user,
                size: 150,
                color: tcViolet,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Back',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: tcViolet,
                          fontFamily: 'PublicSans',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      width: 80.w,
                      height: 50.h,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (mounted) {
                              setState(() {
                                isLoading = true;
                              });
                            }
                            final printText = txtOne.text +
                                txtTwo.text +
                                txtThree.text +
                                txtFour.text +
                                txtFive.text +
                                txtSix.text;
                            await verifyCode(code: printText);
                            if (mounted) {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: tcViolet,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 2,
                        ),
                        child: isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    backgroundColor,
                                  ),
                                  strokeWidth: 3,
                                ),
                              )
                            : Icon(
                                Icons.arrow_right_alt_outlined,
                                size: 40,
                                color: backgroundColor,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _passwordFocus = FocusNode();
  bool hasUppercase = false;
  bool hasLowercase = false;
  bool hasSpecialChar = false;
  bool hasDigit = false;
  bool is6char = false;
  bool isFailed = false;
  bool isLoading = false;
  bool _passwordVisible = false;

  Future<void> resetPass() async {
    try {
      final userService = UserService();
      final response = await userService.resetPassword(
          _emailController.text, _passwordController.text);
      if (response) {
        clearText();
        Navigator.push(
          context,
          SlideLeftAnimation(
            const LoginScreen(),
          ),
        );
        print('password reset');
      } else {
        print('password reset failed');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void clearText() {
    _emailController.clear();
    txtOne.clear();
    txtTwo.clear();
    txtThree.clear();
    txtFour.clear();
    txtFive.clear();
    txtSix.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color backgroundColor = theme.scaffoldBackgroundColor;
    final Color textColor = theme.colorScheme.onBackground;
    return Scaffold(
      backgroundColor: backgroundColor,
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
              const TextSpan(
                text: 'TAG',
              ),
              const TextSpan(
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'RESET PASSWORD',
                    style: TextStyle(
                      fontFamily: 'PublicSans',
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w900,
                      color: textColor,
                    ),
                  ),
                  Text(
                    'Changing the password of ${_emailController.text}',
                    style: TextStyle(
                      fontFamily: 'PublicSans',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: tcGray,
                    ),
                  ),
                  Divider(
                    color: backgroundColor,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
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
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              fontFamily: 'PublicSans',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                            errorMaxLines: 3,
                            errorStyle: const TextStyle(),
                            hintText: 'Minimum of 6 characters',
                            hintStyle: TextStyle(
                              fontFamily: 'PublicSans',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: tcGray,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 10),
                            prefixIcon: const Icon(
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
                          validator: (value) => validatePassword(value!),
                          onChanged: (value) {
                            if (mounted) {
                              setState(() {
                                hasUppercase = value.contains(RegExp(r'[A-Z]'));
                                hasLowercase = value.contains(RegExp(r'[a-z]'));
                                hasSpecialChar = value.contains(
                                    RegExp(r'[!@#\$%^&*(),.?":{}|<>-]'));
                                hasDigit = value.contains(RegExp(r'[0-9]'));
                                is6char = value.length >= 6;
                              });
                            }
                          },
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Visibility(
                            visible: isFailed,
                            child: Text(
                              'Error changing password',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'PublicSans',
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w300,
                                color: tcRed,
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          color: backgroundColor,
                          height: 5,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  is6char ? Icons.check_circle : Icons.circle,
                                  color: is6char ? tcGreen : tcRed,
                                ),
                                Text(
                                  'Is six character long',
                                  style: TextStyle(
                                    fontFamily: 'PublicSans',
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w300,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  hasSpecialChar
                                      ? Icons.check_circle
                                      : Icons.circle,
                                  color: hasSpecialChar ? tcGreen : tcRed,
                                ),
                                Text(
                                  'Has Special Character',
                                  style: TextStyle(
                                    fontFamily: 'PublicSans',
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w300,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  hasUppercase
                                      ? Icons.check_circle
                                      : Icons.circle,
                                  color: hasUppercase ? tcGreen : tcRed,
                                ),
                                Text(
                                  'Has Uppercase',
                                  style: TextStyle(
                                    fontFamily: 'PublicSans',
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w300,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  hasLowercase
                                      ? Icons.check_circle
                                      : Icons.circle,
                                  color: hasLowercase ? tcGreen : tcRed,
                                ),
                                Text(
                                  'Has Lowercase',
                                  style: TextStyle(
                                    fontFamily: 'PublicSans',
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w300,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  hasDigit ? Icons.check_circle : Icons.circle,
                                  color: hasDigit ? tcGreen : tcRed,
                                ),
                                Text(
                                  'Has Digit',
                                  style: TextStyle(
                                    fontFamily: 'PublicSans',
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w300,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Back',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: tcViolet,
                          fontFamily: 'PublicSans',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      width: 100.w,
                      height: 40.h,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (mounted) {
                              setState(() {
                                isLoading = true;
                              });
                            }

                            await resetPass();
                            if (mounted) {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: tcViolet,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 2,
                        ),
                        child: isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    backgroundColor,
                                  ),
                                  strokeWidth: 3,
                                ),
                              )
                            : Text(
                                'Reset',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'PublicSans',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: backgroundColor,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
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

String? validatePassword(String value) {
  if (value.isEmpty) {
    return 'Please enter a password';
  }

  if (value.length < 6) {
    return 'Password should be at least 6 characters long';
  }

  // Define regular expressions to check for uppercase, lowercase, digit, and special character
  final hasUppercase = RegExp(r'[A-Z]').hasMatch(value);
  final hasLowercase = RegExp(r'[a-z]').hasMatch(value);
  final hasDigit = RegExp(r'[0-9]').hasMatch(value);
  final hasSpecialChar = RegExp(r'[!@#\$%^&*(),.?":{}|<>-]')
      .hasMatch(value); // Include hyphen in special characters

  if (!(hasUppercase && hasLowercase && hasDigit && hasSpecialChar)) {
    return 'Invalid';
  }

  return null; // Return null if the password is valid
}
