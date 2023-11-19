// To parse this JSON data, do
//
//     final feedModel = feedModelFromJson(jsonString);

import 'dart:convert';

FeedModel feedModelFromJson(String str) => FeedModel.fromJson(json.decode(str));

String feedModelToJson(FeedModel data) => json.encode(data.toJson());

class FeedModel {
  int? id;
  int? barangayId;
  String? emergencyType;
  String? forWhom;
  String? description;
  int? casualties;
  Location? location;
  String? image;
  int? isDone;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? resolveTime;

  FeedModel({
    this.id,
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
    this.resolveTime,
  });

  factory FeedModel.fromJson(Map<String, dynamic> json) => FeedModel(
        id: json["id"],
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
        resolveTime: json["resolveTime"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
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
        "resolveTime": resolveTime,
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
