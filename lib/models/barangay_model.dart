import 'dart:convert';

List<BarangayModel> barangayModelFromJson(String str) =>
    List<BarangayModel>.from(
        json.decode(str).map((x) => BarangayModel.fromJson(x)));

String barangayModelToJson(List<BarangayModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BarangayModel {
  int id;
  int? moderatorId;
  String name;
  int? district;
  String? contact;
  String address;
  String? image;

  BarangayModel({
    required this.id,
    this.moderatorId,
    required this.name,
    this.district,
    this.contact,
    required this.address,
    this.image,
  });

  factory BarangayModel.fromJson(Map<String, dynamic> json) => BarangayModel(
        id: json["id"],
        moderatorId: json["moderator_id"],
        name: json["name"],
        district: json["district"],
        contact: json["contact"],
        address: json["address"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "moderator_id": moderatorId,
        "name": name,
        "district": district,
        "contact": contact,
        "address": address,
        "image": image,
      };
}
