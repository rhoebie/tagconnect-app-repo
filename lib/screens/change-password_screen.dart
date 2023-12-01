import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:TagConnect/constants/color_constant.dart';
import 'package:TagConnect/services/user_service.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  final FocusNode _oldPasswordFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPassFocus = FocusNode();
  bool isEnabled = false;
  bool hasUppercase = false;
  bool hasLowercase = false;
  bool hasSpecialChar = false;
  bool hasDigit = false;
  bool is6char = false;
  bool isLoading = false;
  bool _passwordVisible = false;
  bool _oldPasswordVisible = false;
  ButtonState stateOnlyText = ButtonState.idle;
  ButtonState stateTextWithIcon = ButtonState.idle;

  Future<bool> changePassword(String oldPw, newPw, confPw) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final userService = UserService();
      final response = await userService.changePw(oldPw, newPw, confPw);

      if (response) {
        await prefs.remove('userPassword');
        await prefs.setString('userPassword', _passwordController.text);
        return true;
      }
    } catch (e) {
      print('Error Updating user: $e');
      throw e;
    }
    return false;
  }

  void clearText() {
    if (mounted) {
      setState(() {
        _oldPasswordController.clear();
        _passwordController.clear();
        _confirmPassController.clear();
        isEnabled = false;
        hasUppercase = false;
        hasLowercase = false;
        hasSpecialChar = false;
        hasDigit = false;
        is6char = false;
      });
    }
  }

  void onPressedIconWithText({
    required String oldPw,
    required String newPw,
    required String confPw,
  }) {
    switch (stateTextWithIcon) {
      case ButtonState.idle:
        stateTextWithIcon = ButtonState.loading;
        Future.delayed(
          Duration(seconds: 1),
          () async {
            bool isSent = await changePassword(oldPw, newPw, confPw);
            if (mounted) {
              setState(
                () {
                  stateTextWithIcon =
                      isSent ? ButtonState.success : ButtonState.fail;
                },
              );
            }
            if (isSent) {
              Future.delayed(
                Duration(seconds: 1),
                () async {
                  clearText();
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

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color backgroundColor = theme.scaffoldBackgroundColor;
    final Color textColor = theme.colorScheme.onBackground;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        leading: CloseButton(),
        iconTheme: IconThemeData(color: textColor),
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          'CHANGE PASSWORD',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor,
            fontFamily: 'Roboto',
            fontSize: 20.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        controller: _oldPasswordController,
                        focusNode: _oldPasswordFocus,
                        obscureText: !_oldPasswordVisible,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: textColor,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Old Password',
                          labelStyle: TextStyle(
                            fontFamily: 'PublicSans',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          errorMaxLines: 2,
                          prefixIcon: Icon(
                            Icons.lock,
                            size: 20,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              if (mounted) {
                                setState(() {
                                  _oldPasswordVisible = !_oldPasswordVisible;
                                });
                              }
                            },
                            icon: Icon(
                              _oldPasswordVisible
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
                      Divider(
                        color: backgroundColor,
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
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            fontFamily: 'PublicSans',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          errorMaxLines: 2,
                          hintText: 'Minimum of 6 characters',
                          hintStyle: TextStyle(
                            fontFamily: 'PublicSans',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: tcGray,
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
                                  print(_passwordVisible);
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
                      Divider(
                        color: backgroundColor,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        controller: _confirmPassController,
                        focusNode: _confirmPassFocus,
                        obscureText: true,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: textColor,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Password cannot be empty';
                          } else if (value != _passwordController.text) {
                            return 'Password do not match';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          labelStyle: TextStyle(
                            fontFamily: 'PublicSans',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          errorMaxLines: 2,
                          hintText: 'Minimum of 8 characters',
                          hintStyle: TextStyle(
                            fontFamily: 'PublicSans',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: tcGray,
                          ),
                          prefixIcon: Icon(
                            Icons.lock,
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
                        color: backgroundColor,
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
                Divider(
                  color: backgroundColor,
                ),
                ProgressButton.icon(
                    iconedButtons: {
                      ButtonState.idle: IconedButton(
                          text: 'Change Password',
                          icon: Icon(Icons.change_circle, color: Colors.white),
                          color: tcViolet),
                      ButtonState.loading:
                          IconedButton(text: 'Loading', color: tcViolet),
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
                            oldPw: _oldPasswordController.text,
                            newPw: _passwordController.text,
                            confPw: _confirmPassController.text);
                      }
                    },
                    state: stateTextWithIcon),
              ],
            ),
          ),
        ),
      ),
    );
  }
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
    return 'Password should contain at least one uppercase, one lowercase, one number, and one special character (including hyphen).';
  }

  return null; // Return null if the password is valid
}
