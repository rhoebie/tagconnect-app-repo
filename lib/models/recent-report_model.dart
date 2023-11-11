// To parse this JSON data, do
//
//     final recentReportModel = recentReportModelFromJson(jsonString);

import 'dart:convert';

RecentReportModel recentReportModelFromJson(String str) =>
    RecentReportModel.fromJson(json.decode(str));

String recentReportModelToJson(RecentReportModel data) =>
    json.encode(data.toJson());

class RecentReportModel {
  int? id;
  int? userId;
  String? barangayId;
  String? emergencyType;
  String? forWhom;
  String? description;
  int? casualties;
  Location? location;
  String? image;
  int? isDone;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? responseTime;

  RecentReportModel({
    this.id,
    this.userId,
    this.barangayId,
    this.emergencyType,
    this.forWhom,
    this.description,
    this.casualties,
    this.location,
    this.image,
    this.isDone,
    this.createdAt,
    this.updatedAt,
    this.responseTime,
  });

  factory RecentReportModel.fromJson(Map<String, dynamic> json) =>
      RecentReportModel(
        id: json["id"],
        userId: json["user_id"],
        barangayId: json["barangay_id"],
        emergencyType: json["emergency_type"],
        forWhom: json["for_whom"],
        description: json["description"],
        casualties: json["casualties"],
        location: json["location"] == null
            ? null
            : Location.fromJson(json["location"]),
        image: json["image"],
        isDone: json["isDone"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        responseTime: json["response_time"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "barangay_id": barangayId,
        "emergency_type": emergencyType,
        "for_whom": forWhom,
        "description": description,
        "casualties": casualties,
        "location": location?.toJson(),
        "image": image,
        "isDone": isDone,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "response_time": responseTime,
      };
}

class Location {
  String? type;
  List<double>? coordinates;

  Location({
    this.type,
    this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        type: json["type"],
        coordinates: json["coordinates"] == null
            ? []
            : List<double>.from(json["coordinates"]!.map((x) => x?.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": coordinates == null
            ? []
            : List<dynamic>.from(coordinates!.map((x) => x)),
      };
}
