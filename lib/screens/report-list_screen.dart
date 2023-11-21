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
        automaticallyImplyLeading: false,
        leading: CloseButton(),
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
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return ReportDetail(
                                            reportModel: item,
                                          );
                                        },
                                      ),
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

class ReportDetail extends StatelessWidget {
  final ReportModel reportModel;
  const ReportDetail({super.key, required this.reportModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tcWhite,
      appBar: AppBar(
        leading: CloseButton(),
        iconTheme: IconThemeData(color: tcBlack),
        backgroundColor: tcWhite,
        elevation: 0,
        title: Text(
          reportModel.emergencyType?.toUpperCase() ?? '',
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: tcViolet,
                    foregroundColor: tcWhite,
                    child: Icon(Icons.person_rounded),
                  ),
                  VerticalDivider(
                    color: Colors.transparent,
                    width: 5,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reportModel.userId ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: tcBlack,
                          fontFamily: 'Roboto',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Date: ${formatCustomDateTime(reportModel.createdAt.toString())}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'PublicSans',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.normal,
                          color: tcBlack,
                        ),
                      ),
                      Text(
                        'Resolve Time: ${calculateTimeInterval(reportModel.createdAt!, reportModel.updatedAt!)}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'PublicSans',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.normal,
                          color: tcBlack,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Report ID',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PublicSans',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: tcBlack,
                    ),
                  ),
                  Text(
                    reportModel.id.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PublicSans',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: tcBlack,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Barangay ID',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PublicSans',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: tcBlack,
                    ),
                  ),
                  Text(
                    reportModel.barangayId.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PublicSans',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: tcBlack,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'For Whom?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PublicSans',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: tcBlack,
                    ),
                  ),
                  Text(
                    reportModel.forWhom ?? '',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PublicSans',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: tcBlack,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Any Casualties?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PublicSans',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: tcBlack,
                    ),
                  ),
                  Text(
                    reportModel.casualties == 1 ? 'Yes' : 'No',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PublicSans',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: tcBlack,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PublicSans',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: tcBlack,
                    ),
                  ),
                  Text(
                    reportModel.description ?? '',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontFamily: 'PublicSans',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: tcBlack,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Location',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PublicSans',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: tcBlack,
                    ),
                  ),
                  Container(
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Image',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PublicSans',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: tcBlack,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 200,
                    child: reportModel.image != null
                        ? Image.network(
                            reportModel.image!,
                            fit: BoxFit.cover,
                          )
                        : Center(
                            child: Icon(
                              Icons.question_mark,
                              color: tcBlack,
                            ),
                          ),
                  ),
                ],
              ),
            ],
          ),
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

List<ReportModel> filterDataByStatus(
    List<ReportModel> reports, String selectedValue) {
  if (selectedValue == "Pending") {
    return reports.where((report) => report.isDone == 'Pending').toList();
  } else if (selectedValue == "Done") {
    return reports.where((report) => report.isDone == 'Done').toList();
  }
  return reports; // Return all reports if no filter is applied
}
