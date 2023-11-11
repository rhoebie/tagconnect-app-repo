// To parse this JSON data, do
//
//     final emergencyType = emergencyTypeFromJson(jsonString);

import 'dart:convert';

EmergencyType emergencyTypeFromJson(String str) =>
    EmergencyType.fromJson(json.decode(str));

String emergencyTypeToJson(EmergencyType data) => json.encode(data.toJson());

class EmergencyType {
  String? barangay;
  Type? type;

  EmergencyType({
    this.barangay,
    this.type,
  });

  factory EmergencyType.fromJson(Map<String, dynamic> json) => EmergencyType(
        barangay: json["Barangay"],
        type: json["Type"] == null ? null : Type.fromJson(json["Type"]),
      );

  Map<String, dynamic> toJson() => {
        "Barangay": barangay,
        "Type": type?.toJson(),
      };
}

class Type {
  int? crime;
  int? fire;
  int? general;
  int? medical;

  Type({
    this.crime,
    this.fire,
    this.general,
    this.medical,
  });

  factory Type.fromJson(Map<String, dynamic> json) => Type(
        crime: json["Crime"],
        fire: json["Fire"],
        general: json["General"],
        medical: json["Medical"],
      );

  Map<String, dynamic> toJson() => {
        "Crime": crime,
        "Fire": fire,
        "General": general,
        "Medical": medical,
      };
}
