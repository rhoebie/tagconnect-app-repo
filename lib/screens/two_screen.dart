import 'package:shared_preferences/shared_preferences.dart';
import 'package:taguigconnect/animations/slideLeft_animation.dart';
import 'package:taguigconnect/constants/color_constant.dart';
import 'package:taguigconnect/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          child: Row(
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
                      fontSize: 26.sp,
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
                          final SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.setBool('firstOpen', false);
                          Navigator.push(
                            context,
                            SlideLeftAnimation(
                              const LoginScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Skip',
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
                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.setBool('firstOpen', false);
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
                          child: const Icon(
                            Icons.arrow_right_alt_outlined,
                            size: 40,
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