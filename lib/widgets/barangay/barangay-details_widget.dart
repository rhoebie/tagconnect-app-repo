import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taguigconnect/constants/color_constant.dart';
import 'package:taguigconnect/models/barangay_model.dart';
import 'package:url_launcher/url_launcher.dart';

class BarangayDetailsWidget extends StatelessWidget {
  final BarangayModel barangayModel;
  final double? userLatitude;
  final double? userLongitude;
  const BarangayDetailsWidget(
      {super.key,
      required this.barangayModel,
      required this.userLatitude,
      required this.userLongitude});

  @override
  Widget build(BuildContext context) {
    double barWidth = 15.0;
    double general = 0.0;
    double medical = 0.0;
    double fire = 0.0;
    double crime = 0.0;

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
              final Uri launchUri = Uri.parse(
                  'https://maps.google.com/?q=${barangayModel.location!.latitude!},${barangayModel.location!.longitude!}');
              await launchUrl(launchUri);
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
                              barangayModel.name ?? '',
                              style: TextStyle(
                                fontFamily: 'PublicSans',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: tcBlack,
                              ),
                            ),
                            Text(
                              'District: ${barangayModel.district}',
                              style: TextStyle(
                                fontFamily: 'PublicSans',
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: tcBlack,
                              ),
                            ),
                            Text(
                              'Contact: ${barangayModel.contact}',
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
                                'Address: ${barangayModel.address}',
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
                        barangayModel.image != null
                            ? CircleAvatar(
                                radius: 40,
                                child: ClipOval(
                                  child: Image.network(
                                    barangayModel.image!,
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
                                barangayModel.analytics!.general == null
                                    ? general.toInt().toString()
                                    : barangayModel.analytics!.general!
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
                                barangayModel.analytics!.medical == null
                                    ? medical.toInt().toString()
                                    : barangayModel.analytics!.medical!
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
                                barangayModel.analytics!.fire == null
                                    ? fire.toInt().toString()
                                    : barangayModel.analytics!.fire!
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
                                barangayModel.analytics!.crime == null
                                    ? crime.toInt().toString()
                                    : barangayModel.analytics!.crime!
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
                                    toY:
                                        barangayModel.analytics!.general == null
                                            ? general
                                            : barangayModel.analytics!.general!
                                                .toDouble(),
                                    color: tcOrange,
                                    width: barWidth)
                              ]),
                              BarChartGroupData(x: 1, barRods: [
                                BarChartRodData(
                                    toY:
                                        barangayModel.analytics!.medical == null
                                            ? medical
                                            : barangayModel.analytics!.medical!
                                                .toDouble(),
                                    color: tcGreen,
                                    width: barWidth)
                              ]),
                              BarChartGroupData(x: 2, barRods: [
                                BarChartRodData(
                                    toY: barangayModel.analytics!.fire == null
                                        ? fire
                                        : barangayModel.analytics!.fire!
                                            .toDouble(),
                                    color: tcRed,
                                    width: barWidth)
                              ]),
                              BarChartGroupData(x: 3, barRods: [
                                BarChartRodData(
                                    toY: barangayModel.analytics!.crime == null
                                        ? crime
                                        : barangayModel.analytics!.crime!
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
                        'This shows the total count of each report type for ${barangayModel.name}',
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
