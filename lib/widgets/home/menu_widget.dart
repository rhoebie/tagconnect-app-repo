import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taguigconnect/animations/fade_animation.dart';
import 'package:taguigconnect/configs/network_config.dart';
import 'package:taguigconnect/constants/color_constant.dart';
import 'package:taguigconnect/constants/endpoint_constant.dart';
import 'package:taguigconnect/models/barangay_model.dart';
import 'package:taguigconnect/models/report_model.dart';
import 'package:taguigconnect/models/user_model.dart';
import 'package:taguigconnect/screens/about_screen.dart';
import 'package:taguigconnect/screens/account_screen.dart';
import 'package:taguigconnect/screens/barangay-list_screen.dart';
import 'package:taguigconnect/screens/change-password_screen.dart';
import 'package:taguigconnect/screens/login_screen.dart';
import 'package:taguigconnect/screens/news-list_screen.dart';
import 'package:taguigconnect/screens/report-list_screen.dart';
import 'package:taguigconnect/services/barangay_service.dart';
import 'package:taguigconnect/services/user_service.dart';

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

  Future<UserModel?> fetchUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      // Initialize Service for User
      final userService = UserService();
      final userId = prefs.getInt('userId');

      if (userId != null) {
        final UserModel userData = await userService.getUserById(userId);
        return userData;
      } else {
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  // Future<int> fetchReportData() async {
  //   try {
  //     final reportService = ReportService();
  //     final List<ReportModel> reportData = await reportService.getReports();

  //     return reportData.length;
  //   } catch (e) {
  //     print('Error fetching reportData: $e');
  //     throw e;
  //   }
  // }

  Future<int> fetchBarangayData() async {
    try {
      final barangayService = BarangayService();
      final List<BarangayModel> barangayData =
          await barangayService.getbarangays();

      return barangayData.length;
    } catch (e) {
      print('Error fetching barangayData: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 100,
                child: FutureBuilder(
                  future: fetchUserData(),
                  builder: (context, snapshot) {
                    try {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          width: double.infinity,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: tcViolet,
                            ),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        final items = snapshot.data;
                        items!.image != null
                            ? imageUrl = ApiConstants.baseUrl + items.image!
                            : imageUrl = null;

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return AccountScreen();
                                    },
                                  ),
                                );
                              },
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: tcAsh,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  child: (imageUrl?.isEmpty ?? true)
                                      ? Center(
                                          child: Icon(
                                            Icons.question_mark,
                                            size: 50,
                                            color: tcBlack,
                                          ),
                                        )
                                      : Image.network(
                                          imageUrl!,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                            ),
                            VerticalDivider(
                              color: Colors.transparent,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 210,
                                  child: AutoSizeText(
                                    '${items.lastname}, ${items.firstname} ${items.middlename}',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: tcBlack,
                                      fontFamily: 'PublicSans',
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Divider(
                                  color: Colors.transparent,
                                  height: 5,
                                ),
                                Text(
                                  items.contactnumber!,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: tcBlack,
                                    fontFamily: 'PublicSans',
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  DateFormat.yMMMMd().format(DateTime.parse(
                                      items.birthdate.toString())),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: tcBlack,
                                    fontFamily: 'PublicSans',
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            )
                          ],
                        );
                      } else {
                        return Center(
                          child: Text('No data available'),
                        );
                      }
                    } catch (e) {
                      print('Error in FutureBuilder: $e');
                      return Text('Error: $e');
                    }
                  },
                ),
              ),
              Divider(
                color: Colors.transparent,
              ),
              Text(
                'Taguig Alert',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: tcBlack,
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
                    color: tcBlack,
                  ),
                ),
                trailing: Icon(
                  Icons.navigate_next,
                  color: tcBlack,
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
                    color: tcBlack,
                  ),
                ),
                trailing: Icon(
                  Icons.navigate_next,
                  color: tcBlack,
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
                    color: tcBlack,
                  ),
                ),
                trailing: Icon(
                  Icons.navigate_next,
                  color: tcBlack,
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
                  color: tcBlack,
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
                    color: tcBlack,
                  ),
                ),
                trailing: Icon(
                  Icons.navigate_next,
                  color: tcBlack,
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
                    color: tcBlack,
                  ),
                ),
                trailing: Icon(
                  Icons.navigate_next,
                  color: tcBlack,
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
                  color: tcBlack,
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
                    color: tcBlack,
                  ),
                ),
                trailing: Icon(
                  Icons.navigate_next,
                  color: tcBlack,
                ),
              ),
              ListTile(
                onTap: () {
                  logoutuser();
                },
                titleAlignment: ListTileTitleAlignment.center,
                title: Text(
                  'Logout',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: tcBlack,
                  ),
                ),
                trailing: Icon(
                  Icons.navigate_next,
                  color: tcBlack,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
