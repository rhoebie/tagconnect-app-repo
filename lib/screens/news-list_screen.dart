import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taguigconnect/constants/color_constant.dart';
import 'package:taguigconnect/models/news_model.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class NewsList extends StatefulWidget {
  const NewsList({super.key});

  @override
  State<NewsList> createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  List<NewsModel> newsData = [];
  final ScrollController _scrollController = ScrollController();
  int currentPage = 1;
  int totalPage = 1;

  Future<void> fetchNewsData({int page = 1}) async {
    if (page > totalPage) {
      // No more data to fetch
      print('no more page');
      return;
    }

    try {
      final url = 'https://taguigconnect.online/api/get-news?$page';
      final response = await http.get(
        Uri.parse(url),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'];

        List<NewsModel> fetchNewsList =
            data.map((item) => NewsModel.fromJson(item)).toList();

        // Sort the list based on the date
        fetchNewsList.sort((a, b) => a.date!.compareTo(b.date!));
        setState(() {
          if (page == 1) {
            newsData = fetchNewsList;
          } else {
            newsData.addAll(fetchNewsList);
          }
          totalPage = responseData['meta']['total_page'];
          currentPage = page;
        });
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchNewsData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // Reached the end of the list, load more data
        fetchNewsData(page: currentPage + 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tcWhite,
      appBar: AppBar(
        leading: BackButton(),
        iconTheme: IconThemeData(color: tcBlack),
        backgroundColor: tcWhite,
        elevation: 0,
        title: Text(
          'NEWS',
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
              final Uri launchUri =
                  Uri.parse('https://www.manilatimes.net/news');
              await launchUrl(launchUri);
            },
            icon: Icon(Icons.language_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          child: CustomScrollView(
            controller: _scrollController,
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return newsData[index]
                        .buildContactWidget(context, newsData[index]);
                  },
                  childCount: newsData.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
