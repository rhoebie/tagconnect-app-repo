// To parse this JSON data, do
//
//     final createReportModel = createReportModelFromJson(jsonString);

import 'dart:convert';

String updateReportModelToJson(List<UpdateReportModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UpdateReportModel {
  String? emergencyType;
  String? forWhom;
  String? description;
  bool? casualties;
  String? visibility;
  String? image;

  UpdateReportModel({
    this.emergencyType,
    this.forWhom,
    this.description,
    this.casualties,
    this.visibility,
    this.image,
  });

  Map<String, dynamic> toJson() => {
        "emergency_type": emergencyType,
        "for_whom": forWhom,
        "description": description,
        "casualties": casualties,
        "visibility": visibility,
        if (image != null) "image": image,
      };
}
