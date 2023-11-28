import 'dart:async';
import 'dart:convert';

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
  List<FeedModel> filteredReportData = [];
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

  void filterReport(String query) {
    query = query.toLowerCase();
    setState(() {
      if (query.isEmpty || query == '') {
        // Show all contacts when the query is empty or null
        filteredReportData = List.from(reportData);
      } else {
        // Filter based on the search query
        filteredReportData = reportData
            .where(
                (report) => report.emergencyType!.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  Future<void> fetchReportData(String barangayName, {int page = 1}) async {
    if (page > totalPage) {
      // No more data to fetch
      setState(() {
        isLoadingMore = false;
      });
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

        setState(() {
          if (page == 1) {
            reportData = reports;
            filteredReportData = reports;
          } else {
            reportData.addAll(reports); // Append new data
            filteredReportData.addAll(reports); // Append new data
          }
          totalPage = responseData['meta']['total_page'];
          currentPage = page;
          isLoadingMore = false;
        });
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

      setState(() {
        barangayData = fetchData;
      });
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
        setState(() {
          isLoadingMore = true;
        });
        fetchReportData('all', page: currentPage + 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              pinned: false,
              floating: true,
              snap: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              flexibleSpace: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: tcWhite,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          onChanged: (value) {
                            filterReport(value);
                          },
                          decoration: InputDecoration(
                            hintText: 'Emergency Type',
                            hintStyle: TextStyle(
                              color: tcGray,
                            ),
                            icon: Icon(
                              Icons.search,
                              color: tcGray,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
                        color: tcBlack,
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
                              setState(() {
                                selectedBarangayIndex = isSelected ? -1 : index;
                              });
                            },
                            borderRadius: BorderRadius.circular(50),
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 2.5),
                              decoration: BoxDecoration(
                                color: isSelected ? tcViolet : tcAsh,
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
                                        color: isSelected ? tcWhite : tcBlack,
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
                    final item = filteredReportData[index];
                    final barangayInfo = barangayData.firstWhere(
                      (barangay) => barangay.id == item.barangayId,
                      orElse: () => BarangayModel(),
                    );

                    // Calculate the height based on the description length
                    final descriptionLines =
                        (item.description ?? '').split('\n');
                    final descriptionHeight = descriptionLines.length *
                        16.0; // Adjust the line height as needed

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
                      child: SizedBox(
                        height: descriptionHeight + 120,
                        child: Card(
                          color: tcWhite,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            height: 120,
                            width: double.infinity,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                            color: tcBlack,
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
                                            color: tcBlack,
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
                                Text(
                                  item.description ?? '',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
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
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: filteredReportData.length,
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
                                color: tcBlack,
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