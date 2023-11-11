// To parse this JSON data, do
//
//     final averageReportModel = averageReportModelFromJson(jsonString);

import 'dart:convert';

AverageReportModel averageReportModelFromJson(String str) =>
    AverageReportModel.fromJson(json.decode(str));

String averageReportModelToJson(AverageReportModel data) =>
    json.encode(data.toJson());

class AverageReportModel {
  List<Average>? average;

  AverageReportModel({
    this.average,
  });

  factory AverageReportModel.fromJson(Map<String, dynamic> json) =>
      AverageReportModel(
        average: json["average"] == null
            ? []
            : List<Average>.from(
                json["average"]!.map((x) => Average.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "average": average == null
            ? []
            : List<dynamic>.from(average!.map((x) => x.toJson())),
      };
}

class Average {
  Barangay? barangay;
  String? responseTime;
  int? resolvedReports;

  Average({
    this.barangay,
    this.responseTime,
    this.resolvedReports,
  });

  factory Average.fromJson(Map<String, dynamic> json) => Average(
        barangay: json["barangay"] == null
            ? null
            : Barangay.fromJson(json["barangay"]),
        responseTime: json["response_time"],
        resolvedReports: json["resolved_reports"],
      );

  Map<String, dynamic> toJson() => {
        "barangay": barangay?.toJson(),
        "response_time": responseTime,
        "resolved_reports": resolvedReports,
      };
}

class Barangay {
  int? id;
  String? name;
  int? district;
  String? contact;
  String? address;
  Location? location;
  String? image;

  Barangay({
    this.id,
    this.name,
    this.district,
    this.contact,
    this.address,
    this.location,
    this.image,
  });

  factory Barangay.fromJson(Map<String, dynamic> json) => Barangay(
        id: json["id"],
        name: json["name"],
        district: json["district"],
        contact: json["contact"],
        address: json["address"],
        location: json["location"] == null
            ? null
            : Location.fromJson(json["location"]),
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "district": district,
        "contact": contact,
        "address": address,
        "location": location?.toJson(),
        "image": image,
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
