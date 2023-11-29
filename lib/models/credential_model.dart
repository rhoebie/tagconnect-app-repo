// To parse this JSON data, do
//
//     final credentialModel = credentialModelFromJson(jsonString);

import 'dart:convert';

CredentialModel credentialModelFromJson(String str) =>
    CredentialModel.fromJson(json.decode(str));

String credentialModelToJson(CredentialModel data) =>
    json.encode(data.toJson());

class CredentialModel {
  String? email;
  String? password;

  CredentialModel({
    this.email,
    this.password,
  });

  factory CredentialModel.fromJson(Map<String, dynamic> json) =>
      CredentialModel(
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
      };
}
