import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:TagConnect/constants/color_constant.dart';
import 'package:TagConnect/models/contact_model.dart';

class ContactEditScreen extends StatefulWidget {
  final ContactModel contact;
  final VoidCallback callbackFunction;
  const ContactEditScreen({
    super.key,
    required this.contact,
    required this.callbackFunction,
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

  Uint8List decodeBase64ToUint8List(String base64String) {
    final Uint8List uint8list = base64Decode(base64String);
    return uint8list;
  }

  Future<void> updateContact(ContactModel contactModel) async {
    try {
      String firstName = _firstNameController.text;
      String lastName = _lastNameController.text;
      String email = _emailController.text;
      String phoneNumber = _contactController.text;

      String? base64Image = _image != null
          ? await convertXFileToBase64(_image)
          : contactModel.image;

      // Create a new ContactModel instance with the updated data
      ContactModel updatedContact = ContactModel(
        id: contactModel.id,
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

      // Find the index of the contact with the specified contactId
      int contactIndex = existingContactsData
          .indexWhere((contact) => contact['id'] == contactModel.id);

      if (contactIndex != -1) {
        // Update only the fields that are not null in the updatedContact
        if (updatedContact.firstname != null) {
          existingContactsData[contactIndex]['firstname'] =
              updatedContact.firstname;
        }
        if (updatedContact.lastname != null) {
          existingContactsData[contactIndex]['lastname'] =
              updatedContact.lastname;
        }
        if (updatedContact.email != null) {
          existingContactsData[contactIndex]['email'] = updatedContact.email;
        }
        if (updatedContact.contact != null) {
          existingContactsData[contactIndex]['contact'] =
              updatedContact.contact;
        }
        if (updatedContact.image != null) {
          existingContactsData[contactIndex]['image'] = updatedContact.image;
        }
      }

      // Write combined data back to the file
      String jsonData = json.encode(existingContactsData);
      file.writeAsStringSync(jsonData);

      print('Contact updated');
      widget.callbackFunction.call();
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
    final ThemeData theme = Theme.of(context);
    final Color backgroundColor = theme.scaffoldBackgroundColor;
    final Color textColor = theme.colorScheme.onBackground;
    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: CloseButton(),
        iconTheme: IconThemeData(color: textColor),
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          'EDIT CONTACTS',
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
                await updateContact(widget.contact);
              }
            },
            icon: Icon(Icons.check),
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
                child: _image != null
                    ? CircleAvatar(
                        radius: 50,
                        child: ClipRRect(
                          borderRadius: BorderRadiusDirectional.circular(50),
                          child: Image.file(
                            File(_image!.path),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : widget.contact.image != null
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
                                  color: backgroundColor,
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
                          color: textColor,
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
                          color: textColor,
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
                          color: textColor,
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
                          color: textColor,
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
