import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:TagConnect/constants/color_constant.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tcWhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: CloseButton(),
        iconTheme: const IconThemeData(color: tcBlack),
        backgroundColor: tcWhite,
        elevation: 0,
        title: Text(
          'ABOUT',
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
          child: ListView(
            children: [
              Text(
                'Bachelor of Science in Computer Science',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: tcViolet,
                ),
              ),
              Divider(
                color: Colors.transparent,
                height: 5,
              ),
              Text(
                'This system, an essential part of the Taguig City University thesis, offers a practical and user-friendly platform, playing a crucial role in supporting thorough research and analysis needed for successful completion. Please note that the thesis has not yet been defended.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: tcBlack,
                ),
              ),
              Divider(
                color: Colors.transparent,
              ),
              Text(
                'TagConnect',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: tcViolet,
                ),
              ),
              Divider(
                color: Colors.transparent,
                height: 5,
              ),
              Text(
                'The Android-Based Incident Response Management System is an innovative and efficient solution designed to enhance incident reporting and response procedures within the urban landscape of Taguig City. Leveraging Flutter for multiplatform deployment, the system seamlessly integrates both Android and web applications to cater to various user levels: admin, moderator, and end users.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: tcBlack,
                ),
              ),
              Divider(
                color: Colors.transparent,
              ),
              Text(
                'Scope',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: tcGreen,
                ),
              ),
              Divider(
                color: Colors.transparent,
                height: 5,
              ),
              RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Multiplatform Development:\n',
                      style: TextStyle(
                        color: tcBlack,
                        fontFamily: 'PublicSans',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text:
                          '- The system will be developed using Flutter, ensuring a single codebase for a multiplatform release, enabling accessibility on both Android devices and web browsers.\n',
                      style: TextStyle(
                        color: tcBlack,
                        fontFamily: 'PublicSans',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Incident Reporting:\n',
                      style: TextStyle(
                        color: tcBlack,
                        fontFamily: 'PublicSans',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text:
                          '- Users can report incidents through the Android application, providing location and information for efficient response by barangay authorities.\n',
                      style: TextStyle(
                        color: tcBlack,
                        fontFamily: 'PublicSans',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Haversine Formula Algorithm\n',
                      style: TextStyle(
                        color: tcBlack,
                        fontFamily: 'PublicSans',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text:
                          '- The system employs the Haversine Formula Algorithm to determine the nearest barangay for incident notification, optimizing the dispatch process.\n',
                      style: TextStyle(
                        color: tcBlack,
                        fontFamily: 'PublicSans',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'User Levels:\n',
                      style: TextStyle(
                        color: tcBlack,
                        fontFamily: 'PublicSans',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text:
                          '- The system caters to three user levels - admin, moderator, and end users - each with distinct functionalities to manage incidents, accounts, and analytics.\n',
                      style: TextStyle(
                        color: tcBlack,
                        fontFamily: 'PublicSans',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Web Application for Admin:\n',
                      style: TextStyle(
                        color: tcBlack,
                        fontFamily: 'PublicSans',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text:
                          '- Admins can create accounts, view all incident reports in the database, and perform data analytics, including bar graphs, line graphs, and total reports.\n',
                      style: TextStyle(
                        color: tcBlack,
                        fontFamily: 'PublicSans',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Web Application for Moderator:\n',
                      style: TextStyle(
                        color: tcBlack,
                        fontFamily: 'PublicSans',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text:
                          '- Moderators can create accounts (pending admin confirmation), view incident reports within their barangay boundary, manage reports, and access data analytics specific to their assigned area.\n',
                      style: TextStyle(
                        color: tcBlack,
                        fontFamily: 'PublicSans',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Android Application for End Users:\n',
                      style: TextStyle(
                        color: tcBlack,
                        fontFamily: 'PublicSans',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text:
                          '- End users can create accounts, report incidents with location details, and access data analytics, including a bar graph depicting report counts based on emergency types.\n',
                      style: TextStyle(
                        color: tcBlack,
                        fontFamily: 'PublicSans',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Data Analytics:\n',
                      style: TextStyle(
                        color: tcBlack,
                        fontFamily: 'PublicSans',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text:
                          '- Both web applications provide analytics features, including bar graphs, line graphs, and total incident reports, offering insights into trends and patterns.\n',
                      style: TextStyle(
                        color: tcBlack,
                        fontFamily: 'PublicSans',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.transparent,
              ),
              Text(
                'Limitation',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: tcRed,
                ),
              ),
              Divider(
                color: Colors.transparent,
                height: 5,
              ),
              RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Geographical Constraint:\n',
                      style: TextStyle(
                        color: tcBlack,
                        fontFamily: 'PublicSans',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text:
                          '- The system is limited to Taguig City and its barangays, and it may not be applicable or accurate for areas outside this scope.\n',
                      style: TextStyle(
                        color: tcBlack,
                        fontFamily: 'PublicSans',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Location Accuracy:\n',
                      style: TextStyle(
                        color: tcBlack,
                        fontFamily: 'PublicSans',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text:
                          '- The precision of incident location determination relies on the device\'s GPS and the Haversine Formula Algorithm, with potential deviations in accuracy.\n',
                      style: TextStyle(
                        color: tcBlack,
                        fontFamily: 'PublicSans',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Emergency Type Limitations:\n',
                      style: TextStyle(
                        color: tcBlack,
                        fontFamily: 'PublicSans',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text:
                          '-  Incident categorization is based on predefined emergency types, potentially limiting the accurate description of incidents that do not fit within these categories.\n',
                      style: TextStyle(
                        color: tcBlack,
                        fontFamily: 'PublicSans',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Android Compatibility:\n',
                      style: TextStyle(
                        color: tcBlack,
                        fontFamily: 'PublicSans',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text:
                          '- The Android application is designed for devices running the Android OS, and compatibility with other operating systems is outside the system\'s scope.\n',
                      style: TextStyle(
                        color: tcBlack,
                        fontFamily: 'PublicSans',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
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
