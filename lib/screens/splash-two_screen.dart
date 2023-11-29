import 'package:TagConnect/animations/slideLeft_animation.dart';
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
    return Scaffold(
      backgroundColor: tcWhite,
      appBar: AppBar(
        backgroundColor: tcWhite,
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
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(),
                Image.asset(
                  'assets/images/shield.png',
                  width: 200.w,
                  height: 200.h,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: Text(
                    'Your information is securely guarded, ensuring its utmost protection.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PublicSans',
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w400,
                      color: tcBlack,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () async {
                          Navigator.push(
                            context,
                            SlideLeftAnimation(
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
                      Container(
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
                            size: 40,
                            color: tcWhite,
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
      ),
    );
  }
}
