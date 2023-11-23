import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  Future<void> changePassword(String oldPw, newPw, confPw) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final userService = UserService();
      final response = await userService.changePw(oldPw, newPw, confPw);

      if (response) {
        await prefs.remove('userPassword');
        clearText();
        print('Success');
        await prefs.setString('userPassword', _passwordController.text);
      }
    } catch (e) {
      print('Error Updating user: $e');
      throw e;
    }
  }

  void clearText() {
    _oldPasswordController.clear();
    _passwordController.clear();
    _confirmPassController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tcWhite,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: tcBlack),
        backgroundColor: tcWhite,
        elevation: 0,
        title: Text(
          'CHANGE PASSWORD',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: tcBlack,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      controller: _oldPasswordController,
                      focusNode: _oldPasswordFocus,
                      obscureText: false,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: tcBlack,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Old Password',
                        labelStyle: TextStyle(
                          fontFamily: 'PublicSans',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        errorMaxLines: 2,
                        contentPadding: EdgeInsets.symmetric(vertical: 16),
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
                      validator: (value) => validatePassword(value!),
                    ),
                    Divider(
                      color: tcWhite,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      controller: _passwordController,
                      focusNode: _passwordFocus,
                      obscureText: false,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: tcBlack,
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
                        contentPadding: EdgeInsets.symmetric(vertical: 16),
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
                      validator: (value) => validatePassword(value!),
                      onChanged: (value) {
                        setState(() {
                          hasUppercase = value.contains(RegExp(r'[A-Z]'));
                          hasLowercase = value.contains(RegExp(r'[a-z]'));
                          hasSpecialChar = value
                              .contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>-]'));
                          hasDigit = value.contains(RegExp(r'[0-9]'));
                          is6char = value.length >= 6;
                        });
                      },
                    ),
                    Divider(
                      color: tcWhite,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      controller: _confirmPassController,
                      focusNode: _confirmPassFocus,
                      obscureText: false,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: tcBlack,
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
                        contentPadding: EdgeInsets.symmetric(vertical: 16),
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
                      color: tcWhite,
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
                                color: tcBlack,
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
                                color: tcBlack,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              hasUppercase ? Icons.check_circle : Icons.circle,
                              color: hasUppercase ? tcGreen : tcRed,
                            ),
                            Text(
                              'Has Uppercase',
                              style: TextStyle(
                                fontFamily: 'PublicSans',
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w300,
                                color: tcBlack,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              hasLowercase ? Icons.check_circle : Icons.circle,
                              color: hasLowercase ? tcGreen : tcRed,
                            ),
                            Text(
                              'Has Lowercase',
                              style: TextStyle(
                                fontFamily: 'PublicSans',
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w300,
                                color: tcBlack,
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
                                color: tcBlack,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState != null &&
                        _formKey.currentState!.validate()) {
                      setState(() {
                        if (mounted) {
                          isLoading = true;
                        }
                      });

                      await changePassword(
                          _oldPasswordController.text,
                          _passwordController.text,
                          _confirmPassController.text);

                      setState(() {
                        if (mounted) {
                          isLoading = false;
                        }
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tcViolet,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                  ),
                  child: isLoading != false
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Change',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'PublicSans',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: tcWhite,
                          ),
                        ),
                ),
              ),
            ],
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
