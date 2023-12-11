import 'dart:convert';

class NotificationModel {
  final int? id;
  final String title;
  final String body;
  final Map<String, dynamic> data;

  NotificationModel({
    this.id,
    required this.title,
    required this.body,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'data': jsonEncode(data),
    };
  }
}
