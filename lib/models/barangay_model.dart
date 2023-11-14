// To parse this JSON data, do
//
//     final barangayModel = barangayModelFromJson(jsonString);

import 'dart:convert';

List<BarangayModel> barangayModelFromJson(String str) =>
    List<BarangayModel>.from(
        json.decode(str).map((x) => BarangayModel.fromJson(x)));

String barangayModelToJson(List<BarangayModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BarangayModel {
  int? id;
  int? moderatorId;
  String? name;
  int? district;
  String? contact;
  String? address;
  Location? location;
  String? image;
  Analytics? analytics;

  BarangayModel({
    this.id,
    this.moderatorId,
    this.name,
    this.district,
    this.contact,
    this.address,
    this.location,
    this.image,
    this.analytics,
  });

  factory BarangayModel.fromJson(Map<String, dynamic> json) => BarangayModel(
        id: json["id"],
        moderatorId: json["moderator_id"],
        name: json["name"],
        district: json["district"],
        contact: json["contact"],
        address: json["address"],
        location: json["location"] == null
            ? null
            : Location.fromJson(json["location"]),
        image: json["image"],
        analytics: json["analytics"] == null
            ? null
            : Analytics.fromJson(json["analytics"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "moderator_id": moderatorId,
        "name": name,
        "district": district,
        "contact": contact,
        "address": address,
        "location": location?.toJson(),
        "image": image,
        "analytics": analytics?.toJson(),
      };
}

class Analytics {
  int? general;
  int? medical;
  int? fire;
  int? crime;
  String? responseTime;
  int? totalReports;

  Analytics({
    this.general,
    this.medical,
    this.fire,
    this.crime,
    this.responseTime,
    this.totalReports,
  });

  factory Analytics.fromJson(Map<String, dynamic> json) => Analytics(
        general: json["General"],
        medical: json["Medical"],
        fire: json["Fire"],
        crime: json["Crime"],
        responseTime: json["ResponseTime"],
        totalReports: json["TotalReports"],
      );

  Map<String, dynamic> toJson() => {
        "General": general,
        "Medical": medical,
        "Fire": fire,
        "Crime": crime,
        "ResponseTime": responseTime,
        "TotalReports": totalReports,
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
