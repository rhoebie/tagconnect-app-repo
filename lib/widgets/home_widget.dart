import 'dart:async';
import 'dart:convert';

import 'package:TagConnect/configs/request_service.dart';
import 'package:TagConnect/constants/barangay_constant.dart';
import 'package:TagConnect/constants/provider_constant.dart';
import 'package:TagConnect/constants/theme_constants.dart';
import 'package:TagConnect/models/create-report_model.dart';
import 'package:TagConnect/services/report_service.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:TagConnect/constants/color_constant.dart';
import 'package:TagConnect/models/news_model.dart';
import 'package:TagConnect/models/user_model.dart';
import 'package:TagConnect/screens/news-details_screen.dart';
import 'package:TagConnect/screens/news-list_screen.dart';
import 'package:http/http.dart' as http;
import 'package:TagConnect/services/user_service.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  String? locationData;
  double? userLatitude;
  double? userLongitude;
  bool isLoading = false;
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
        if (mounted) {
          setState(() {
            userData = fetchUserData;
          });
        }
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

  Future<void> fetchLocationData() async {
    final barangayConstant = BarangayConstant();
    LocationChecker locationChecker;
    LocationService locationService;
    locationChecker = LocationChecker(
      barangayConstant.cityTaguig,
      barangayConstant.taguigBarangays,
    );

    locationService = LocationService(locationChecker);

    try {
      final locationStats = await RequestService.locationPermission();
      if (locationStats) {
        final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
        final Position position = await geolocator.getCurrentPosition(
          locationSettings: AndroidSettings(accuracy: LocationAccuracy.best),
        );

        userLatitude = position.latitude;
        userLongitude = position.longitude;
        print('Latitude: $userLatitude, Longitude: $userLongitude');

        final locationIdk = await locationService.getUserLocation(
            userLatitude!, userLongitude!);
        if (mounted) {
          setState(() {
            var type = locationIdk['type'];
            var value = locationIdk['value'];
            if (type == 'exact') {
              print('Exact Value: $value');
              locationData = value;
            } else if (type == 'near') {
              print('Near Value: $value');
              locationData = value;
            } else {
              print("Other Location: $type");
            }
          });
        }
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Permission'),
              content: Text('Need Location/GPS Permission'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text('Yes'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Error fetching location: $e');
    }
  }

  Future<void> submitReport() async {
    final reportService = ReportService();

    try {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }

      await fetchLocationData();
      final locationUser =
          userLoc(latitude: userLatitude!, longitude: userLongitude!);
      final barangayName = locationData!;

      final reportMod = CreateReportModel(
        barangayId: barangayName,
        emergencyType: 'General',
        forWhom: 'Myself',
        description: null,
        casualties: null,
        location: locationUser,
        visibility: 'Private',
        image: null,
      );

      final bool response = await reportService.createReport(reportMod);

      if (response) {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }

        print('Success');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> prompt() async {
    try {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirmation'),
            content: Text('Are you sure you want to continue?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text('Yes'),
              ),
            ],
          );
        },
      ).then((value) {
        if (value != null && value) {
          submitReport();
          print('User pressed "Yes"');
        } else {
          print('User pressed "No" or dismissed the dialog');
        }
      });
    } catch (e) {
      print('Error: $e');
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
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final ThemeData theme = Theme.of(context);
    final Color backgroundColor = theme.scaffoldBackgroundColor;
    final Color textColor = theme.colorScheme.onBackground;

    return Scaffold(
      backgroundColor: backgroundColor,
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
                      color: textColor,
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
                    color: textColor,
                  ),
                ),
              ],
            ),
            Center(
              child: isLoading != false
                  ? CircularProgressIndicator(
                      color: textColor,
                    )
                  : AvatarGlow(
                      glowColor: tcRed,
                      endRadius: 130,
                      duration: Duration(milliseconds: 2000),
                      repeat: true,
                      showTwoGlows: true,
                      curve: Curves.easeOutQuad,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(99),
                        onTap: prompt,
                        child: Container(
                            height: 140,
                            width: 140,
                            decoration: BoxDecoration(
                              color: tcRed,
                              shape: BoxShape.circle,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.touch_app,
                                  color: tcWhite,
                                  size: 70,
                                ),
                                Divider(
                                  color: Colors.transparent,
                                  height: 5,
                                ),
                                Text(
                                  'Send Report',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'PublicSans',
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    color: tcWhite,
                                  ),
                                ),
                              ],
                            )),
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
                        color: textColor,
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
                                    color: themeNotifier.isDarkMode
                                        ? tcDark
                                        : tcWhite,
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
                                                      color: textColor,
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
                                                            color: textColor,
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
                                                                color:
                                                                    textColor,
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
                                                          color: textColor,
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
                                                      fontSize: 11.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: textColor,
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
