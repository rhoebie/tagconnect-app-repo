import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:taguigconnect/constants/color_constant.dart';
import 'package:http/http.dart' as http;
import 'package:taguigconnect/models/barangay_model.dart';
import 'package:taguigconnect/models/feed_model.dart';
import 'package:taguigconnect/screens/report-details_screen.dart';
import 'package:taguigconnect/services/barangay_service.dart';

class FeedWidget extends StatefulWidget {
  const FeedWidget({super.key});

  @override
  State<FeedWidget> createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {
  int selectedBarangayIndex = 0;
  late PageController _pageController;
  late Timer _timer;
  final scrollController = ScrollController();
  int page = 1;
  late List<FeedModel> initialReportData; // Store the initial data
  List<FeedModel> featuredReport = []; // Initial data for PageView
  List<FeedModel> reportData = [];
  List<BarangayModel> barangayData = [];
  int _currentPage = 0;
  int currentPage = 1;
  int totalPage = 1;

  final ScrollController _scrollController = ScrollController();

  Future<void> fetchReportData(String barangayName, {int page = 1}) async {
    if (page > totalPage) {
      // No more data to fetch
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

        setState(() {
          if (page == 1) {
            reportData = reports;
          } else {
            reportData.addAll(reports); // Append new data
          }
          totalPage = responseData['meta']['total_page'];
          currentPage = page;
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

  Future<void> fetchInitialData() async {
    await fetchReportData('All');
    initialReportData = List.from(reportData);
    featuredReport = List.from(reportData);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchInitialData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // Reached the end of the list, load more data
        fetchReportData('all', page: currentPage + 1);
      }
    });
    fetchBarangay();
    _pageController = PageController();
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 4) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.only(top: 10),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                height: 250,
                width: double.infinity,
                child: PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.horizontal,
                  itemCount:
                      featuredReport.length >= 5 ? 5 : featuredReport.length,
                  itemBuilder: (context, index) {
                    final item = featuredReport[index];
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 180,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Positioned.fill(
                                    child: Image.network(
                                      item.image!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: [
                                            Colors.black,
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              width: double.infinity,
                              height: 70,
                              color: Colors.black,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundColor: tcViolet,
                                        foregroundColor: tcWhite,
                                        child: Icon(
                                          Icons.person_rounded,
                                        ),
                                      ),
                                      VerticalDivider(
                                        color: Colors.transparent,
                                        width: 10,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Report ID: ${item.id.toString()}',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: 'PublicSans',
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w700,
                                              color: tcWhite,
                                            ),
                                          ),
                                          Text(
                                            formatCustomDateTime(
                                                item.createdAt.toString()),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: 'PublicSans',
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w400,
                                              color: tcWhite,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Container(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return ReportDetail(
                                                feedModel: item,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: tcViolet,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                            )
                          ],
                        ),
                      ),
                    );
                  },
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
                        itemCount: barangayData.length + 1,
                        itemBuilder: (context, index) {
                          bool isSelected = index == selectedBarangayIndex;

                          return InkWell(
                            onTap: () {
                              String selectedBarangayName = index == 0
                                  ? "All"
                                  : barangayData[index - 1].name ?? '';
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
                                          : barangayData[index - 1].name ?? '',
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
                    final item = reportData[index];
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return ReportDetail(
                                feedModel: item,
                              );
                            },
                          ),
                        );
                      },
                      child: Card(
                        color: tcWhite,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          height: 120,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: tcViolet,
                                        foregroundColor: tcWhite,
                                        radius: 15,
                                        child: Icon(
                                          Icons.person_rounded,
                                          size: 20,
                                        ),
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
                                            item.emergencyType ?? '',
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
                                  Container(
                                    width: 200,
                                    child: Text(
                                      item.description ?? '',
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.justify,
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
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  child: item.image != null
                                      ? Image.network(
                                          item.image!,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          child: Icon(Icons.question_mark),
                                        ),
                                ),
                              )
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
