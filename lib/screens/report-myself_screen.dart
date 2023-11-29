import 'package:TagConnect/configs/request_service.dart';
import 'package:TagConnect/constants/barangay_constant.dart';
import 'package:TagConnect/constants/color_constant.dart';
import 'package:TagConnect/models/create-report_model.dart';
import 'package:TagConnect/services/report_service.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';

class MyselfWidget extends StatefulWidget {
  const MyselfWidget({super.key});

  @override
  State<MyselfWidget> createState() => _MyselfWidgetState();
}

class _MyselfWidgetState extends State<MyselfWidget> {
  String? locationData;
  double? userLatitude;
  double? userLongitude;
  bool isLoading = false;

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
      setState(() {
        isLoading = true;
      });
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
        setState(() {
          isLoading = false;
        });
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tcWhite,
      body: Center(
        child: isLoading != false
            ? CircularProgressIndicator()
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
                            'Tap to Send',
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
    );
  }
}
