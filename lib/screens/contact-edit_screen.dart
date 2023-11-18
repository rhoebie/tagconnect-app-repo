import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:taguigconnect/constants/color_constant.dart';
import 'package:taguigconnect/models/contact_model.dart';

class ContactEditScreen extends StatefulWidget {
  final ContactModel contact;
  const ContactEditScreen({
    super.key,
    required this.contact,
  });

  @override
  State<ContactEditScreen> createState() => _ContactEditScreenState();
}

class _ContactEditScreenState extends State<ContactEditScreen> {
  late ContactModel contactData;
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

    setState(() {
      _image = pickedImage;
    });
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

  Future<void> updateContact(int contactId) async {
    try {
      String firstName = _firstNameController.text;
      String lastName = _lastNameController.text;
      String email = _emailController.text;
      String phoneNumber = _contactController.text;

      String? base64Image = await convertXFileToBase64(_image);

      // Create a new ContactModel instance with the updated data
      ContactModel updatedContact = ContactModel(
        id: contactId,
        firstname: firstName,
        lastname: lastName,
        email: email,
        contact: phoneNumber,
        image: base64Image,
      );

      // Read existing data
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      File file = File('${documentsDirectory.path}/contacts.txt');
      List<Map<String, dynamic>> existingContactsData = [];
      if (file.existsSync()) {
        String existingJsonData = file.readAsStringSync();
        if (existingJsonData.isNotEmpty) {
          existingContactsData =
              (json.decode(existingJsonData) as List<dynamic>)
                  .cast<Map<String, dynamic>>();
        }
      }

      // Update the contact data in the existing data
      existingContactsData.removeWhere((contact) => contact['id'] == contactId);
      existingContactsData.add(updatedContact.toJson());

      // Write combined data back to the file
      String jsonData = json.encode(existingContactsData);
      file.writeAsStringSync(jsonData);

      print('Contact updated');
      Navigator.of(context).pop();
    } catch (e) {
      print('Error updating contact: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    contactData = widget.contact;
    _firstNameController.text =
        widget.contact.firstname != null ? widget.contact.firstname! : '';
    _lastNameController.text =
        widget.contact.lastname != null ? widget.contact.lastname! : '';
    _emailController.text =
        widget.contact.email != null ? widget.contact.email! : '';
    _contactController.text =
        widget.contact.contact != null ? widget.contact.contact! : '';
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
                await updateContact(widget.contact.id);
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
              InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () => setState(() {
                  _pickImage();
                }),
                child: CircleAvatar(
                  backgroundColor: tcAsh,
                  radius: 50,
                  child: widget.contact.image != null
                      ? CircleAvatar(
                          radius: 50,
                          backgroundColor: tcAsh,
                          backgroundImage: MemoryImage(
                            base64Decode(widget.contact.image!),
                          ),
                        )
                      : CircleAvatar(
                          radius: 50,
                          backgroundColor: tcViolet,
                          child: Center(
                            child: Text(
                              widget.contact.firstname!.isNotEmpty
                                  ? widget.contact.firstname![0].toUpperCase()
                                  : '?',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 40.sp,
                                fontWeight: FontWeight.w700,
                                color: tcWhite,
                              ),
                            ),
                          ),
                        ),
                ),
              ),
              Divider(
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
                          color: tcBlack,
                        ),
                        children: [
                          TextSpan(
                            text: 'First Name ',
                          ),
                          TextSpan(
                            text: '(required)',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: tcGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
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
                        color: tcBlack,
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
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 14, horizontal: 10),
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
                        if (value == null || value.isEmpty) {
                          return 'First Name cannot be empty';
                        }
                        return null;
                      },
                    ),
                    Divider(
                      color: Colors.transparent,
                    ),
                    RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: tcBlack,
                        ),
                        children: [
                          TextSpan(
                            text: 'Last Name ',
                          ),
                          TextSpan(
                            text: '(optiional)',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: tcGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
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
                        color: tcBlack,
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
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 14, horizontal: 10),
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
                    ),
                    Divider(
                      color: Colors.transparent,
                    ),
                    RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: tcBlack,
                        ),
                        children: [
                          TextSpan(
                            text: 'Email Address ',
                          ),
                          TextSpan(
                            text: '(optional)',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: tcGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
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
                        color: tcBlack,
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
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 14, horizontal: 10),
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
                    Divider(
                      color: Colors.transparent,
                    ),
                    RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: tcBlack,
                        ),
                        children: [
                          TextSpan(
                            text: 'Phone Number ',
                          ),
                          TextSpan(
                            text: '(required)',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: tcGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
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
                        color: tcBlack,
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
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 10),
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
