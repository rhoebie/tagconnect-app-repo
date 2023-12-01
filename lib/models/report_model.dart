// To parse this JSON data, do
//
//     final reportModel = reportModelFromJson(jsonString);

import 'dart:convert';

ReportModel reportModelFromJson(String str) =>
    ReportModel.fromJson(json.decode(str));

String reportModelToJson(ReportModel data) => json.encode(data.toJson());

class ReportModel {
  int? id;
  int? userId;
  int? barangayId;
  String? emergencyType;
  String? forWhom;
  String? description;
  int? casualties;
  Location? location;
  String? visibility;
  String? image;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  ReportModel({
    this.id,
    this.userId,
    this.barangayId,
    this.emergencyType,
    this.forWhom,
    this.description,
    this.casualties,
    this.location,
    this.visibility,
    this.image,
    this.status,
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
        visibility: json["visibility"],
        image: json["image"],
        status: json["status"],
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
        "visibility": visibility,
        "image": image,
        "status": status,
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
