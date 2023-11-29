import 'dart:async';
import 'dart:convert';
import 'package:TagConnect/constants/provider_constant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:TagConnect/constants/color_constant.dart';
import 'package:http/http.dart' as http;
import 'package:TagConnect/models/barangay_model.dart';
import 'package:TagConnect/models/feed_model.dart';
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
  late List<FeedModel> initialReportData;
  List<FeedModel> reportData = [];
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
    if (page > totalPage) {
      // No more data to fetch
      if (mounted) {
        setState(() {
          isLoadingMore = false;
        });
      }
      print('no more page');
      return;
    }

    final url =
        Uri.parse('https://taguigconnect.online/api/get-reports?page=$page');

    print(
        'Currently on page: https://taguigconnect.online/api/get-reports?page=$page');

    // Create a map with the request body
    final Map<String, dynamic> requestBody = {'barangayName': barangayName};

    try {
      final response = await http.post(
        url,
        body: json.encode(requestBody),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'];
        List<FeedModel> reports =
            data.map((item) => FeedModel.fromJson(item)).toList();

        // Sort the reports by id in descending order
        reports.sort((a, b) => b.id!.compareTo(a.id!));
        if (mounted) {
          setState(() {
            if (page == 1) {
              reportData = reports;
            } else {
              reportData.addAll(reports); // Append new data
            }
            totalPage = responseData['meta']['total_page'];
            currentPage = page;
            isLoadingMore = false;
          });
        }
      } else {
        // If the server did not return a 200 OK response,
        // throw an exception.
        throw Exception('Failed to load reports');
      }
    } catch (error) {
      // Handle network-related errors
      throw Exception('Network error: $error');
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
    fetchBarangay();
    fetchReportData('All');
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // Reached the end of the list, load more data
        if (mounted) {
          setState(() {
            isLoadingMore = true;
          });
        }

        fetchReportData('all', page: currentPage + 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
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
                    Divider(
                      color: Colors.transparent,
                    ),
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
                    Divider(
                      color: Colors.transparent,
                      height: 5,
                    ),
                    Container(
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
                    final barangayInfo = barangayData.firstWhere(
                      (barangay) => barangay.id == item.barangayId,
                      orElse: () => BarangayModel(),
                    );

                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return ReportDetail(
                                feedModel: item,
                                barangayModel: barangayInfo,
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  item.image != null
                                      ? ClipOval(
                                          child: CachedNetworkImage(
                                            width: 30,
                                            height: 30,
                                            imageUrl: item.image!,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) => Center(
                                                child:
                                                    CircularProgressIndicator()),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                          ),
                                        )
                                      : Icon(
                                          Icons.question_mark,
                                          size: 20,
                                        ),
                                  VerticalDivider(
                                    color: Colors.transparent,
                                    width: 5,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${barangayInfo.name ?? ''} Report #${item.id}',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
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
                                          fontWeight: FontWeight.normal,
                                          color: textColor,
                                        ),
                                      ),
                                    ],
                                  )
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
