import 'dart:convert';

List<UserModel> UserModelFromJson(String str) =>
    List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

String UserModelToJson(List<UserModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserModel {
  int? id;
  String? roleId;
  String? firstname;
  String? middlename;
  String? lastname;
  int? age;
  String? birthdate;
  String? contactnumber;
  String? address;
  String? email;
  String? password;
  String? image;
  String? status;

  UserModel({
    this.id,
    this.roleId,
    required this.firstname,
    this.middlename,
    required this.lastname,
    required this.age,
    required this.birthdate,
    required this.contactnumber,
    required this.address,
    this.email,
    this.password,
    required this.image,
    this.status,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        roleId: json["role_id"],
        firstname: json["firstname"],
        middlename: json["middlename"],
        lastname: json["lastname"],
        age: json["age"],
        birthdate: json["birthdate"],
        contactnumber: json["contactnumber"],
        address: json["address"],
        email: json["email"],
        password: json["password"],
        image: json["image"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "id": id,
      "role_id": roleId,
    };
    if (email != null) {
      data["email"] = email;
    }

    if (password != null) {
      data["password"] = password;
    }

    if (firstname != null) {
      data["firstname"] = firstname;
    }

    if (middlename != null) {
      data["middlename"] = middlename;
    }

    if (lastname != null) {
      data["lastname"] = lastname;
    }

    if (age != null) {
      data["age"] = age;
    }

    if (birthdate != null) {
      data["birthdate"] = birthdate;
    }

    if (contactnumber != null) {
      data["contactnumber"] = contactnumber;
    }

    if (address != null) {
      data["address"] = address;
    }

    if (image != null) {
      data["image"] = image;
    }

    return data;
  }
}
