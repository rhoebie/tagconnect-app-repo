// To parse this JSON data, do
//
//     final contactModel = contactModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

ContactModel contactModelFromJson(String str) =>
    ContactModel.fromJson(json.decode(str));

String contactModelToJson(ContactModel data) => json.encode(data.toJson());

class ContactModel {
  String? firstname;
  String? lastname;
  String? email;
  String? contact;
  String? image;

  ContactModel({
    this.firstname,
    this.lastname,
    this.email,
    this.contact,
    this.image,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) => ContactModel(
        firstname: json["firstname"],
        lastname: json["lastname"],
        email: json["email"],
        contact: json["contact"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "contact": contact,
        "image": image,
      };

  Widget buildContactWidget() {
    return ListTile(
      title: Text(firstname ?? ''),
      subtitle: Text(contact ?? ''),
    );
  }
}
