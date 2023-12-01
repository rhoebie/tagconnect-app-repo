// To parse this JSON data, do
//
//     final barangayModel = barangayModelFromJson(jsonString);

import 'dart:convert';

BarangayModel barangayModelFromJson(String str) =>
    BarangayModel.fromJson(json.decode(str));

String barangayModelToJson(BarangayModel data) => json.encode(data.toJson());

class BarangayModel {
  int? id;
  int? moderatorId;
  String? name;
  int? district;
  String? contact;
  String? address;
  Location? location;
  String? image;

  BarangayModel({
    this.id,
    this.moderatorId,
    this.name,
    this.district,
    this.contact,
    this.address,
    this.location,
    this.image,
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
