// To parse this JSON data, do
//
//     final newsModel = newsModelFromJson(jsonString);

import 'dart:convert';

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
}
