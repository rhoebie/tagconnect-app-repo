// To parse this JSON data, do
//
//     final createReportModel = createReportModelFromJson(jsonString);

import 'dart:convert';

String createReportModelToJson(List<CreateReportModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CreateReportModel {
  String barangayId;
  String emergencyType;
  String forWhom;
  String description;
  bool casualties;
  userLoc location;
  String? image;

  CreateReportModel({
    required this.barangayId,
    required this.emergencyType,
    required this.forWhom,
    required this.description,
    required this.casualties,
    required this.location,
    this.image,
  });

  Map<String, dynamic> toJson() => {
        "barangay_id": barangayId,
        "emergency_type": emergencyType,
        "for_whom": forWhom,
        "description": description,
        "casualties": casualties,
        "location": location.toJson(),
        "image": image,
      };
}

class userLoc {
  double latitude;
  double longitude;

  userLoc({
    required this.latitude,
    required this.longitude,
  });

  factory userLoc.fromJson(Map<String, dynamic> json) {
    return userLoc(
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
      };
}
