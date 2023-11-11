import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taguigconnect/constants/calculate_constant.dart';
import 'package:taguigconnect/constants/color_constant.dart';
import 'package:taguigconnect/constants/endpoint_constant.dart';
import 'package:taguigconnect/models/barangay-response_model.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class BarangayListScreen extends StatefulWidget {
  const BarangayListScreen({super.key});

  @override
  State<BarangayListScreen> createState() => _BarangayListScreenState();
}

class _BarangayListScreenState extends State<BarangayListScreen> {
  double? userLatitude;
  double? userLongitude;
  String? imageUrl;

  Future<List<String>?> calculateDistances() async {
    List<String> distances = [];

    try {
      final AverageReportModel? averageReportModel = await fetchBarangay();

      final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
      final Position position = await geolocator.getCurrentPosition(
        locationSettings: AndroidSettings(accuracy: LocationAccuracy.best),
      );

      userLatitude = position.latitude;
      userLongitude = position.longitude;

      if (averageReportModel != null && averageReportModel.average != null) {
        // Access the list of Average objects
        List<Average>? averageList = averageReportModel.average;

        if (averageList != null && averageList.isNotEmpty) {
          // Access individual Average objects
          for (Average average in averageList) {
            if (average.barangay != null) {
              final distanceReport = HaversineCalculator.calculateDistance(
                  userLatitude!,
                  userLongitude!,
                  average.barangay!.location!.latitude!,
                  average.barangay!.location!.longitude!);

              distances.add(distanceReport);
            }
          }
        }
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }

    return distances;
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    fetchBarangay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tcWhite,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: CloseButton(),
        iconTheme: const IconThemeData(color: tcBlack),
        backgroundColor: tcWhite,
        elevation: 0,
        title: Text(
          'BARANGAY',
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
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Expanded(
                child: FutureBuilder(
                  future: Future.wait([fetchBarangay(), calculateDistances()]),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: tcViolet,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      final data1 = snapshot.data![0] as AverageReportModel;
                      final List<String> data2 =
                          snapshot.data![1] as List<String>;
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: .7,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 10,
                        ),
                        itemCount: data1.average!.length,
                        itemBuilder: (context, index) {
                          final item = data1.average![index];
                          final distance = data2[index];
                          item.barangay!.image == null
                              ? imageUrl = null
                              : imageUrl =
                                  ApiConstants.baseUrl + item.barangay!.image!;

                          return InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) {
                                  return BarangayDetailWidget(
                                      barangayModel: item,
                                      userLatitude: userLatitude,
                                      userLongitude: userLongitude);
                                },
                              );
                            },
                            child: Container(
                              width: 200.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(10)),
                                      child: Container(
                                        color: tcAsh,
                                        height: 150.h,
                                        width: double.infinity,
                                        child: imageUrl == null
                                            ? Center(
                                                child: Icon(
                                                  Icons.question_mark,
                                                  size: 50,
                                                  color: tcBlack,
                                                ),
                                              )
                                            : Image.network(
                                                imageUrl!,
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                          AutoSizeText(
                                            'Address: ${item.barangay!.address!}',
                                            maxLines: 3,
                                            overflow: TextOverflow
                                                .ellipsis, // Handle overflow with ellipsis
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              color: tcBlack,
                                              fontFamily: 'PublicSans',
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Text(
                                            'Distance: $distance',
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
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BarangayDetailWidget extends StatelessWidget {
  final Average barangayModel;
  final double? userLatitude;
  final double? userLongitude;
  const BarangayDetailWidget(
      {super.key,
      required this.barangayModel,
      required this.userLatitude,
      required this.userLongitude});

  @override
  Widget build(BuildContext context) {
    String? imageUrl;

    if (barangayModel.barangay!.image == null) {
      imageUrl = "";
    } else {
      imageUrl = ApiConstants.baseUrl + barangayModel.barangay!.image!;
    }

    return Container(
      padding: EdgeInsets.only(bottom: 10),
      height: 600.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 200,
                child: imageUrl.isEmpty
                    ? Center(
                        child: Icon(
                          Icons.question_mark,
                          size: 50,
                          color: tcBlack,
                        ),
                      )
                    : Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                      ),
              ),
              Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          barangayModel.barangay!.name!,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: tcBlack,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'District: ',
                              style: TextStyle(
                                fontFamily: 'PublicSans',
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: tcBlack,
                              ),
                            ),
                            Text(
                              barangayModel.barangay!.district.toString(),
                              style: TextStyle(
                                fontFamily: 'PublicSans',
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                                color: tcBlack,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.transparent,
                    ),
                    Text(
                      'Contact',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: tcBlack,
                      ),
                    ),
                    Text(
                      barangayModel.barangay!.contact!,
                      style: TextStyle(
                        fontFamily: 'PublicSans',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: tcBlack,
                      ),
                    ),
                    Divider(
                      color: Colors.transparent,
                    ),
                    Text(
                      'Address',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: tcBlack,
                      ),
                    ),
                    Text(
                      barangayModel.barangay!.address!,
                      style: TextStyle(
                        fontFamily: 'PublicSans',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: tcBlack,
                      ),
                    ),
                    Divider(
                      color: Colors.transparent,
                    ),
                    Text(
                      'Response Time',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: tcBlack,
                      ),
                    ),
                    Text(
                      barangayModel.responseTime!,
                      style: TextStyle(
                        fontFamily: 'PublicSans',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: tcBlack,
                      ),
                    ),
                    Divider(
                      color: Colors.transparent,
                    ),
                    Text(
                      'Total Resolve Reports',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: tcBlack,
                      ),
                    ),
                    Text(
                      barangayModel.resolvedReports.toString(),
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
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              onPressed: () async {
                if (userLatitude != null && userLongitude != null) {
                  final Uri launchUri = Uri.parse(
                      'https://www.google.com/maps/dir/$userLatitude, $userLongitude/${barangayModel.barangay!.location!.latitude!},${barangayModel.barangay!.location!.longitude!}');
                  await launchUrl(launchUri);
                }
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
