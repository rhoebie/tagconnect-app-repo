import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taguigconnect/constants/color_constant.dart';
import 'package:taguigconnect/screens/report-emergency_screen.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: tcBlack,
                    ),
                    children: [
                      TextSpan(
                        text: 'Welcome, ',
                      ),
                      TextSpan(
                        text: 'John',
                        style: TextStyle(
                          color: tcViolet,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'How are you feeling today?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: tcBlack,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: tcBlack,
                        ),
                        children: [
                          TextSpan(
                            text: 'Your total reports: ',
                          ),
                          TextSpan(
                            text: '0',
                            style: TextStyle(
                              color: tcBlack,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: tcBlack,
                        ),
                        children: [
                          TextSpan(
                            text: 'Total barangay: ',
                          ),
                          TextSpan(
                            text: '38',
                            style: TextStyle(
                              color: tcBlack,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.transparent,
                  height: 10.h,
                ),
                Container(
                  width: double.infinity.w,
                  height: 130.h,
                  decoration: BoxDecoration(
                    color: tcViolet,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 10,
                        top: 10,
                        child: Text(
                          'Not feeling safe?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'PublicSans',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: tcWhite,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 10,
                        top: 35,
                        child: Text(
                          'Need urgent emergency?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'PublicSans',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: tcWhite,
                          ),
                        ),
                      ),
                      Positioned(
                          right: 10,
                          bottom: 10,
                          child: Container(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: tcWhite,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 2,
                              ),
                              child: Text(
                                'One tap report',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: tcViolet,
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Call Emergency Service',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: tcBlack,
                  ),
                ),
                Divider(
                  color: Colors.transparent,
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 60.w,
                          height: 60.w,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: EdgeInsets.all(16),
                              backgroundColor: tcOrange,
                              elevation: 2,
                            ),
                            child: Icon(
                              Icons.phone,
                              color: tcWhite,
                            ),
                          ),
                        ),
                        Divider(
                          color: Colors.transparent,
                          height: 5.h,
                        ),
                        Text(
                          'General',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: tcBlack,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          width: 60.w.w,
                          height: 60.w.h,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: EdgeInsets.all(16),
                              backgroundColor: tcGreen,
                              elevation: 2,
                            ),
                            child: Icon(
                              Icons.phone,
                              color: tcWhite,
                            ),
                          ),
                        ),
                        Divider(
                          color: Colors.transparent,
                          height: 5.h,
                        ),
                        Text(
                          'Medical',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: tcBlack,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          width: 60.w,
                          height: 60.w,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: EdgeInsets.all(16),
                              backgroundColor: tcRed,
                              elevation: 2,
                            ),
                            child: Icon(
                              Icons.phone,
                              color: tcWhite,
                            ),
                          ),
                        ),
                        Divider(
                          color: Colors.transparent,
                          height: 5.h,
                        ),
                        Text(
                          'Fire',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: tcBlack,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          width: 60.w,
                          height: 60.w,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: EdgeInsets.all(16),
                              backgroundColor: tcBlue,
                              elevation: 2,
                            ),
                            child: Icon(
                              Icons.phone,
                              color: tcWhite,
                            ),
                          ),
                        ),
                        Divider(
                          color: Colors.transparent,
                          height: 5.h,
                        ),
                        Text(
                          'Crime',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: tcBlack,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'News and Updates',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: tcBlack,
                  ),
                ),
                Divider(
                  color: Colors.transparent,
                  height: 10.h,
                ),
                Container(
                  width: double.infinity.w,
                  height: 250.h,
                  color: tcAsh,
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: OpenContainer(
        closedElevation: 5,
        closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
        ),
        transitionType: ContainerTransitionType.fade,
        transitionDuration: const Duration(milliseconds: 300),
        openBuilder: (BuildContext context, VoidCallback _) {
          return ReportEmergencyScreen();
        },
        tappable: false,
        closedBuilder: (BuildContext context, VoidCallback openContainer) {
          return FloatingActionButton(
            backgroundColor: tcViolet,
            onPressed: openContainer,
            child: const Icon(
              Icons.add,
              color: tcWhite,
              size: 30,
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
