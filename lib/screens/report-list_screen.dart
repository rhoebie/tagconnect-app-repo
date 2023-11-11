import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:taguigconnect/constants/color_constant.dart';
import 'package:taguigconnect/constants/endpoint_constant.dart';
import 'package:taguigconnect/models/report_model.dart';
import 'package:taguigconnect/services/report_service.dart';
import 'package:flutter_map/flutter_map.dart' as map;
import 'package:url_launcher/url_launcher.dart';

class ReportListScreen extends StatefulWidget {
  const ReportListScreen({super.key});

  @override
  State<ReportListScreen> createState() => _ReportListScreenState();
}

class _ReportListScreenState extends State<ReportListScreen> {
  String selectedValue = "Pending";
  int? reportCount;

  Future<List<ReportModel>> fetchReport() async {
    try {
      final reportService = ReportService();
      final List<ReportModel> fetchReportData =
          await reportService.getReports();
      reportCount = fetchReportData.length;
      return fetchReportData;
    } catch (e) {
      print('Error fetching barangayData: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tcWhite,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: tcBlack),
        backgroundColor: tcWhite,
        elevation: 0,
        title: Text(
          'REPORTS',
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
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: FutureBuilder(
            future: fetchReport(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: tcViolet,
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: tcGray,
                      fontFamily: 'PublisSans',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                );
              } else if (snapshot.hasData) {
                final data = snapshot.data;
                final filteredData = filterDataByStatus(data!, selectedValue);

                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Overall Reports',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: tcBlack,
                                fontFamily: 'Roboto',
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Divider(
                              color: Colors.transparent,
                              height: 10,
                            ),
                            Text(
                              data.length.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: tcBlack,
                                fontFamily: 'PublicSans',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Filter By',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: tcBlack,
                                fontFamily: 'Roboto',
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 80.w,
                              child: DropdownButton<String>(
                                value: selectedValue,
                                items: [
                                  DropdownMenuItem<String>(
                                    value: "Pending",
                                    child: Text(
                                      'Pending',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: tcBlack,
                                        fontFamily: 'PublicSans',
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: "Done",
                                    child: Text(
                                      'Done',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: tcBlack,
                                        fontFamily: 'PublicSans',
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedValue = newValue!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.transparent,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredData.length,
                        itemBuilder: (context, index) {
                          final item = filteredData[index];
                          if (filteredData.isEmpty) {
                            return Center(
                              child: Text(
                                'You dont have a pending report',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: tcGray,
                                  fontFamily: 'PublisSans',
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            );
                          } else {
                            return Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (context) {
                                        return ReportDetails(reportModel: item);
                                      },
                                    );
                                  },
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    width: double.infinity,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              item.barangayId!,
                                              style: TextStyle(
                                                fontFamily: 'PublicSans',
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w700,
                                                color: tcBlack,
                                              ),
                                            ),
                                            Text(
                                              'Status: ${item.isDone!}',
                                              style: TextStyle(
                                                fontFamily: 'PublicSans',
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w400,
                                                color: tcBlack,
                                              ),
                                            ),
                                            Text(
                                              formatCustomDateTime(
                                                  item.createdAt.toString()),
                                              style: TextStyle(
                                                fontFamily: 'PublicSans',
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w400,
                                                color: tcBlack,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Icon(
                                          Icons.file_open_rounded,
                                          size: 30,
                                          color: tcBlack,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ),
                  ],
                );
              } else {
                return Center(
                  child: Text(
                    'No data available',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: tcGray,
                      fontFamily: 'PublisSans',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class ReportDetails extends StatelessWidget {
  final ReportModel reportModel;
  const ReportDetails({super.key, required this.reportModel});

  @override
  Widget build(BuildContext context) {
    String? imageUrl;

    if (reportModel.image == null) {
      imageUrl = "";
    } else {
      imageUrl = ApiConstants.baseUrl + reportModel.image!;
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
                          initialCenter: LatLng(reportModel.location!.latitude!,
                              reportModel.location!.longitude!),
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
                              point: LatLng(reportModel.location!.latitude!,
                                  reportModel.location!.longitude!),
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
                                    reportModel.id.toString(),
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
                                    reportModel.barangayId ?? '',
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
                                    reportModel.emergencyType ?? '',
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
                                    reportModel.casualties == 'True'
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
                          reportModel.forWhom ?? '',
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
                            reportModel.description ?? '',
                            maxLines: 3,
                            overflow: TextOverflow
                                .ellipsis, // Handle overflow with ellipsis
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
                          reportModel.isDone ?? '',
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
                              reportModel.createdAt.toString()),
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
                          calculateTimeInterval(reportModel.createdAt!,
                                  reportModel.updatedAt!)
                              .toString(),
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
                    'https://maps.google.com/?q=${reportModel.location!.latitude!},${reportModel.location!.longitude!}');
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

String calculateTimeInterval(DateTime dateTime1, DateTime dateTime2) {
  Duration difference = dateTime2.difference(dateTime1);
  int minutes = difference.inMinutes;
  int hours = difference.inHours % 24;
  int days = difference.inDays;

  String result = '';

  if (days > 0) {
    result += '${days} days ';
  }
  if (hours > 0) {
    result += '${hours} hours ';
  }
  if (minutes > 0) {
    result += '${minutes % 60} mins';
  }
  return result.trim();
}

String formatCustomDateTime(String input) {
  final inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss.SSS");
  final dateTime = inputFormat.parse(input);

  // Updated output format
  final outputFormat = DateFormat("E, d MMM y hh:mma");
  final formattedDate = outputFormat.format(dateTime);

  return formattedDate;
}

List<ReportModel> filterDataByStatus(
    List<ReportModel> reports, String selectedValue) {
  if (selectedValue == "Pending") {
    return reports.where((report) => report.isDone == 'Pending').toList();
  } else if (selectedValue == "Done") {
    return reports.where((report) => report.isDone == 'Done').toList();
  }
  return reports; // Return all reports if no filter is applied
}
