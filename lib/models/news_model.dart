// To parse this JSON data, do
//
//     final newsModel = newsModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:taguigconnect/constants/color_constant.dart';
import 'package:taguigconnect/screens/news-details_screen.dart';

List<NewsModel> newsModelFromJson(String str) =>
    List<NewsModel>.from(json.decode(str).map((x) => NewsModel.fromJson(x)));

String newsModelToJson(List<NewsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NewsModel {
  String? title;
  String? author;
  String? link;
  String? description;
  DateTime? date;
  String? image;

  NewsModel({
    this.title,
    this.author,
    this.link,
    this.description,
    this.date,
    this.image,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) => NewsModel(
        title: json["title"],
        author: json["author"],
        link: json["link"],
        description: json["description"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "author": author,
        "link": link,
        "description": description,
        "date": date?.toIso8601String(),
        "image": image,
      };

  Widget buildContactWidget(BuildContext context, NewsModel newsData) {
    return ListTile(
      leading: image != null
          ? CircleAvatar(
              backgroundColor: tcAsh,
              backgroundImage: NetworkImage(
                image!,
              ),
            )
          : CircleAvatar(
              backgroundColor: tcAsh,
              child: Center(
                child: Icon(
                  Icons.question_mark,
                  color: tcBlack,
                ),
              ),
            ),
      title: Text(
        title ?? '',
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: tcBlack,
        ),
      ),
      subtitle: Text(
        formatCustomDateTime(date.toString()),
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 13.sp,
          fontWeight: FontWeight.w400,
          color: tcGray,
        ),
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return NewsDetails(
                newsModel: newsData,
              );
            },
          ),
        );
      },
    );
  }

  String formatCustomDateTime(String input) {
    final inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss.SSS");
    final dateTime = inputFormat.parse(input);

    // Updated output format
    final outputFormat = DateFormat("E, d MMM y hh:mma");
    final formattedDate = outputFormat.format(dateTime);

    return formattedDate;
  }
}
