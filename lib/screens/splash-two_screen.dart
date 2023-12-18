import 'package:TagConnect/animations/slideLeft_animation.dart';
import 'package:TagConnect/animations/slideRight_animation.dart';
import 'package:TagConnect/constants/color_constant.dart';
import 'package:TagConnect/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:TagConnect/screens/splash-one_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeTwoScreen extends StatelessWidget {
  const WelcomeTwoScreen({super.key});

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
        title: Container(
          child: RichText(
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
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              Image.asset(
                'assets/images/cyber-security.png',
                width: 170.w,
                height: 170.w,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Text(
                  'Your information is securely guarded, ensuring its utmost protection.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'PublicSans',
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400,
                    color: textColor,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () async {
                        Navigator.push(
                          context,
                          SlideRightAnimation(
                            const WelcomeOneScreen(),
                          ),
                        );
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
                    SizedBox(
                      height: 50.h,
                      child: ElevatedButton(
                        onPressed: () async {
                          final SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.setBool('firstOpen', true);
                          Navigator.push(
                            context,
                            SlideLeftAnimation(
                              const LoginScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: tcViolet,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 2,
                        ),
                        child: Icon(
                          Icons.arrow_right_alt_outlined,
                          size: 40.r,
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
