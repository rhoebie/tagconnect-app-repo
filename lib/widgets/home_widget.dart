import 'dart:async';
import 'package:TagConnect/configs/request_config.dart';
import 'package:TagConnect/constants/barangay_constant.dart';
import 'package:TagConnect/constants/provider_constant.dart';
import 'package:TagConnect/models/create-report_model.dart';
import 'package:TagConnect/services/news_service.dart';
import 'package:TagConnect/services/notification_service.dart';
import 'package:TagConnect/services/report_service.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:TagConnect/constants/color_constant.dart';
import 'package:TagConnect/models/news_model.dart';
import 'package:TagConnect/screens/news-details_screen.dart';
import 'package:TagConnect/screens/news-list_screen.dart';

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

  Future<List<NewsModel>?> fetchNewsData() async {
    print('Called');
    try {
      final newsService = NewsService();
      final fetchNews = await newsService.getNews(1);
      if (fetchNews != null) {
        return fetchNews;
      } else {
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
              title: const Text('Permission'),
              content: const Text('Need Location/GPS Permission'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Yes'),
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

      final String response = await reportService.createReport(reportMod);

      if (response != '') {
        Future.delayed(
          const Duration(seconds: 1),
          () async {
            final bool notifStatus = await notifyModerator(response);
            if (notifStatus) {
              if (mounted) {
                setState(() {
                  isLoading = false;
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Report Submitted'),
                        content: const Text(
                            'Wait for further updates about your submitted report'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                });
              }
            } else {
              print('Failed Notification');
            }
          },
        );
      } else {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
        print('Failed');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<bool> notifyModerator(String token) async {
    final notifService = NotificationService();
    try {
      final bool status = await notifService.triggerNotification(token);
      if (status) {
        print('notified');
        return true;
      } else {
        print('not notified');
        return true;
      }
    } catch (e) {
      throw Exception('Failed $e');
    }
  }

  Future<void> prompt() async {
    HapticFeedback.vibrate();
    try {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirmation'),
            content: const Text('Are you sure you want to continue?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Yes'),
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
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeProvider>(context);
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
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hi, Welcome!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  Text(
                    'Not feeling safe?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: tcBlue,
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: isLoading != false
                  ? CircularProgressIndicator(
                      color: textColor,
                    )
                  : AvatarGlow(
                      glowColor: tcRed,
                      endRadius: 130,
                      duration: const Duration(milliseconds: 2000),
                      repeat: true,
                      showTwoGlows: true,
                      curve: Curves.easeOutQuad,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(99),
                        onTap: prompt,
                        child: Container(
                            height: 140,
                            width: 140,
                            decoration: const BoxDecoration(
                              color: tcRed,
                              shape: BoxShape.circle,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.touch_app,
                                  color: tcWhite,
                                  size: 70,
                                ),
                                const Divider(
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
            const SizedBox(),
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
                              return const NewsList();
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
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: FutureBuilder(
                      future: fetchNewsData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
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
                                          borderRadius: const BorderRadius.vertical(
                                              top: Radius.circular(10)),
                                          child: item.image != null
                                              ? Container(
                                                  width: 180.w,
                                                  height: 100.h,
                                                  child: Image.network(
                                                    item.image!,
                                                    fit: BoxFit.cover,
                                                    loadingBuilder: (BuildContext
                                                            context,
                                                        Widget child,
                                                        ImageChunkEvent?
                                                            loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) {
                                                        return child;
                                                      } else {
                                                        return const Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        );
                                                      }
                                                    },
                                                    errorBuilder:
                                                        (BuildContext context,
                                                            Object error,
                                                            StackTrace?
                                                                stackTrace) {
                                                      return const Icon(Icons.error);
                                                    },
                                                  ),
                                                )
                                              : Container(
                                                  width: 180.w,
                                                  height: 100.h,
                                                  color: tcViolet,
                                                  child: const Center(
                                                    child: Icon(
                                                      Icons.question_mark,
                                                      size: 30,
                                                      color: tcWhite,
                                                    ),
                                                  ),
                                                ),
                                        ),
                                        Expanded(
                                          child: Container(
                                              padding: const EdgeInsets.all(5),
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
                                                            const TextSpan(
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
                          return const Center(
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
