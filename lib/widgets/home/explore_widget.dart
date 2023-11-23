import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:TagConnect/constants/barangay_constant.dart';
import 'package:TagConnect/constants/calculate_constant.dart';
import 'package:TagConnect/constants/color_constant.dart';
import 'package:TagConnect/constants/endpoint_constant.dart';
import 'package:TagConnect/models/barangay-response_model.dart';
import 'package:TagConnect/models/emergency-type_model.dart';
import 'package:http/http.dart' as http;
import 'package:TagConnect/screens/barangay-list_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class ExploreWidget extends StatefulWidget {
  const ExploreWidget({super.key});

  @override
  State<ExploreWidget> createState() => _ExploreWidgetState();
}

class _ExploreWidgetState extends State<ExploreWidget> {
  double barWidth = 15.0;
  double circleWidth = 30.0;
  double circleHeight = 30.0;
  double? userLatitude;
  double? userLongitude;
  double general = 0.0;
  double medical = 0.0;
  double fire = 0.0;
  double crime = 0.0;
  String? imageUrl;

  Future<Position?> fetchLocation() async {
    return null;
  }

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

  Future<EmergencyType?> fetchStat() async {
    const apiUrl = 'https://taguigconnect.online/api/barangay-reports';
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final barangayConstant = BarangayConstant();
    LocationChecker locationChecker;
    LocationService locationService;
    locationChecker = LocationChecker(
      barangayConstant.cityTaguig,
      barangayConstant.taguigBarangays,
    );

    locationService = LocationService(locationChecker);

    try {
      final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
      final Position position = await geolocator.getCurrentPosition(
        locationSettings: AndroidSettings(accuracy: LocationAccuracy.best),
      );

      userLatitude = position.latitude;
      userLongitude = position.longitude;
      print('Latitude: $userLatitude, Longitude: $userLongitude');

      final locationIdk =
          await locationService.getUserLocation(userLatitude!, userLongitude!);
      var value = locationIdk['value'];
      final token = prefs.getString('token');

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode({
          'barangayName': value,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return EmergencyType.fromJson(data);
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
        return null;
      }
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
          'Accept': 'application/json'
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

  Future<void> refreshAll() async {
    try {
      await fetchStat();
      await fetchBarangay();
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
    fetchStat();
    fetchBarangay();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshAll,
      child: ListView(
        children: [
          Text(
            'Statistics',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: tcBlack,
            ),
          ),
          Divider(
            color: Colors.transparent,
            height: 5.h,
          ),
          Container(
            width: double.infinity,
            height: 380.h,
            child: FutureBuilder(
              future: fetchStat(),
              builder: (context, snapshot) {
                try {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      width: double.infinity,
                      height: 380.h,
                      color: tcAsh,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: tcViolet,
                          ),
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    final items = snapshot.data;
                    if (items != null) {
                      return Container(
                        width: double.infinity,
                        height: 380.h,
                        color: Colors.white,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        items.type!.general == null
                                            ? general.toInt().toString()
                                            : items.type!.general!
                                                .toInt()
                                                .toString(),
                                        style: TextStyle(
                                          fontFamily: 'PublicSans',
                                          fontSize: 25.sp,
                                          fontWeight: FontWeight.w900,
                                          color: Color(0xFFFFEB3B),
                                        ),
                                      ),
                                      Divider(
                                        color: Colors.transparent,
                                        height: 5,
                                      ),
                                      Text(
                                        'General',
                                        style: TextStyle(
                                          fontFamily: 'PublicSans',
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                          color: tcBlack,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        items.type!.medical == null
                                            ? medical.toInt().toString()
                                            : items.type!.medical!
                                                .toInt()
                                                .toString(),
                                        style: TextStyle(
                                          fontFamily: 'PublicSans',
                                          fontSize: 25.sp,
                                          fontWeight: FontWeight.w900,
                                          color: Color(0xFF4CAF50),
                                        ),
                                      ),
                                      Divider(
                                        color: Colors.transparent,
                                        height: 5,
                                      ),
                                      Text(
                                        'Medical',
                                        style: TextStyle(
                                          fontFamily: 'PublicSans',
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                          color: tcBlack,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        items.type!.fire == null
                                            ? fire.toInt().toString()
                                            : items.type!.fire!
                                                .toInt()
                                                .toString(),
                                        style: TextStyle(
                                          fontFamily: 'PublicSans',
                                          fontSize: 25.sp,
                                          fontWeight: FontWeight.w900,
                                          color: Color(0xFFF44336),
                                        ),
                                      ),
                                      Divider(
                                        color: Colors.transparent,
                                        height: 5,
                                      ),
                                      Text(
                                        'Fire',
                                        style: TextStyle(
                                          fontFamily: 'PublicSans',
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                          color: tcBlack,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        items.type!.crime == null
                                            ? crime.toInt().toString()
                                            : items.type!.crime!
                                                .toInt()
                                                .toString(),
                                        style: TextStyle(
                                          fontFamily: 'PublicSans',
                                          fontSize: 25.sp,
                                          fontWeight: FontWeight.w900,
                                          color: Color(0xFF2196F3),
                                        ),
                                      ),
                                      Divider(
                                        color: Colors.transparent,
                                        height: 5,
                                      ),
                                      Text(
                                        'Crime',
                                        style: TextStyle(
                                          fontFamily: 'PublicSans',
                                          fontSize: 14.sp,
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
                                height: 20.h,
                              ),
                              Container(
                                width: double.infinity,
                                height: 200,
                                child: BarChart(
                                  BarChartData(
                                    barGroups: [
                                      BarChartGroupData(x: 0, barRods: [
                                        BarChartRodData(
                                            toY: items.type!.general == null
                                                ? general
                                                : items.type!.general!
                                                    .toDouble(),
                                            color: Color(0xFFFFEB3B),
                                            width: barWidth)
                                      ]),
                                      BarChartGroupData(x: 1, barRods: [
                                        BarChartRodData(
                                            toY: items.type!.medical == null
                                                ? medical
                                                : items.type!.medical!
                                                    .toDouble(),
                                            color: Color(0xFF4CAF50),
                                            width: barWidth)
                                      ]),
                                      BarChartGroupData(x: 2, barRods: [
                                        BarChartRodData(
                                            toY: items.type!.fire == null
                                                ? fire
                                                : items.type!.fire!.toDouble(),
                                            color: Color(0xFFF44336),
                                            width: barWidth)
                                      ]),
                                      BarChartGroupData(x: 3, barRods: [
                                        BarChartRodData(
                                            toY: items.type!.crime == null
                                                ? crime
                                                : items.type!.crime!.toDouble(),
                                            color: Color(0xFF2196F3),
                                            width: barWidth)
                                      ]),
                                    ],
                                    barTouchData: BarTouchData(enabled: false),
                                    borderData: FlBorderData(show: false),
                                    titlesData: FlTitlesData(
                                      topTitles: AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false),
                                      ),
                                      bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: false,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Divider(
                                color: Colors.transparent,
                                height: 20.h,
                              ),
                              Text(
                                '${items.barangay} shows the total count of each report type based on your location',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'PublicSans',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: tcGray,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Center(
                        child: Text('No data available'),
                      );
                    }
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
            'Safety Tips and Resources',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: tcBlack,
            ),
          ),
          Divider(
            color: Colors.transparent,
            height: 5.h,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                          padding: EdgeInsets.all(15),
                          height: 500.h,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'GENERAL',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w900,
                                  color: tcBlack,
                                ),
                              ),
                              Divider(
                                color: Colors.transparent,
                              ),
                              Text(
                                'Safety Tips',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                  color: tcBlack,
                                ),
                              ),
                              Divider(
                                color: Colors.transparent,
                                height: 5.h,
                              ),
                              Text(
                                '1. Stay Calm: In a general emergency, it\'s essential to remain calm and composed to make rational decisions.\n'
                                '2. Assess the Situation: Determine the nature and extent of the emergency and the potential risks.\n'
                                '3. Call for Help: Contact emergency services, such as 911, and provide them with as much information as possible.\n'
                                '4. Follow Instructions: If authorities issue instructions or evacuation orders, follow them promptly.\n'
                                '5. Help Others: Assist those in need, particularly vulnerable individuals, including the elderly, children, and people with disabilities.',
                                style: TextStyle(
                                  fontFamily: 'PublicSans',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                              Divider(
                                color: Colors.transparent,
                              ),
                              Text(
                                'Resources',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                  color: tcBlack,
                                ),
                              ),
                              Divider(
                                color: Colors.transparent,
                                height: 5.h,
                              ),
                              Text(
                                '1. Local Emergency Services: Know the contact information for local emergency services, including fire, police, and medical services.\n'
                                '2. Emergency Alert Systems: Register for local emergency alert systems to receive notifications about critical situations in your area.\n'
                                '3. First Aid Kits: Maintain a well-equipped first aid kit at home and learn basic first aid techniques.',
                                style: TextStyle(
                                  fontFamily: 'PublicSans',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notification_important,
                          color: tcBlack,
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
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                          padding: EdgeInsets.all(15),
                          height: 500.h,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'MEDICAL',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w900,
                                  color: tcBlack,
                                ),
                              ),
                              Divider(
                                color: Colors.transparent,
                              ),
                              Text(
                                'Safety Tips',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                  color: tcBlack,
                                ),
                              ),
                              Divider(
                                color: Colors.transparent,
                                height: 5.h,
                              ),
                              Text(
                                '1. Call for Medical Assistance: Dial 911 or your local emergency number immediately.\n'
                                '2. Provide First Aid: If you have basic first aid knowledge, administer aid while waiting for professionals.\n'
                                '3. Stay with the Injured: Do not leave an injured person alone; provide comfort and reassurance.\n'
                                '4. Communicate Clearly: Provide accurate information to the dispatcher and medical professionals.\n'
                                '5. Prevent Further Injury: Take steps to prevent the situation from worsening.',
                                style: TextStyle(
                                  fontFamily: 'PublicSans',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                              Divider(
                                color: Colors.transparent,
                              ),
                              Text(
                                'Resources',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                  color: tcBlack,
                                ),
                              ),
                              Divider(
                                color: Colors.transparent,
                                height: 5.h,
                              ),
                              Text(
                                '1. First Aid Training: Consider taking a first aid and CPR course to be better prepared for medical emergencies.\n'
                                '2. Medical Alert Systems: For individuals with medical conditions, wearable medical alert devices can be invaluable.\n'
                                '3. Know Your Health Providers: Maintain a list of your doctors and healthcare providers\' contact information.',
                                style: TextStyle(
                                  fontFamily: 'PublicSans',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.medical_services,
                          color: tcBlack,
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
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                          padding: EdgeInsets.all(15),
                          height: 500.h,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'FIRE',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w900,
                                  color: tcBlack,
                                ),
                              ),
                              Divider(
                                color: Colors.transparent,
                              ),
                              Text(
                                'Safety Tips',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                  color: tcBlack,
                                ),
                              ),
                              Divider(
                                color: Colors.transparent,
                                height: 5.h,
                              ),
                              Text(
                                '1. Evacuate Safely: If there\'s a fire, prioritize your safety and evacuate the area immediately.\n'
                                '2. Crawl Low: In a smoke-filled environment, stay close to the ground to avoid inhaling smoke.\n'
                                '3. Call 911: Report the fire to emergency services.\n'
                                '4. Use Fire Extinguishers: If trained and it\'s safe to do so, use a fire extinguisher to control small fires.\n'
                                '5. Don\'t Reenter: Do not reenter a burning building; wait for firefighters to arrive.',
                                style: TextStyle(
                                  fontFamily: 'PublicSans',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                              Divider(
                                color: Colors.transparent,
                              ),
                              Text(
                                'Resources',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                  color: tcBlack,
                                ),
                              ),
                              Divider(
                                color: Colors.transparent,
                                height: 5.h,
                              ),
                              Text(
                                '1. Fire Safety Education: Educate yourself and your family on fire safety and prevention measures.\n'
                                '2. Smoke Detectors: Install and maintain smoke detectors in your home.\n'
                                '3. Fire Escape Plan: Create a fire escape plan with your family and practice it regularly.',
                                style: TextStyle(
                                  fontFamily: 'PublicSans',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.fire_extinguisher,
                          color: tcBlack,
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
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                          padding: EdgeInsets.all(15),
                          height: 500.h,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'CRIME',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w900,
                                  color: tcBlack,
                                ),
                              ),
                              Divider(
                                color: Colors.transparent,
                              ),
                              Text(
                                'Safety Tips',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                  color: tcBlack,
                                ),
                              ),
                              Divider(
                                color: Colors.transparent,
                                height: 5.h,
                              ),
                              Text(
                                '1. Personal Safety: Be aware of your surroundings and trust your instincts in unfamiliar or potentially dangerous situations.\n'
                                '2. Avoid Risky Areas: Stay away from poorly lit or isolated areas, especially at night.\n'
                                '3. Use Technology Safely: Be cautious when sharing personal information online and avoid meeting strangers from the internet alone.\n'
                                '4. Self-Defense: Consider self-defense training to enhance your personal safety skills.\n'
                                '5. Report Suspicious Activity: If you witness a crime or suspicious activity, report it to the police.',
                                style: TextStyle(
                                  fontFamily: 'PublicSans',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                              Divider(
                                color: Colors.transparent,
                              ),
                              Text(
                                'Resources',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                  color: tcBlack,
                                ),
                              ),
                              Divider(
                                color: Colors.transparent,
                                height: 5.h,
                              ),
                              Text(
                                '1. Local Law Enforcement: Know how to contact your local police department or law enforcement agency.\n'
                                '2. Crime Prevention Programs: Many communities offer crime prevention programs and resources to help residents stay safe.\n'
                                '3. Neighborhood Watch: Participate in or start a neighborhood watch program to enhance community safety.',
                                style: TextStyle(
                                  fontFamily: 'PublicSans',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.local_police,
                          color: tcBlack,
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
          ),
          Divider(
            color: Colors.transparent,
          ),
          Text(
            'Barangay',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: tcBlack,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Tap to view direction',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: tcGray,
                ),
              ),
              Container(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return BarangayListScreen();
                        },
                      ),
                    );
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
            width: double.infinity,
            height: 280,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: FutureBuilder(
                future: Future.wait([fetchBarangay(), calculateDistances()]),
                builder: (context, snapshot) {
                  try {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        width: double.infinity,
                        height: 280,
                        color: tcAsh,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: tcViolet,
                            ),
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      final data1 = snapshot.data![0] as AverageReportModel;
                      final List<String> data2 =
                          snapshot.data![1] as List<String>;
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          final item = data1.average![index];
                          final distance = data2[index];
                          item.barangay!.image == null
                              ? imageUrl = null
                              : imageUrl =
                                  ApiConstants.baseUrl + item.barangay!.image!;
                          return InkWell(
                            onTap: () async {
                              if (userLatitude != null &&
                                  userLongitude != null) {
                                final Uri launchUri = Uri.parse(
                                    'https://www.google.com/maps/dir/$userLatitude, $userLongitude/${item.barangay!.location!.latitude!},${item.barangay!.location!.longitude!}');
                                await launchUrl(launchUri);
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 10),
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
                                  ClipRRect(
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
                                          Text(
                                            'Contact: ${item.barangay!.contact}',
                                            style: TextStyle(
                                              color: tcBlack,
                                              fontFamily: 'PublicSans',
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          AutoSizeText(
                                            'Address: ${item.barangay!.address!}',
                                            maxLines: 3,
                                            overflow: TextOverflow
                                                .clip, // Handle overflow with ellipsis
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              color: tcBlack,
                                              fontFamily: 'PublicSans',
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Text(
                                            'Resolve reports: ${item.resolvedReports ?? ''}',
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
        ],
      ),
    );
  }
}
