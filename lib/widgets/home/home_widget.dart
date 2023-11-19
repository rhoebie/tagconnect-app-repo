import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taguigconnect/constants/color_constant.dart';
import 'package:taguigconnect/models/news_model.dart';
import 'package:taguigconnect/models/user_model.dart';
import 'package:taguigconnect/screens/news-details_screen.dart';
import 'package:taguigconnect/screens/news-list_screen.dart';
import 'package:taguigconnect/screens/report-emergency_screen.dart';
import 'package:http/http.dart' as http;
import 'package:taguigconnect/services/user_service.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  late UserModel userData = UserModel(
    firstname: '',
    lastname: '',
    age: 0,
    birthdate: '',
    contactnumber: '',
    address: '',
    image: '',
  );

  Future<void> fetchUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      // Initialize Service for User
      final userService = UserService();
      final userId = prefs.getInt('userId');
      if (userId != null) {
        final UserModel fetchUserData = await userService.getUserById(userId);
        setState(() {
          userData = fetchUserData;
        });
      } else {
        print('Error Fetching Data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<List<NewsModel>?> fetchNewsData() async {
    try {
      final url = 'https://taguigconnect.online/api/get-news?page=1';
      final response = await http.get(
        Uri.parse(url),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'];

        List<NewsModel> fetchNewsList =
            data.map((item) => NewsModel.fromJson(item)).toList();

        // Sort the list based on the date
        fetchNewsList.sort((a, b) => a.date!.compareTo(b.date!));

        return fetchNewsList;
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserData();
  }

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
                        text: userData.lastname ?? '',
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
                          fontSize: 14.sp,
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
                          fontSize: 14.sp,
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
                  height: 5.h,
                ),
                Container(
                  width: double.infinity.w,
                  height: 120.h,
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
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: tcWhite,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 15,
                        bottom: 10,
                        child: Container(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: tcWhite,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
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
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Taguig Emergency Service',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: tcBlack,
                  ),
                ),
                Divider(
                  color: Colors.transparent,
                  height: 5.h,
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
                            onPressed: () async {
                              final Uri launchUri = Uri(
                                scheme: 'tel',
                                path: '911',
                              );
                              await launchUrl(launchUri);
                            },
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
                            fontSize: 12.sp,
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
                            onPressed: () async {
                              final Uri launchUri = Uri(
                                scheme: 'tel',
                                path: '143',
                              );
                              await launchUrl(launchUri);
                            },
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
                            fontSize: 12.sp,
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
                            onPressed: () async {
                              final Uri launchUri = Uri(
                                scheme: 'tel',
                                path: '160',
                              );
                              await launchUrl(launchUri);
                            },
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
                            fontSize: 12.sp,
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
                            onPressed: () async {
                              final Uri launchUri = Uri(
                                scheme: 'tel',
                                path: '117',
                              );
                              await launchUrl(launchUri);
                            },
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
                            fontSize: 12.sp,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'News and Updates',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: tcBlack,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return NewsList();
                            },
                          ),
                        );
                      },
                      child: Text(
                        'View More',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: tcViolet,
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.transparent,
                  height: 5.h,
                ),
                Container(
                  width: double.infinity.w,
                  height: 250.h,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: FutureBuilder(
                      future: fetchNewsData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: tcViolet,
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          final newsData = snapshot.data!;
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: newsData.length,
                            itemBuilder: (context, index) {
                              final item = newsData[index];
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return NewsDetails(
                                          newsModel: item,
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 180,
                                  child: Card(
                                    elevation: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(10)),
                                          child: item.image != null
                                              ? Container(
                                                  width: 180.w,
                                                  height: 100.h,
                                                  child: Image.network(
                                                    item.image!,
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                              : Container(
                                                  width: 180.w,
                                                  height: 100.h,
                                                  color: tcAsh,
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.question_mark,
                                                      size: 20,
                                                      color: tcBlack,
                                                    ),
                                                  ),
                                                ),
                                        ),
                                        Expanded(
                                          child: Container(
                                              padding: EdgeInsets.all(5),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      RichText(
                                                        textAlign:
                                                            TextAlign.start,
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        text: TextSpan(
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Roboto',
                                                            fontSize: 12.sp,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: tcBlack,
                                                          ),
                                                          children: [
                                                            TextSpan(
                                                                text:
                                                                    'Author: ',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700)),
                                                            TextSpan(
                                                              text:
                                                                  item.author ??
                                                                      '',
                                                              style: TextStyle(
                                                                color: tcBlack,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Text(
                                                        'Title: ${item.title ?? ''}',
                                                        maxLines: 3,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'PublicSans',
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: tcBlack,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    formatCustomDateTime(
                                                        item.date.toString()),
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: tcBlack,
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return Center(
                            child: Text('No data available'),
                          );
                        }
                      },
                    ),
                  ),
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

String formatCustomDateTime(String input) {
  final inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss.SSS");
  final dateTime = inputFormat.parse(input);

  // Updated output format
  final outputFormat = DateFormat("E, d MMM y hh:mma");
  final formattedDate = outputFormat.format(dateTime);

  return formattedDate;
}
