import 'package:TagConnect/animations/fade_animation.dart';
import 'package:TagConnect/configs/network_config.dart';
import 'package:TagConnect/models/report_model.dart';
import 'package:TagConnect/screens/about_screen.dart';
import 'package:TagConnect/screens/account_screen.dart';
import 'package:TagConnect/screens/barangay-list_screen.dart';
import 'package:TagConnect/screens/change-password_screen.dart';
import 'package:TagConnect/screens/login_screen.dart';
import 'package:TagConnect/screens/news-list_screen.dart';
import 'package:TagConnect/screens/report-emergency_screen.dart';
import 'package:TagConnect/screens/report-list_screen.dart';
import 'package:TagConnect/screens/settings_screen.dart';
import 'package:TagConnect/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenuWidget extends StatefulWidget {
  const MenuWidget({super.key});

  @override
  State<MenuWidget> createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  late List<ReportModel> reportData = [];
  int? reportCount;
  String? imageUrl;

  Future<void> logoutuser() async {
    bool isConnnected = await NetworkService.isConnected();
    try {
      if (isConnnected) {
        final userService = UserService();
        final bool response = await userService.logout();

        if (response) {
          Navigator.of(context).pushReplacement(
            FadeAnimation(LoginScreen()),
          );
          print('Logout successful.');
        } else {
          print('Logout failed.');
        }
      } else {
        if (mounted) {
          setState(
            () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('No Internet'),
                  content: const Text('You dont have internet.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => {Navigator.pop(context, 'OK')},
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          );
        }
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
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Taguig Alert',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return NewsList();
                      },
                    ),
                  );
                },
                titleAlignment: ListTileTitleAlignment.center,
                title: Text(
                  'News',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: textColor,
                  ),
                ),
                trailing: Icon(
                  Icons.navigate_next,
                  color: textColor,
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return ReportEmergencyScreen();
                      },
                    ),
                  );
                },
                titleAlignment: ListTileTitleAlignment.center,
                title: Text(
                  'Add Report (Concern Citizen)',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: textColor,
                  ),
                ),
                trailing: Icon(
                  Icons.navigate_next,
                  color: textColor,
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return BarangayListScreen();
                      },
                    ),
                  );
                },
                titleAlignment: ListTileTitleAlignment.center,
                title: Text(
                  'Barangay',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: textColor,
                  ),
                ),
                trailing: Icon(
                  Icons.navigate_next,
                  color: textColor,
                ),
              ),
              Divider(
                color: Colors.transparent,
              ),
              Text(
                'Account',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return ReportListScreen();
                      },
                    ),
                  );
                },
                titleAlignment: ListTileTitleAlignment.center,
                title: Text(
                  'Reports',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: textColor,
                  ),
                ),
                trailing: Icon(
                  Icons.navigate_next,
                  color: textColor,
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return AccountScreen();
                      },
                    ),
                  );
                },
                titleAlignment: ListTileTitleAlignment.center,
                title: Text(
                  'User Information',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: textColor,
                  ),
                ),
                trailing: Icon(
                  Icons.navigate_next,
                  color: textColor,
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return ChangePasswordScreen();
                      },
                    ),
                  );
                },
                titleAlignment: ListTileTitleAlignment.center,
                title: Text(
                  'Change Password',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: textColor,
                  ),
                ),
                trailing: Icon(
                  Icons.navigate_next,
                  color: textColor,
                ),
              ),
              Divider(
                color: Colors.transparent,
              ),
              Text(
                'System',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return SettingScreen();
                      },
                    ),
                  );
                },
                titleAlignment: ListTileTitleAlignment.center,
                title: Text(
                  'Settings',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: textColor,
                  ),
                ),
                trailing: Icon(
                  Icons.navigate_next,
                  color: textColor,
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return AboutScreen();
                      },
                    ),
                  );
                },
                titleAlignment: ListTileTitleAlignment.center,
                title: Text(
                  'About',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: textColor,
                  ),
                ),
                trailing: Icon(
                  Icons.navigate_next,
                  color: textColor,
                ),
              ),
              ListTile(
                onTap: logoutuser,
                titleAlignment: ListTileTitleAlignment.center,
                title: Text(
                  'Logout',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: textColor,
                  ),
                ),
                trailing: Icon(
                  Icons.navigate_next,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
