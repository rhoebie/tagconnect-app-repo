import 'dart:async';
import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:TagConnect/constants/color_constant.dart';
import 'package:TagConnect/models/barangay_model.dart';
import 'package:TagConnect/models/feed_model.dart';
import 'package:TagConnect/models/news_model.dart';
import 'package:TagConnect/models/user_model.dart';
import 'package:TagConnect/screens/news-details_screen.dart';
import 'package:TagConnect/screens/news-list_screen.dart';
import 'package:TagConnect/screens/report-details_screen.dart';
import 'package:TagConnect/screens/report-emergency_screen.dart';
import 'package:http/http.dart' as http;
import 'package:TagConnect/services/barangay_service.dart';
import 'package:TagConnect/services/user_service.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final List<Color> bgColor = [tcOrange, tcGreen, tcRed, tcBlue];
  List<FeedModel> reportData = [];
  List<BarangayModel> barangayData = [];
  late PageController _pageController;
  int _currentPage = 0;
  late Timer _timer;
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

  Future<void> fetchReportData() async {
    final url =
        Uri.parse('https://taguigconnect.online/api/get-reports?page=1');

    // Create a map with the request body
    final Map<String, dynamic> requestBody = {'barangayName': 'all'};

    try {
      final response = await http.post(
        url,
        body: json.encode(requestBody),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'];
        List<FeedModel> reports =
            data.map((item) => FeedModel.fromJson(item)).toList();

        // Sort the reports by id in descending order
        reports.sort((a, b) => b.id!.compareTo(a.id!));

        setState(() {
          reportData = reports;
        });
      } else {
        throw Exception('Failed to load reports');
      }
    } catch (error) {
      // Handle network-related errors
      throw Exception('Network error: $error');
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

  Future<void> fetchBarangay() async {
    try {
      final barangayService = BarangayService();
      final List<BarangayModel> fetchData =
          await barangayService.getbarangays();

      setState(() {
        barangayData = fetchData;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchInit() async {
    try {
      await fetchUserData();
      await fetchBarangay();
      await fetchReportData();
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchInit();
    _pageController = PageController();
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 4) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
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
            Container(
              height: 300.h,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.horizontal,
                  itemCount: reportData.length >= 5 ? 5 : reportData.length,
                  itemBuilder: (context, index) {
                    final item = reportData[index];
                    final barangayInfo = barangayData.firstWhere(
                      (barangay) => barangay.id == item.barangayId,
                      orElse: () => BarangayModel(),
                    );
                    return Container(
                      width: double.infinity,
                      height: 300.h,
                      child: Column(
                        children: [
                          Expanded(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Positioned.fill(
                                  child: CachedNetworkImage(
                                    imageUrl: item.image!,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          Colors.black,
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            width: double.infinity,
                            height: 70,
                            color: Colors.black,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor: tcViolet,
                                      foregroundColor: tcWhite,
                                      child: barangayInfo.image != null
                                          ? ClipOval(
                                              child: CachedNetworkImage(
                                                imageUrl: barangayInfo.image!,
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) =>
                                                    Center(
                                                        child:
                                                            CircularProgressIndicator()),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              ),
                                            )
                                          : Icon(
                                              Icons.question_mark,
                                              size: 20,
                                            ),
                                    ),
                                    VerticalDivider(
                                      color: Colors.transparent,
                                      width: 10,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Report ID: ${item.id.toString()}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'PublicSans',
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w700,
                                            color: tcWhite,
                                          ),
                                        ),
                                        Text(
                                          formatCustomDateTime(
                                              item.createdAt.toString()),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'PublicSans',
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w400,
                                            color: tcWhite,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Container(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return ReportDetail(
                                              feedModel: item,
                                              barangayModel: barangayInfo,
                                            );
                                          },
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
                                    child: Text(
                                      'View',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w700,
                                        color: tcWhite,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
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
                                                  child: CachedNetworkImage(
                                                    imageUrl: item.image!,
                                                    fit: BoxFit.cover,
                                                    placeholder: (context,
                                                            url) =>
                                                        Center(
                                                            child:
                                                                CircularProgressIndicator()),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(Icons.error),
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
