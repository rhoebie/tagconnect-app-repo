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
                'Taguig Connect',
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
                'Our Android-Based Incident Response Management System for Taguig City is a cutting-edge solution designed to streamline incident reporting and management within the city\'s barangays. Leveraging advanced technologies such as Flutter, Point in Polygon algorithms, and data analytics, this system is built to enhance public safety and empower local authorities with valuable insights.',
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
                'Key Capabilities',
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
              RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Efficient Incident Reporting:\n',
                      style: TextStyle(
                        color: tcBlack,
                        fontFamily: 'PublicSans',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text:
                          '- The system provides a user-friendly Android application for end users to report incidents promptly and accurately.\n- Users can submit incident details, including their location, ensuring swift response and resolution.\n',
                      style: TextStyle(
                        color: tcBlack,
                        fontFamily: 'PublicSans',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400, // Make this part bold
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
                      text: 'Precise Barangay Assignment:\n',
                      style: TextStyle(
                        color: tcBlack,
                        fontFamily: 'PublicSans',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text:
                          '- Utilizing the Point in Polygon algorithm, the system intelligently determines the appropriate barangay to notify based on the user\'s location.\n- This ensures that incident reports are directed to the correct local authorities for a rapid and efficient response.\n',
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
                      text: 'Web-Based Administrative Control:\n',
                      style: TextStyle(
                        color: tcBlack,
                        fontFamily: 'PublicSans',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text:
                          '- The web application offers a powerful administrative interface for barangay officials and administrators.\n- Admins can create accounts, view incident reports within their jurisdiction, and manage these reports effectively.\n',
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
                      text: 'Data Analytics for Informed Decision Making:\n',
                      style: TextStyle(
                        color: tcBlack,
                        fontFamily: 'PublicSans',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text:
                          '- Robust data analytics capabilities enable administrators to gain valuable insights from incident data.\n- Administrators can track incident trends, assess the effectiveness of response efforts, and make data-driven decisions to improve public safety.\n',
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
                      text: 'User Friendly Experience:\n',
                      style: TextStyle(
                        color: tcBlack,
                        fontFamily: 'PublicSans',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text:
                          '- Both Android and web applications are designed with a focus on user-friendliness, ensuring that users can easily report incidents and administrators can navigate the system effortlessly.\n',
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
                      text: 'Data Security and Privacy:\n',
                      style: TextStyle(
                        color: tcBlack,
                        fontFamily: 'PublicSans',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text:
                          '- The system prioritizes data security and privacy, implementing encryption and access controls to safeguard sensitive information.\n',
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
                      text: 'Scalability and Flexibility:\n',
                      style: TextStyle(
                        color: tcBlack,
                        fontFamily: 'PublicSans',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text:
                          '- Designed to scale with growing user and incident data, the system can adapt to the changing needs of Taguig City and its barangays.\n',
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
                      text: 'Enhancing Public Safety:\n',
                      style: TextStyle(
                        color: tcBlack,
                        fontFamily: 'PublicSans',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text:
                          '- By providing a seamless incident reporting process and facilitating efficient incident management, this system contributes to the safety and well-being of Taguig City\'s residents and visitors.\n',
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
                      text: 'Incident Reporting and Management:\n',
                      style: TextStyle(
                        color: tcBlack,
                        fontFamily: 'PublicSans',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text:
                          '- The system encompasses incident reporting and management within the geographical boundaries of Taguig City.\n- It allows users to report various types of incidents, including but not limited to accidents, emergencies, and public safety concerns.\n',
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
                      text: 'Geographical Specificity:\n',
                      style: TextStyle(
                        color: tcBlack,
                        fontFamily: 'PublicSans',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text:
                          '- The system uses the Point in Polygon algorithm to accurately determine the responsible barangay based on the user\'s location within the city.\n- It ensures that incident reports are directed to the appropriate local authorities for swift response and resolution.\n',
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
                      text: 'Multiplatform Application:\n',
                      style: TextStyle(
                        color: tcBlack,
                        fontFamily: 'PublicSans',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text:
                          '- The system offers a cross-platform Android application built using Flutter, allowing users to report incidents conveniently using a single codebase for Android only\n',
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
                      text: 'Web-Based Administration:\n',
                      style: TextStyle(
                        color: tcBlack,
                        fontFamily: 'PublicSans',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text:
                          '- Administrators have access to a web application for managing incident reports within their respective barangays.\n- They can view, update, and analyze incident data, enabling data-driven decision-making.\n',
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
                          '- The system provides data analytics features that enable administrators to extract valuable insights from incident data, such as incident trends, patterns, and hotspots.\n- This data can aid in resource allocation and improved public safety strategies.\n',
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
                      text: 'User Authentication and Data Security:\n',
                      style: TextStyle(
                        color: tcBlack,
                        fontFamily: 'PublicSans',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text:
                          '- User accounts are protected through secure authentication mechanisms.\n- Data privacy and security are maintained through encryption and access controls. \n',
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
                      text: 'Scalability:\n',
                      style: TextStyle(
                        color: tcBlack,
                        fontFamily: 'PublicSans',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text:
                          '- The system is designed to handle potential increases in users and incident reports as the user base grows.\n- Scalability measures are in place to ensure system performance.',
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
                      text: 'Accuracy of Location Data:\n',
                      style: TextStyle(
                        color: tcBlack,
                        fontFamily: 'PublicSans',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text:
                          '- The accuracy of the Point in Polygon algorithm relies on the precision of location data provided by users\' devices. Inaccurate or outdated location information may affect the system\'s functionality.\n',
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
                      text: 'Data Volume:\n',
                      style: TextStyle(
                        color: tcBlack,
                        fontFamily: 'PublicSans',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text:
                          '- While designed to scale, the system\'s performance may be affected by exceptionally high volumes of incident reports or concurrent users. Ongoing monitoring and optimization may be necessary.\n',
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
                      text: 'Data Privacy Compliance:\n',
                      style: TextStyle(
                        color: tcBlack,
                        fontFamily: 'PublicSans',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text:
                          '- Compliance with data privacy regulations, such as the Data Privacy Act, is essential. However, the responsibility for compliance lies with the system administrators and operators.\n',
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
                      text: 'User Adoption:\n',
                      style: TextStyle(
                        color: tcBlack,
                        fontFamily: 'PublicSans',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text:
                          '- The effectiveness of the system relies on user adoption and engagement. Encouraging users to report incidents through the app may require awareness campaigns and incentives.\n',
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
                      text: 'Response Time:\n',
                      style: TextStyle(
                        color: tcBlack,
                        fontFamily: 'PublicSans',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text:
                          '- The system facilitates incident reporting but does not guarantee immediate response or resolution. Response times may vary based on the nature and urgency of reported incidents and the availability of local authorities.\n',
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
                      text: 'Maintenance and Support:\n',
                      style: TextStyle(
                        color: tcBlack,
                        fontFamily: 'PublicSans',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text:
                          '- Ongoing system maintenance, updates, and user support are required to ensure its continued functionality and usefulness.\n',
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
