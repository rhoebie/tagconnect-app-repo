import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:TagConnect/constants/color_constant.dart';
import 'package:TagConnect/models/news_model.dart';
import 'package:flutter_html/flutter_html.dart' as html;
import 'package:url_launcher/url_launcher.dart';

class NewsDetails extends StatelessWidget {
  final NewsModel newsModel;
  const NewsDetails({super.key, required this.newsModel});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color backgroundColor = theme.scaffoldBackgroundColor;
    final Color textColor = theme.colorScheme.onBackground;

    void showImageDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                  child: Image.network(
                    newsModel.image ?? '',
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                    errorBuilder: (BuildContext context, Object error,
                        StackTrace? stackTrace) {
                      return Icon(Icons.error);
                    },
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                ),
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        leading: CloseButton(),
        iconTheme: IconThemeData(color: textColor),
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          'ARTICLE',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor,
            fontFamily: 'Roboto',
            fontSize: 20.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              final Uri launchUri = Uri.parse(newsModel.link!);
              await launchUrl(launchUri);
            },
            icon: Icon(Icons.language_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 200.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: tcAsh,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: newsModel.image != null
                      ? GestureDetector(
                          onTap: () {
                            showImageDialog(context);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: Container(
                              child: Image.network(
                                newsModel.image!,
                                fit: BoxFit.cover,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                },
                                errorBuilder: (BuildContext context,
                                    Object error, StackTrace? stackTrace) {
                                  return Icon(Icons.error);
                                },
                              ),
                            ),
                          ),
                        )
                      : Center(
                          child: Icon(Icons.question_mark),
                        ),
                ),
                Divider(
                  color: Colors.transparent,
                  height: 10,
                ),
                Text(
                  newsModel.title ?? '',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                Text(
                  'Author: ${newsModel.author ?? ''}',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontFamily: 'PublicSans',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: textColor,
                  ),
                ),
                Text(
                  'Date: ${formatCustomDateTime(newsModel.date.toString())}',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontFamily: 'PublicSans',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: textColor,
                  ),
                ),
                Divider(
                  color: Colors.transparent,
                ),
                html.Html(
                  data: newsModel.description,
                  style: {
                    "p": html.Style(
                      fontSize: html.FontSize(14.sp),
                      fontWeight: FontWeight.w400,
                      color: textColor,
                    ),
                  },
                ),
              ],
            ),
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
