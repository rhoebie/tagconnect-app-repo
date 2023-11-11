import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taguigconnect/constants/color_constant.dart';
import 'package:taguigconnect/models/contact_model.dart';

class ContactEditScreen extends StatefulWidget {
  final ContactModel? contact; // Accept a ContactModel as a parameter
  const ContactEditScreen({
    super.key,
    required this.contact,
  });

  @override
  State<ContactEditScreen> createState() => _ContactEditScreenState();
}

class _ContactEditScreenState extends State<ContactEditScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _contactFocus = FocusNode();
  XFile? _image;

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = pickedImage;
    });
  }

  Future<void> updateContact(
      int id, String name, String number, String? newImage) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Get the list of contacts from SharedPreferences
    final contactsData = prefs.getStringList('contactData') ?? [];

    // Find the index of the contact to update based on its ID
    final index = contactsData.indexWhere((contactJson) {
      final contact = ContactModel.fromJson(json.decode(contactJson));
      return contact.id == id;
    });

    if (index != -1) {
      // Contact with the given ID was found
      final existingContact =
          ContactModel.fromJson(json.decode(contactsData[index]));

      // Update the contact's name and number
      existingContact.name = name;
      existingContact.number = number;

      // Update the contact's image if a new image is provided
      if (newImage != null) {
        existingContact.image = newImage;
      }

      // Update the contact in the list
      contactsData[index] = jsonEncode(existingContact.toJson());

      // Save the updated list back to SharedPreferences
      await prefs.setStringList('contactData', contactsData);

      // Check if the update was successful
      if (prefs.getStringList('contactData') != null) {
        print('Contact data updated successfully.');
      } else {
        print('Failed to update contact data.');
      }
    } else {
      print('Contact with ID $id not found.');
    }
  }

  Future<String?> convertXFileToBase64(XFile? file) async {
    if (file == null) {
      return null;
    }

    final Uint8List uint8list = await File(file.path).readAsBytes();
    final buffer = uint8list.buffer.asUint8List();
    final base64String = base64Encode(buffer);
    return base64String;
  }

  Uint8List decodeBase64ToUint8List(String base64String) {
    final Uint8List uint8list = base64Decode(base64String);
    return uint8list;
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.contact!.name!;
    _contactController.text = widget.contact!.number!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tcWhite,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: BackButton(),
        iconTheme: IconThemeData(color: tcBlack),
        backgroundColor: tcWhite,
        elevation: 0,
        title: Text(
          'EDIT CONTACTS',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: tcBlack,
            fontFamily: 'Roboto',
            fontSize: 20.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              if (_formKey.currentState != null &&
                  _formKey.currentState!.validate()) {
                final id = widget.contact!.id!;
                final name = _nameController.text;
                final number = _contactController.text;
                String? newImage;

                // Check if a new image is selected (_image is not null)
                if (_image != null) {
                  newImage = await convertXFileToBase64(_image);
                }

                // Update the contact with the provided information
                updateContact(id, name, number, newImage);

                // Close the screen or navigate back
                Navigator.pop(context);
              }
            },
            icon: Icon(Icons.check),
          ),
          VerticalDivider(
            width: 10.w,
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(15.0),
                  color: tcWhite,
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: widget.contact!.image == null
                        ? _image != null
                            ? Image.file(
                                File(_image!.path),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/images/user.png',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              )
                        : _image != null
                            ? Image.file(
                                File(_image!.path),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              )
                            : Image.memory(
                                decodeBase64ToUint8List(
                                  widget.contact!.image!,
                                ),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              )),
              ),
              Divider(
                color: Colors.transparent,
              ),
              Container(
                height: 40.h,
                child: ElevatedButton(
                  onPressed: () => setState(() {
                    _pickImage();
                  }),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tcViolet,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.browse_gallery_outlined,
                        size: 20,
                        color: tcWhite,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Update Image',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'PublicSans',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: tcWhite,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                color: Colors.transparent,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.name,
                      controller: _nameController,
                      focusNode: _nameFocus,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: tcBlack,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(
                          fontFamily: 'PublicSans',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        errorMaxLines: 2,
                        hintText: 'Enter Name',
                        hintStyle: TextStyle(
                          fontFamily: 'PublicSans',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: tcGray,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 14),
                        prefixIcon: Icon(
                          Icons.person,
                          size: 20,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1.w,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: tcBlack,
                            width: 1.w,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: tcViolet,
                            width: 2.w,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: tcRed,
                            width: 2.w,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: tcGray,
                            width: 2.w,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      validator: (value) {
                        if (value == null) {
                          return 'Name cannot be empty';
                        }
                        return null;
                      },
                    ),
                    Divider(
                      color: Colors.transparent,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      controller: _contactController,
                      focusNode: _contactFocus,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: tcBlack,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Contact',
                        labelStyle: TextStyle(
                          fontFamily: 'PublicSans',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        errorMaxLines: 2,
                        hintText: 'Enter your phonenumber',
                        hintStyle: TextStyle(
                          fontFamily: 'PublicSans',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: tcGray,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 16),
                        prefixIcon: Icon(
                          Icons.phone,
                          size: 20,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1.w,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: tcBlack,
                            width: 1.w,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: tcViolet,
                            width: 2.w,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: tcRed,
                            width: 2.w,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: tcGray,
                            width: 2.w,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      validator: (value) => validatePhoneNumber(value!),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String? validatePhoneNumber(String value) {
  if (value.isEmpty) {
    return 'Please enter your phone number';
  }

  if (value.startsWith('09') && value.length == 11) {
    return null; // Return null if the phone number is valid
  }

  return 'Invalid Format: 09 + 9 digits';
}
