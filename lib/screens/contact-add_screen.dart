import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:TagConnect/constants/color_constant.dart';
import 'package:TagConnect/models/contact_model.dart';

class ContactAddScreen extends StatefulWidget {
  final VoidCallback callbackFunction;
  const ContactAddScreen({super.key, required this.callbackFunction});

  @override
  State<ContactAddScreen> createState() => _ContactAddScreenState();
}

class _ContactAddScreenState extends State<ContactAddScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _contactFocus = FocusNode();
  XFile? _image;

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (mounted) {
      setState(() {
        _image = pickedImage;
      });
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

  Future<void> addAndSaveContact() async {
    try {
      String firstName = _firstNameController.text;
      String lastName = _lastNameController.text;
      String email = _emailController.text;
      String phoneNumber = _contactController.text;

      String? base64Image = await convertXFileToBase64(_image);

      // Read the last ID from existing contacts
      int lastId = 0;
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      File file = File('${documentsDirectory.path}/contacts.txt');
      print('${documentsDirectory.path}/contacts.txt');
      if (file.existsSync()) {
        String existingJsonData = file.readAsStringSync();
        if (existingJsonData.isNotEmpty) {
          List<Map<String, dynamic>> existingContactsData =
              (json.decode(existingJsonData) as List<dynamic>)
                  .cast<Map<String, dynamic>>();
          if (existingContactsData.isNotEmpty) {
            lastId = existingContactsData.last['id'] ?? 0;
          }
        }
      }

      ContactModel newContact = ContactModel(
        id: lastId + 1,
        firstname: firstName,
        lastname: lastName,
        email: email,
        contact: phoneNumber,
        image: base64Image,
      );

      // Read existing data
      List<Map<String, dynamic>> existingContactsData = [];
      if (file.existsSync()) {
        String existingJsonData = file.readAsStringSync();
        if (existingJsonData.isNotEmpty) {
          existingContactsData =
              (json.decode(existingJsonData) as List<dynamic>)
                  .cast<Map<String, dynamic>>();
        }
      }

      // Append new contact data
      existingContactsData.add(newContact.toJson());

      // Write combined data back to the file
      String jsonData = json.encode(existingContactsData);
      file.writeAsStringSync(jsonData);

      print('Done');
      widget.callbackFunction.call();
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color backgroundColor = theme.scaffoldBackgroundColor;
    final Color textColor = theme.colorScheme.onBackground;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        leading: const CloseButton(),
        iconTheme: IconThemeData(color: textColor),
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          'ADD CONTACTS',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor,
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
                await addAndSaveContact();
              }
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () => setState(() {
                    _pickImage();
                  }),
                  child: CircleAvatar(
                    backgroundColor: tcAsh,
                    radius: 50,
                    child: _image != null
                        ? ClipRRect(
                            borderRadius: BorderRadiusDirectional.circular(50),
                            child: Image.file(
                              File(_image!.path),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Icon(
                            Icons.photo_camera,
                            color: textColor,
                            size: 30,
                          ),
                  ),
                ),
                const Divider(
                  color: Colors.transparent,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                          children: [
                            const TextSpan(
                              text: 'First Name ',
                            ),
                            const TextSpan(
                              text: '(required)',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: tcGray,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Colors.transparent,
                        height: 5,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.name,
                        controller: _firstNameController,
                        focusNode: _firstNameFocus,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: textColor,
                        ),
                        decoration: InputDecoration(
                          errorMaxLines: 2,
                          hintText: 'Enter First Name',
                          hintStyle: TextStyle(
                            fontFamily: 'PublicSans',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: tcGray,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 10),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1.w,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: textColor,
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
                          if (value == null || value.isEmpty) {
                            return 'First Name cannot be empty';
                          }
                          return null;
                        },
                      ),
                      const Divider(
                        color: Colors.transparent,
                      ),
                      RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                          children: [
                            const TextSpan(
                              text: 'Last Name ',
                            ),
                            const TextSpan(
                              text: '(optiional)',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: tcGray,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Colors.transparent,
                        height: 5,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.name,
                        controller: _lastNameController,
                        focusNode: _lastNameFocus,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: textColor,
                        ),
                        decoration: InputDecoration(
                          errorMaxLines: 2,
                          hintText: 'Enter Last Name',
                          hintStyle: TextStyle(
                            fontFamily: 'PublicSans',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: tcGray,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 10),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1.w,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: textColor,
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
                      ),
                      const Divider(
                        color: Colors.transparent,
                      ),
                      RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                          children: [
                            const TextSpan(
                              text: 'Email Address ',
                            ),
                            const TextSpan(
                              text: '(optional)',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: tcGray,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Colors.transparent,
                        height: 5,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.name,
                        controller: _emailController,
                        focusNode: _emailFocus,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: textColor,
                        ),
                        decoration: InputDecoration(
                          errorMaxLines: 2,
                          hintText: 'Enter email',
                          hintStyle: TextStyle(
                            fontFamily: 'PublicSans',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: tcGray,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 10),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1.w,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: textColor,
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
                          if (value == null || value.isEmpty) {
                            return null;
                          } else {
                            final emailPattern = RegExp(
                                r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)*(\.[a-z]{2,})$');

                            if (!emailPattern.hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                          }
                          return null;
                        },
                      ),
                      const Divider(
                        color: Colors.transparent,
                      ),
                      RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                          children: [
                            const TextSpan(
                              text: 'Phone Number ',
                            ),
                            const TextSpan(
                              text: '(required)',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: tcGray,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Colors.transparent,
                        height: 5,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        controller: _contactController,
                        focusNode: _contactFocus,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: textColor,
                        ),
                        decoration: InputDecoration(
                          errorMaxLines: 2,
                          hintText: 'Enter number',
                          hintStyle: TextStyle(
                            fontFamily: 'PublicSans',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: tcGray,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 10),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1.w,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: textColor,
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
