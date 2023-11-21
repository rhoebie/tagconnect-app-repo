import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:taguigconnect/configs/request_service.dart';
import 'package:taguigconnect/constants/color_constant.dart';
import 'package:taguigconnect/models/barangay_model.dart';
import 'package:url_launcher/url_launcher.dart';

class BarangayDetailsWidget extends StatefulWidget {
  final BarangayModel barangayModel;
  const BarangayDetailsWidget({
    super.key,
    required this.barangayModel,
  });

  @override
  State<BarangayDetailsWidget> createState() => _BarangayDetailsWidgetState();
}

class _BarangayDetailsWidgetState extends State<BarangayDetailsWidget> {
  double barWidth = 15.0;
  double general = 0.0;
  double medical = 0.0;
  double fire = 0.0;
  double crime = 0.0;
  double? userLatitude;
  double? userLongitude;

  Future<void> getDistance() async {
    bool locationPermission = await RequestService.locationPermission();

    if (locationPermission) {
      try {
        showWaitSnackBar(context);
        final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
        final Position position = await geolocator.getCurrentPosition(
          locationSettings: AndroidSettings(accuracy: LocationAccuracy.best),
        );
        setState(() {
          userLatitude = position.latitude;
          userLongitude = position.longitude;
        });
      } catch (e) {
        print('Error: $e');
      }
    } else {
      Navigator.pop(context);
    }
  }

  void showWaitSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          CircularProgressIndicator(),
          SizedBox(width: 16),
          Text('Please Wait: Getting location'),
        ],
      ),
      duration: Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
        actions: [
          IconButton(
            onPressed: () async {
              await getDistance();
              if (userLatitude != null && userLongitude != null) {
                final Uri launchUri = Uri.parse(
                    'https://www.google.com/maps/dir/$userLatitude, $userLongitude/${widget.barangayModel.location!.latitude!},${widget.barangayModel.location!.longitude!}');
                await launchUrl(launchUri);
              }
            },
            icon: Icon(
              Icons.map,
              color: tcBlack,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.barangayModel.name ?? '',
                              style: TextStyle(
                                fontFamily: 'PublicSans',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: tcBlack,
                              ),
                            ),
                            Text(
                              'District: ${widget.barangayModel.district}',
                              style: TextStyle(
                                fontFamily: 'PublicSans',
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: tcBlack,
                              ),
                            ),
                            Text(
                              'Contact: ${widget.barangayModel.contact}',
                              style: TextStyle(
                                fontFamily: 'PublicSans',
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: tcBlack,
                              ),
                            ),
                            Container(
                              width: 200,
                              child: Text(
                                'Address: ${widget.barangayModel.address}',
                                style: TextStyle(
                                  fontFamily: 'PublicSans',
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: tcBlack,
                                ),
                              ),
                            ),
                          ],
                        ),
                        widget.barangayModel.image != null
                            ? CircleAvatar(
                                radius: 40,
                                child: ClipOval(
                                  child: Image.network(
                                    widget.barangayModel.image!,
                                  ),
                                ),
                              )
                            : CircleAvatar(
                                radius: 40,
                                backgroundColor: tcAsh,
                                child: ClipOval(
                                  child: Icon(
                                    Icons.question_mark,
                                    size: 40,
                                    color: tcBlack,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                widget.barangayModel.analytics!.general == null
                                    ? general.toInt().toString()
                                    : widget.barangayModel.analytics!.general!
                                        .toInt()
                                        .toString(),
                                style: TextStyle(
                                  fontFamily: 'PublicSans',
                                  fontSize: 25.sp,
                                  fontWeight: FontWeight.w900,
                                  color: tcOrange,
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
                                widget.barangayModel.analytics!.medical == null
                                    ? medical.toInt().toString()
                                    : widget.barangayModel.analytics!.medical!
                                        .toInt()
                                        .toString(),
                                style: TextStyle(
                                  fontFamily: 'PublicSans',
                                  fontSize: 25.sp,
                                  fontWeight: FontWeight.w900,
                                  color: tcGreen,
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
                                widget.barangayModel.analytics!.fire == null
                                    ? fire.toInt().toString()
                                    : widget.barangayModel.analytics!.fire!
                                        .toInt()
                                        .toString(),
                                style: TextStyle(
                                  fontFamily: 'PublicSans',
                                  fontSize: 25.sp,
                                  fontWeight: FontWeight.w900,
                                  color: tcRed,
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
                                widget.barangayModel.analytics!.crime == null
                                    ? crime.toInt().toString()
                                    : widget.barangayModel.analytics!.crime!
                                        .toInt()
                                        .toString(),
                                style: TextStyle(
                                  fontFamily: 'PublicSans',
                                  fontSize: 25.sp,
                                  fontWeight: FontWeight.w900,
                                  color: tcBlue,
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
                                    toY: widget.barangayModel.analytics!
                                                .general ==
                                            null
                                        ? general
                                        : widget
                                            .barangayModel.analytics!.general!
                                            .toDouble(),
                                    color: tcOrange,
                                    width: barWidth)
                              ]),
                              BarChartGroupData(x: 1, barRods: [
                                BarChartRodData(
                                    toY: widget.barangayModel.analytics!
                                                .medical ==
                                            null
                                        ? medical
                                        : widget
                                            .barangayModel.analytics!.medical!
                                            .toDouble(),
                                    color: tcGreen,
                                    width: barWidth)
                              ]),
                              BarChartGroupData(x: 2, barRods: [
                                BarChartRodData(
                                    toY: widget.barangayModel.analytics!.fire ==
                                            null
                                        ? fire
                                        : widget.barangayModel.analytics!.fire!
                                            .toDouble(),
                                    color: tcRed,
                                    width: barWidth)
                              ]),
                              BarChartGroupData(x: 3, barRods: [
                                BarChartRodData(
                                    toY: widget.barangayModel.analytics!
                                                .crime ==
                                            null
                                        ? crime
                                        : widget.barangayModel.analytics!.crime!
                                            .toDouble(),
                                    color: tcBlue,
                                    width: barWidth)
                              ]),
                            ],
                            barTouchData: BarTouchData(enabled: false),
                            borderData: FlBorderData(show: false),
                            titlesData: FlTitlesData(
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
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
                        'This shows the total count of each report type for ${widget.barangayModel.name}',
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
