class ContactModel {
  int? id;
  String? firstname;
  String? lastname;
  String? email;
  String? number;
  String? image;

  ContactModel({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.number,
    this.image,
  });
}
