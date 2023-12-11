import 'dart:async';
import 'package:TagConnect/constants/provider_constant.dart';
import 'package:TagConnect/models/report_model.dart';
import 'package:TagConnect/services/report_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:TagConnect/constants/color_constant.dart';
import 'package:TagConnect/models/barangay_model.dart';
import 'package:TagConnect/screens/report-details_screen.dart';
import 'package:TagConnect/services/barangay_service.dart';
import 'package:provider/provider.dart';

class FeedWidget extends StatefulWidget {
  const FeedWidget({super.key});

  @override
  State<FeedWidget> createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {
  int selectedBarangayIndex = 0;
  int page = 1;
  List<ReportModel> reportData = [];
  List<BarangayModel> barangayData = [];
  int currentPage = 1;
  int totalPage = 1;
  bool isLoadingMore = false;
  final ScrollController _scrollController = ScrollController();
  List<String> barangayList = [
    'Fort Bonifacio',
    'Upper Bicutan',
    'Western Bicutan',
    'Pinagsama',
    'Ususan',
    'Napindan',
    'Tuktukan',
    'Central Signal Village',
    'New Lower Bicutan',
    'Maharlika Village',
    'Central Bicutan',
    'Lower Bicutan',
    'North Daang Hari',
    'Tanyag',
    'Bagumbayan',
    'South Daang Hari',
    'Palingon',
    'Ligid Tipas',
    'Ibayo Tipas',
    'Calzada',
    'Bambang',
    'Sta Ana',
    'Wawa',
    'Katuparan',
    'North Signal Village',
    'San Miguel',
    'South Signal Village',
    'Hagonoy',
    'Pembo',
    'Comembo',
    'Cembo',
    'South Cembo',
    'West Rembo',
    'East Rembo',
    'Pitogo',
    'Rizal',
    'Post Proper North Side',
    'Post Proper South Side',
  ];

  Future<void> fetchReportData(String barangayName, {int page = 1}) async {
    try {
      final reportService = ReportService();
      // Use the ReportService to get reports
      final reports =
          await reportService.getFeedReports(barangayName, page: page);

      if (mounted) {
        setState(() {
          if (page == 1) {
            reportData = reports ?? [];
          } else {
            reportData.addAll(reports ?? []); // Append new data
          }

          // Update other state variables if needed

          isLoadingMore = false;
        });
      }
    } catch (error) {
      // Handle errors if necessary
      print('Error fetching reports: $error');
    }
  }

  Future<void> fetchBarangay() async {
    try {
      final barangayService = BarangayService();
      final List<BarangayModel> fetchData =
          await barangayService.getbarangays();
      if (mounted) {
        setState(() {
          barangayData = fetchData;
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadInitialData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // Reached the end of the list, load more data
        if (mounted) {
          setState(() {
            isLoadingMore = true;
          });
        }
        _loadMoreData();
      }
    });
  }

// New method to load initial data
  Future<void> _loadInitialData() async {
    await fetchBarangay();
    final reportService = ReportService();
    final reports = await reportService.getFeedReports('all');
    if (mounted) {
      setState(() {
        reportData = reports ?? [];
      });
    }
  }

// New method to load more data
  Future<void> _loadMoreData() async {
    final reportService = ReportService();
    final reports =
        await reportService.getFeedReports('all', page: currentPage + 1);
    if (mounted) {
      setState(() {
        if (reports != null) {
          if (currentPage == 1) {
            reportData = reports;
          } else {
            reportData.addAll(reports);
          }
          totalPage = reports.length;
          currentPage += 1;
        }
        isLoadingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeProvider>(context);
    final ThemeData theme = Theme.of(context);
    final Color backgroundColor = theme.scaffoldBackgroundColor;
    final Color textColor = theme.colorScheme.onBackground;
    return Scaffold(
      body: Container(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Report Feed',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                    Container(
                      width: 300,
                      child: Text(
                        'This show all the reports that have a visibility set to \'Public\' and have a status of \'Resolved\'',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: tcGray,
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.transparent,
                      height: 5,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 30,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: barangayList.length + 1,
                        itemBuilder: (context, index) {
                          bool isSelected = index == selectedBarangayIndex;

                          return InkWell(
                            onTap: () {
                              String selectedBarangayName =
                                  index == 0 ? "All" : barangayList[index - 1];
                              fetchReportData(selectedBarangayName);
                              if (mounted) {
                                setState(() {
                                  selectedBarangayIndex =
                                      isSelected ? -1 : index;
                                });
                              }
                            },
                            borderRadius: BorderRadius.circular(50),
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 2.5),
                              decoration: BoxDecoration(
                                color: themeNotifier.isDarkMode
                                    ? isSelected
                                        ? tcViolet
                                        : tcDark
                                    : isSelected
                                        ? tcViolet
                                        : tcAsh,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(width: 10),
                                    Text(
                                      index == 0
                                          ? "All"
                                          : barangayList[index - 1],
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        color: themeNotifier.isDarkMode
                                            ? textColor
                                            : isSelected
                                                ? backgroundColor
                                                : textColor,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Divider(
                      color: Colors.transparent,
                      height: 5,
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = reportData[index];
                    String barangayText = barangayList[item.barangayId! - 1];

                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return ReportDetail(
                                reportModel: item,
                                barangayModel: barangayText,
                              );
                            },
                          ),
                        );
                      },
                      child: Card(
                        color: themeNotifier.isDarkMode ? tcDark : tcWhite,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$barangayText Report #${item.id}',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                      color: textColor,
                                    ),
                                  ),
                                  Text(
                                    formatCustomDateTime(
                                        item.createdAt.toString()),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'PublicSans',
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: textColor,
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                color: Colors.transparent,
                                height: 5,
                              ),
                              Container(
                                width: double.infinity,
                                child: Text(
                                  item.description ?? '',
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                    fontFamily: 'PublicSans',
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    color: textColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: reportData.length,
                ),
              ),
            ),
            SliverVisibility(
              visible: isLoadingMore,
              sliver: SliverToBoxAdapter(
                child: Container(
                  height: 50,
                  margin: EdgeInsetsDirectional.symmetric(vertical: 15),
                  child: Center(
                    child: isLoadingMore
                        ? CircularProgressIndicator()
                        : Container(
                            child: Text(
                              'End of List',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: textColor,
                              ),
                            ),
                          ),
                  ),
                ),
              ),
            )
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
