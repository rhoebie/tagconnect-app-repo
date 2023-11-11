// To parse this JSON data, do
//
//     final reportModel = reportModelFromJson(jsonString);

import 'dart:convert';

List<ReportModel> reportModelFromJson(String str) => List<ReportModel>.from(
    json.decode(str).map((x) => ReportModel.fromJson(x)));

String reportModelToJson(List<ReportModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReportModel {
  int? id;
  String? userId;
  String? barangayId;
  String? emergencyType;
  String? forWhom;
  String? description;
  String? casualties;
  Location? location;
  String? image;
  String? isDone;
  DateTime? createdAt;
  DateTime? updatedAt;

  ReportModel({
    this.id, //
    this.userId, //
    this.barangayId, //
    this.emergencyType, //
    this.forWhom, //
    this.description, //
    this.casualties, //
    this.location, //
    this.image, //
    this.isDone, //
    this.createdAt,
    this.updatedAt,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
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
      };
}

class Location {
  double? latitude;
  double? longitude;

  Location({
    this.latitude,
    this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
      };
}
