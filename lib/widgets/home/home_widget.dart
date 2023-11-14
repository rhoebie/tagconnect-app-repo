import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:taguigconnect/constants/color_constant.dart';
import 'package:taguigconnect/models/news_model.dart';
import 'package:taguigconnect/screens/report-emergency_screen.dart';
import 'package:http/http.dart' as http;

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  ScrollController _scrollController = ScrollController();
  List<NewsModel> newsList = [];
  int currentPage = 1;

  Future<List<NewsModel>?> fetchNewsData(
      {int page = 1, int perPage = 10}) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://taguigconnect.online/api/get-news?page=$page&per_page=$perPage'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'];

        List<NewsModel> newsList =
            data.map((item) => NewsModel.fromJson(item)).toList();

        return newsList;
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<void> loadMore() async {
    final currentPosition = _scrollController.position.pixels;

    final moreNews = await fetchNewsData(page: currentPage + 1);
    if (moreNews != null) {
      print('Loaded more data for page $currentPage');
      setState(() {
        newsList.addAll(moreNews);
        currentPage++;
      });

      // Restore scroll position
      _scrollController.jumpTo(currentPosition);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: tcBlack,
                    ),
                    children: [
                      TextSpan(
                        text: 'Welcome, ',
                      ),
                      TextSpan(
                        text: 'John',
                        style: TextStyle(
                          color: tcViolet,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'How are you feeling today?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: tcBlack,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: tcBlack,
                        ),
                        children: [
                          TextSpan(
                            text: 'Your total reports: ',
                          ),
                          TextSpan(
                            text: '0',
                            style: TextStyle(
                              color: tcBlack,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: tcBlack,
                        ),
                        children: [
                          TextSpan(
                            text: 'Total barangay: ',
                          ),
                          TextSpan(
                            text: '38',
                            style: TextStyle(
                              color: tcBlack,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.transparent,
                  height: 10.h,
                ),
                Container(
                  width: double.infinity.w,
                  height: 130.h,
                  decoration: BoxDecoration(
                    color: tcViolet,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 10,
                        top: 10,
                        child: Text(
                          'Not feeling safe?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'PublicSans',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: tcWhite,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 10,
                        top: 35,
                        child: Text(
                          'Need urgent emergency?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'PublicSans',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: tcWhite,
                          ),
                        ),
                      ),
                      Positioned(
                          right: 10,
                          bottom: 10,
                          child: Container(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: tcWhite,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 2,
                              ),
                              child: Text(
                                'One tap report',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: tcViolet,
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Taguig Emergency Service',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: tcBlack,
                  ),
                ),
                Divider(
                  color: Colors.transparent,
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 60.w,
                          height: 60.w,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: EdgeInsets.all(16),
                              backgroundColor: tcOrange,
                              elevation: 2,
                            ),
                            child: Icon(
                              Icons.phone,
                              color: tcWhite,
                            ),
                          ),
                        ),
                        Divider(
                          color: Colors.transparent,
                          height: 5.h,
                        ),
                        Text(
                          'General',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: tcBlack,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          width: 60.w.w,
                          height: 60.w.h,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: EdgeInsets.all(16),
                              backgroundColor: tcGreen,
                              elevation: 2,
                            ),
                            child: Icon(
                              Icons.phone,
                              color: tcWhite,
                            ),
                          ),
                        ),
                        Divider(
                          color: Colors.transparent,
                          height: 5.h,
                        ),
                        Text(
                          'Medical',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: tcBlack,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          width: 60.w,
                          height: 60.w,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: EdgeInsets.all(16),
                              backgroundColor: tcRed,
                              elevation: 2,
                            ),
                            child: Icon(
                              Icons.phone,
                              color: tcWhite,
                            ),
                          ),
                        ),
                        Divider(
                          color: Colors.transparent,
                          height: 5.h,
                        ),
                        Text(
                          'Fire',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: tcBlack,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          width: 60.w,
                          height: 60.w,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: EdgeInsets.all(16),
                              backgroundColor: tcBlue,
                              elevation: 2,
                            ),
                            child: Icon(
                              Icons.phone,
                              color: tcWhite,
                            ),
                          ),
                        ),
                        Divider(
                          color: Colors.transparent,
                          height: 5.h,
                        ),
                        Text(
                          'Crime',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: tcBlack,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'News and Updates',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: tcBlack,
                  ),
                ),
                Divider(
                  color: Colors.transparent,
                  height: 10.h,
                ),
                // Container(
                //   width: double.infinity.w,
                //   height: 250.h,
                //   child: ClipRRect(
                //     borderRadius: BorderRadius.all(Radius.circular(10)),
                //     child: FutureBuilder(
                //       future: fetchNewsData(),
                //       builder: (context, snapshot) {
                //         if (snapshot.connectionState ==
                //             ConnectionState.waiting) {
                //           return Center(
                //             child: CircularProgressIndicator(
                //               color: tcViolet,
                //             ),
                //           );
                //         } else if (snapshot.hasError) {
                //           return Text('Error: ${snapshot.error}');
                //         } else if (snapshot.hasData) {
                //           newsList = snapshot.data!;

                //           return LazyLoadScrollView(
                //             onEndOfPage: () => loadMore(),
                //             scrollDirection: Axis.horizontal,
                //             child: ListView.builder(
                //               scrollDirection: Axis.horizontal,
                //               itemCount: 10,
                //               itemBuilder: (context, index) {
                //                 final newsData = newsList[index];
                //                 return InkWell(
                //                   child: Container(
                //                     width: 180,
                //                     child: Card(
                //                       elevation: 2,
                //                       child: Column(
                //                         crossAxisAlignment:
                //                             CrossAxisAlignment.start,
                //                         children: [
                //                           ClipRRect(
                //                             borderRadius: BorderRadius.vertical(
                //                                 top: Radius.circular(10)),
                //                             child: Container(
                //                               width: 180.w,
                //                               height: 100.h,
                //                               child: Image.network(
                //                                 newsData!.image!,
                //                                 fit: BoxFit.cover,
                //                               ),
                //                             ),
                //                           ),
                //                           Text(
                //                             newsData.title ?? '',
                //                             textAlign: TextAlign.center,
                //                             style: TextStyle(
                //                               fontFamily: 'Roboto',
                //                               fontSize: 14.sp,
                //                               fontWeight: FontWeight.w400,
                //                               color: tcBlack,
                //                             ),
                //                           ),
                //                         ],
                //                       ),
                //                     ),
                //                   ),
                //                 );
                //               },
                //             ),
                //           );
                //         } else {
                //           return Center(
                //             child: Text('No data available'),
                //           );
                //         }
                //       },
                //     ),
                //   ),
                // ),
                Container(
                  width: double.infinity.w,
                  height: 250.h,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: FutureBuilder(
                      future: fetchNewsData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: tcViolet,
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          List<NewsModel> newNewsList = snapshot.data!;

                          return LazyLoadScrollView(
                            onEndOfPage: () => loadMore(),
                            scrollDirection: Axis.horizontal,
                            child: ListView.builder(
                              controller: _scrollController,
                              scrollDirection: Axis.horizontal,
                              itemCount: newsList.length + newNewsList.length,
                              itemBuilder: (context, index) {
                                if (index < newsList.length) {
                                  final newsData = newsList[index];
                                  return InkWell(
                                    child: Container(
                                      width: 180,
                                      child: Card(
                                        elevation: 2,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top: Radius.circular(10)),
                                              child: Container(
                                                width: 180.w,
                                                height: 100.h,
                                                child: Image.network(
                                                  newsData.image!,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              newsData.title ?? '',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w400,
                                                color: tcBlack,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  // Display the new data
                                  final newIndex = index - newsList.length;
                                  final newsData = newNewsList[newIndex];
                                  return InkWell(
                                    child: Container(
                                      width: 180,
                                      child: Card(
                                        elevation: 2,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top: Radius.circular(10)),
                                              child: Container(
                                                width: 180.w,
                                                height: 100.h,
                                                child: Image.network(
                                                  newsData.image!,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              newsData.title ?? '',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w400,
                                                color: tcBlack,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          );
                        } else {
                          return Center(
                            child: Text('No data available'),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: OpenContainer(
        closedElevation: 5,
        closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
        ),
        transitionType: ContainerTransitionType.fade,
        transitionDuration: const Duration(milliseconds: 300),
        openBuilder: (BuildContext context, VoidCallback _) {
          return ReportEmergencyScreen();
        },
        tappable: false,
        closedBuilder: (BuildContext context, VoidCallback openContainer) {
          return FloatingActionButton(
            backgroundColor: tcViolet,
            onPressed: openContainer,
            child: const Icon(
              Icons.add,
              color: tcWhite,
              size: 30,
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
