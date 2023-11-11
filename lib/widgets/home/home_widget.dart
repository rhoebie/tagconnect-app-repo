import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart' as html;
import 'package:flutter_map/flutter_map.dart' as map;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:rss_dart/domain/rss_feed.dart';
import 'package:rss_dart/domain/rss_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taguigconnect/animations/slideUp_animation.dart';
import 'package:taguigconnect/constants/calculate_constant.dart';
import 'package:taguigconnect/constants/color_constant.dart';
import 'package:http/http.dart' as http;
import 'package:taguigconnect/constants/endpoint_constant.dart';
import 'package:taguigconnect/models/barangay-response_model.dart';
import 'package:taguigconnect/models/recent-report_model.dart';
import 'package:taguigconnect/models/user_model.dart';
import 'package:taguigconnect/screens/account_screen.dart';
import 'package:taguigconnect/screens/report-emergency_screen.dart';
import 'package:taguigconnect/services/user_service.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  double? userLatitude;
  double? userLongitude;
  String? imageUrl;

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

  Future<RecentReportModel?> fetchRecent() async {
    const apiUrl = 'https://taguigconnect.online/api/recent-incident';
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final token = prefs.getString('token');
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return RecentReportModel.fromJson(data);
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<String?> calculateDistances() async {
    try {
      final RecentReportModel? recentReportModel = await fetchRecent();

      final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
      final Position position = await geolocator.getCurrentPosition(
        locationSettings: AndroidSettings(accuracy: LocationAccuracy.best),
      );

      userLatitude = position.latitude;
      userLongitude = position.longitude;

      print('Latitude: $userLatitude, Longitude: $userLongitude');

      final distanceReport = HaversineCalculator.calculateDistance(
          userLatitude!,
          userLongitude!,
          recentReportModel!.location!.coordinates!.first,
          recentReportModel.location!.coordinates!.last);

      print('Distance to representative: $distanceReport');
      return distanceReport;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<AverageReportModel?> fetchBarangay() async {
    const apiUrl = 'https://taguigconnect.online/api/average-response';
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final token = prefs.getString('token');
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return AverageReportModel.fromJson(data);
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<RssFeed> fetchRssFeed() async {
    final response =
        await http.get(Uri.parse('https://www.manilatimes.net/news/feed/'));

    if (response.statusCode == 200) {
      return RssFeed.parse(response.body);
    } else {
      throw Exception('Failed to load RSS feed');
    }
  }

  Future<void> refreshAll() async {
    try {
      await fetchRssFeed();
      await fetchBarangay();
      await fetchRecent();
      await Future.delayed(Duration(seconds: 1));
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    fetchRssFeed();
    fetchBarangay();
    fetchRecent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refreshAll,
        child: ListView(
          children: [
            FutureBuilder(
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                                color: tcBlack,
                              ),
                            ),
                            Text(
                              '${items.lastname}, ${items.firstname}',
                              style: TextStyle(
                                fontFamily: 'PublicSans',
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                                color: tcBlack,
                              ),
                            ),
                          ],
                        ),
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
                            width: 50,
                            height: 50,
                            child: ClipOval(
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
            Divider(
              color: Colors.transparent,
              height: 10,
            ),
            Stack(
              children: [
                Positioned(
                  child: Container(
                    height: 100.h,
                    decoration: BoxDecoration(
                      color: tcViolet,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Positioned(
                  right: 95,
                  bottom: -1,
                  child: Image.asset(
                    'assets/images/phone.png',
                    scale: 9,
                  ),
                ),
                Positioned(
                  top: 15,
                  left: 15,
                  child: Text(
                    'Not feeling safe?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: tcWhite,
                      fontFamily: 'Roboto',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
                Positioned(
                  right: 15,
                  bottom: 15,
                  child: Container(
                    width: 80.w,
                    height: 30.h,
                    child: ElevatedButton(
                      onPressed: () async {
                        final Uri launchUri = Uri(
                          scheme: 'tel',
                          path: '123456789',
                        );
                        await launchUrl(launchUri);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: tcWhite,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: Text(
                        'Call Us',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: tcViolet,
                          fontFamily: 'Roboto',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Divider(
              color: Colors.transparent,
            ),
            Text(
              'Average Responses',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: tcBlack,
              ),
            ),
            Divider(
              color: Colors.transparent,
              height: 5,
            ),
            Container(
              width: double.infinity,
              height: 210.h,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: FutureBuilder(
                  future: fetchBarangay(),
                  builder: (context, snapshot) {
                    try {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          width: double.infinity,
                          height: 210.h,
                          color: tcAsh,
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
                        final data = filterDatabyResponse(items!.average!);
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            final item = data[index];
                            item.barangay!.image == null
                                ? imageUrl = null
                                : imageUrl = ApiConstants.baseUrl +
                                    item.barangay!.image!;
                            return InkWell(
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                width: 250.w,
                                height: 150.h,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(10)),
                                      child: Container(
                                        height: 150.h,
                                        width: double.infinity,
                                        child: Image.network(
                                          imageUrl!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.barangay!.name!,
                                              style: TextStyle(
                                                color: tcBlack,
                                                fontFamily: 'PublicSans',
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Text(
                                              'Average Response Time: ${item.responseTime!}',
                                              style: TextStyle(
                                                color: tcBlack,
                                                fontFamily: 'PublicSans',
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
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
                    } catch (e) {
                      print('Error in FutureBuilder: $e');
                      return Text('Error: $e');
                    }
                  },
                ),
              ),
            ),
            Divider(
              color: Colors.transparent,
            ),
            Text(
              'Recent Emergency',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: tcBlack,
              ),
            ),
            Text(
              'Tap to view details',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: tcGray,
              ),
            ),
            Divider(
              color: Colors.transparent,
              height: 5.h,
            ),
            FutureBuilder(
              future: Future.wait([fetchRecent(), calculateDistances()]),
              builder: (context, snapshot) {
                try {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      width: double.infinity,
                      height: 210.h,
                      color: tcAsh,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: tcViolet,
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    final data1 = snapshot.data![0] as RecentReportModel;
                    final data2 = snapshot.data![1] as String;
                    final items = data1;
                    return InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) {
                            return RecentReportDetail(recentReportModel: items);
                          },
                        );
                      },
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 130.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(10),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(10)),
                              child: Stack(
                                children: [
                                  map.FlutterMap(
                                    options: map.MapOptions(
                                        interactionOptions:
                                            map.InteractionOptions(
                                          flags: map.InteractiveFlag.none,
                                        ),
                                        initialCenter: LatLng(
                                            items.location!.coordinates!.first,
                                            items.location!.coordinates!.last),
                                        initialZoom: 17.0),
                                    children: [
                                      map.TileLayer(
                                        urlTemplate:
                                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                      ),
                                      map.MarkerLayer(
                                        markers: [
                                          map.Marker(
                                            width: 80.w,
                                            height: 80.h,
                                            point: LatLng(
                                                items.location!.coordinates!
                                                    .first,
                                                items.location!.coordinates!
                                                    .last),
                                            child: Icon(
                                              Icons.location_on,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            height: 80.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(10),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Distance: $data2',
                                  style: TextStyle(
                                    fontFamily: 'PublicSans',
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    color: tcBlack,
                                  ),
                                ),
                                Text(
                                  'Resolve in: ${items.responseTime}',
                                  style: TextStyle(
                                    fontFamily: 'PublicSans',
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    color: tcBlack,
                                  ),
                                ),
                                Text(
                                  'Date: ${formatCustomDateTime(items.createdAt.toString())}',
                                  style: TextStyle(
                                    fontFamily: 'PublicSans',
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    color: tcBlack,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
            Divider(
              color: Colors.transparent,
            ),
            Text(
              'Emergency Services',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: tcBlack,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () async {
                    final Uri launchUri = Uri(
                      scheme: 'tel',
                      path: '911',
                    );
                    await launchUrl(launchUri);
                  },
                  child: Container(
                    width: 80.w,
                    height: 100.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notification_important,
                          color: tcViolet,
                          size: 40,
                        ),
                        Divider(
                          color: Colors.transparent,
                          height: 5.h,
                        ),
                        Text(
                          'General',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: 'PublicSans',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: tcBlack,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    final Uri launchUri = Uri(
                      scheme: 'tel',
                      path: '143',
                    );
                    await launchUrl(launchUri);
                  },
                  child: Container(
                    width: 80.w,
                    height: 100.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.medical_services,
                          color: tcViolet,
                          size: 40,
                        ),
                        Divider(
                          color: Colors.transparent,
                          height: 5.h,
                        ),
                        Text(
                          'Medical',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: 'PublicSans',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: tcBlack,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    final Uri launchUri = Uri(
                      scheme: 'tel',
                      path: '160',
                    );
                    await launchUrl(launchUri);
                  },
                  child: Container(
                    width: 80.w,
                    height: 100.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.fire_extinguisher,
                          color: tcViolet,
                          size: 40,
                        ),
                        Divider(
                          color: Colors.transparent,
                          height: 5.h,
                        ),
                        Text(
                          'Fire',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: 'PublicSans',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: tcBlack,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    final Uri launchUri = Uri(
                      scheme: 'tel',
                      path: '117',
                    );
                    await launchUrl(launchUri);
                  },
                  child: Container(
                    width: 80.w,
                    height: 100.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.local_police,
                          color: tcViolet,
                          size: 40,
                        ),
                        Divider(
                          color: Colors.transparent,
                          height: 5.h,
                        ),
                        Text(
                          'Crime',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: 'PublicSans',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: tcBlack,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.transparent,
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'News and Updates',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: tcBlack,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        child: InkWell(
                          onTap: () async {
                            final Uri launchUri =
                                Uri.parse('https://www.manilatimes.net/news');
                            await launchUrl(launchUri);
                          },
                          child: Text(
                            'View More',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: tcViolet,
                            ),
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
                    height: 200.h,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: FutureBuilder<RssFeed>(
                        future: fetchRssFeed(),
                        builder: (context, snapshot) {
                          try {
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
                              final items = snapshot.data?.items;
                              return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: items!.length > 5 ? 5 : items.length,
                                itemBuilder: (context, index) {
                                  final item = items[index];
                                  final imageUrl =
                                      item.media!.contents.first.url;
                                  return InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        SlideUpAnimation(
                                          NewsDetails(
                                            item: item,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(right: 10),
                                      width: 190.w,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(10)),
                                            child: Container(
                                              width: 190.w,
                                              height: 100.h,
                                              child: Image.network(
                                                imageUrl!,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.all(8),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  AutoSizeText(
                                                    item.title ?? '',
                                                    maxLines: 2,
                                                    overflow: TextOverflow
                                                        .ellipsis, // Handle overflow with ellipsis
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      fontFamily: 'PublicSans',
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: tcBlack,
                                                    ),
                                                  ),
                                                  AutoSizeText(
                                                    formatDateTime(
                                                        item.pubDate!),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.visible,
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      fontFamily: 'PublicSans',
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: tcBlack,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
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
                          } catch (e) {
                            print('Error in FutureBuilder: $e');
                            return Text('Error: $e');
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
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
            backgroundColor: tcRed,
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

class NewsDetails extends StatelessWidget {
  final RssItem item;
  const NewsDetails({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final imageUrl = item.media!.contents.first.url;
    return Scaffold(
      backgroundColor: tcWhite,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: CloseButton(),
        iconTheme: IconThemeData(color: tcBlack),
        backgroundColor: tcWhite,
        elevation: 0,
        title: Text(
          'ARTICLE',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 20.sp,
              fontWeight: FontWeight.w900,
              color: tcBlack),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: ListView(
            children: [
              Container(
                height: 200.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: Container(
                    child: Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Divider(
                color: Colors.transparent,
              ),
              Container(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () async {
                    final Uri launchUri = Uri.parse(item.link!);
                    await launchUrl(launchUri);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tcViolet,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    'View on browser',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PublicSans',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: tcWhite,
                    ),
                  ),
                ),
              ),
              Divider(
                color: Colors.transparent,
              ),
              Text(
                item.title ?? '',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontFamily: 'PublicSans',
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: tcBlack,
                ),
              ),
              Text(
                item.dc?.creator ?? '',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontFamily: 'PublicSans',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.italic,
                  color: tcBlack,
                ),
              ),
              Text(
                formatDateTime(item.pubDate!),
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontFamily: 'PublicSans',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: tcBlack,
                ),
              ),
              Divider(
                color: Colors.transparent,
              ),
              html.Html(
                data: item.description,
                style: {
                  "p": html.Style(
                    fontSize: html.FontSize(14.sp),
                    fontWeight: FontWeight.w400,
                    color: tcBlack,
                  ),
                },
              ),
              Divider(
                color: Colors.transparent,
              ),
              Text(
                'End of article',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'PublicSans',
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: tcGray,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RecentReportDetail extends StatelessWidget {
  final RecentReportModel recentReportModel;
  const RecentReportDetail({super.key, required this.recentReportModel});

  @override
  Widget build(BuildContext context) {
    String? imageUrl;

    if (recentReportModel.image == null) {
      imageUrl = "";
    } else {
      imageUrl = ApiConstants.baseUrl + recentReportModel.image!;
    }
    return Container(
      height: 700.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Container(
                width: double.infinity,
                height: 200,
                child: Stack(
                  children: [
                    map.FlutterMap(
                      options: map.MapOptions(
                          interactionOptions: map.InteractionOptions(
                            flags: map.InteractiveFlag.none,
                          ),
                          //14.515170042710624, 121.05204474060577
                          initialCenter: LatLng(
                              recentReportModel.location!.coordinates!.first,
                              recentReportModel.location!.coordinates!.last),
                          initialZoom: 17.0),
                      children: [
                        map.TileLayer(
                          urlTemplate:
                              "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        ),
                        map.MarkerLayer(
                          markers: [
                            map.Marker(
                              width: 80.w,
                              height: 80.h,
                              point: LatLng(
                                  recentReportModel
                                      .location!.coordinates!.first,
                                  recentReportModel
                                      .location!.coordinates!.last),
                              child: Icon(
                                Icons.location_on,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.transparent,
                height: 10,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Details',
                      style: TextStyle(
                        color: tcBlack,
                        fontFamily: 'Roboto',
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Divider(
                      color: Colors.transparent,
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          child: imageUrl.isEmpty
                              ? Center(
                                  child: Container(
                                    width: 120,
                                    height: 120,
                                    color: tcAsh,
                                    child: Icon(
                                      Icons.question_mark,
                                      size: 50,
                                      color: tcBlack,
                                    ),
                                  ),
                                )
                              : Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        VerticalDivider(
                          color: Colors.transparent,
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Report ID',
                                    style: TextStyle(
                                      color: tcBlack,
                                      fontFamily: 'Roboto',
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    recentReportModel.id.toString(),
                                    style: TextStyle(
                                      color: tcBlack,
                                      fontFamily: 'PublicSans',
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                color: Colors.transparent,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Barangay ID',
                                    style: TextStyle(
                                      color: tcBlack,
                                      fontFamily: 'Roboto',
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    recentReportModel.barangayId ?? '',
                                    style: TextStyle(
                                      color: tcBlack,
                                      fontFamily: 'PublicSans',
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                color: Colors.transparent,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Emergency Type',
                                    style: TextStyle(
                                      color: tcBlack,
                                      fontFamily: 'Roboto',
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    recentReportModel.emergencyType ?? '',
                                    style: TextStyle(
                                      color: tcBlack,
                                      fontFamily: 'PublicSans',
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                color: Colors.transparent,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Casualties',
                                    style: TextStyle(
                                      color: tcBlack,
                                      fontFamily: 'Roboto',
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    recentReportModel.casualties == 'True'
                                        ? 'Yes'
                                        : 'No',
                                    style: TextStyle(
                                      color: tcBlack,
                                      fontFamily: 'PublicSans',
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.transparent,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'For Whom',
                          style: TextStyle(
                            color: tcBlack,
                            fontFamily: 'Roboto',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          recentReportModel.forWhom ?? '',
                          style: TextStyle(
                            color: tcBlack,
                            fontFamily: 'PublicSans',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.transparent,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Description',
                          style: TextStyle(
                            color: tcBlack,
                            fontFamily: 'Roboto',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Container(
                          width: 150,
                          child: AutoSizeText(
                            recentReportModel.description ?? '',
                            maxLines: 3,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontFamily: 'PublicSans',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: tcBlack,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.transparent,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Status',
                          style: TextStyle(
                            color: tcBlack,
                            fontFamily: 'Roboto',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          recentReportModel.isDone == 1 ? 'Done' : 'Pending',
                          style: TextStyle(
                            color: tcBlack,
                            fontFamily: 'PublicSans',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.transparent,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Created At',
                          style: TextStyle(
                            color: tcBlack,
                            fontFamily: 'Roboto',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          formatCustomDateTime(
                              recentReportModel.createdAt.toString()),
                          style: TextStyle(
                            color: tcBlack,
                            fontFamily: 'PublicSans',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.transparent,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Resolve Time',
                          style: TextStyle(
                            color: tcBlack,
                            fontFamily: 'Roboto',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          recentReportModel.responseTime ?? '',
                          style: TextStyle(
                            color: tcBlack,
                            fontFamily: 'PublicSans',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              onPressed: () async {
                final Uri launchUri = Uri.parse(
                    'https://maps.google.com/?q=${recentReportModel.location!.coordinates!.first},${recentReportModel.location!.coordinates!.last}');
                await launchUrl(launchUri);
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
                  fontFamily: 'PublicSans',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: tcWhite,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

List<Average> filterDatabyResponse(List<Average> data) {
  return data
      .where(
          (item) => item.resolvedReports != 0 && item.barangay!.image != null)
      .toList();
}

String formatDateTime(String input) {
  final inputFormat = DateFormat("E, d MMM y HH:mm:ss Z");
  final dateTime = inputFormat.parse(input);

  // Updated output format without 'PHT'
  final outputFormat = DateFormat("E, d MMM y hh:mma");
  final formattedDate = outputFormat.format(dateTime);

  return formattedDate;
}

String formatCustomDateTime(String input) {
  final inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss.SSS");
  final dateTime = inputFormat.parse(input);

  // Updated output format
  final outputFormat = DateFormat("E, d MMM y hh:mma");
  final formattedDate = outputFormat.format(dateTime);

  return formattedDate;
}
