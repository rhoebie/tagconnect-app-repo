import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:TagConnect/animations/slideLeft_animation.dart';
import 'package:TagConnect/configs/network_config.dart';
import 'package:TagConnect/configs/request_config.dart';
import 'package:TagConnect/constants/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:TagConnect/screens/login_screen.dart';
import 'package:TagConnect/services/user_service.dart';

// variables

final TextEditingController _firstNameController = TextEditingController();
final TextEditingController _middleNameController = TextEditingController();
final TextEditingController _lastNameController = TextEditingController();
final TextEditingController _ageController = TextEditingController();
final TextEditingController _birthdayController = TextEditingController();
final TextEditingController _addressController = TextEditingController();
final TextEditingController _contactController = TextEditingController();
final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();
final TextEditingController _confirmPassController = TextEditingController();
final FocusNode _firstNameFocus = FocusNode();
final FocusNode _middleNameFocus = FocusNode();
final FocusNode _lastNameFocus = FocusNode();
final FocusNode _ageFocus = FocusNode();
final FocusNode _birthdayFocus = FocusNode();
final FocusNode _addressFocus = FocusNode();
final FocusNode _contactFocus = FocusNode();
final FocusNode _emailFocus = FocusNode();
final FocusNode _passwordFocus = FocusNode();
final FocusNode _confirmPassFocus = FocusNode();
DateTime selectedDate = DateTime.now();
bool isEnabled = false;
bool hasUppercase = false;
bool hasLowercase = false;
bool hasSpecialChar = false;
bool hasDigit = false;
bool is6char = false;
XFile? _image;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> requestCameraPermission() async {
    try {
      final cameraStatus = await RequestService.cameraPermission();
      if (cameraStatus) {
        _takePhoto();
      } else {
        if (mounted) {
          setState(
            () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Permission Denied'),
                  content: const Text(
                      'You must grant the camera permission for this to work'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => {Navigator.pop(context, 'OK')},
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          );
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> requesetGalleryPermission() async {
    try {
      final galleryStatus = await RequestService.galleryPermission();
      if (galleryStatus) {
        _pickImage();
      } else {
        if (mounted) {
          setState(
            () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Permission Denied'),
                  content: const Text(
                      'You must grant the gallery permission for this to work'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => {Navigator.pop(context, 'OK')},
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          );
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (mounted) {
      setState(() {
        _image = pickedImage;
      });
    }
  }

  void _takePhoto() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);

    if (mounted) {
      setState(() {
        _image = pickedImage;
      });
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
        backgroundColor: backgroundColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: RichText(
          textAlign: TextAlign.start,
          text: TextSpan(
            style: TextStyle(
              fontFamily: 'PublicSans',
              fontSize: 20.sp,
              fontWeight: FontWeight.w900,
              color: tcViolet,
            ),
            children: [
              TextSpan(
                text: 'TAG',
              ),
              TextSpan(
                text: 'CONNECT',
                style: TextStyle(
                  color: tcRed,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SIGN UP',
                      style: TextStyle(
                        fontFamily: 'PublicSans',
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w900,
                        color: textColor,
                      ),
                    ),
                    Text(
                      'Part 1/3',
                      style: TextStyle(
                        fontFamily: 'PublicSans',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: tcGray,
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
                          Text(
                            'Personal Information',
                            style: TextStyle(
                              fontFamily: 'PublicSans',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: textColor,
                            ),
                          ),
                          Divider(
                            color: Colors.transparent,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: backgroundColor,
                                  border: Border.all(
                                    width: 1,
                                    color: textColor,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: _image != null
                                      ? Image.file(
                                          File(_image!.path),
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        )
                                      : Icon(
                                          Icons.question_mark,
                                          color: textColor,
                                          size: 50,
                                        ),
                                ),
                              ),
                              VerticalDivider(
                                color: backgroundColor,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 200.w,
                                    height: 40.h,
                                    child: ElevatedButton(
                                      onPressed: requestCameraPermission,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: backgroundColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        elevation: 2,
                                      ),
                                      child: Text(
                                        'Camera',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'PublicSans',
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: textColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    color: backgroundColor,
                                  ),
                                  Container(
                                    width: 200.w,
                                    height: 40.h,
                                    child: ElevatedButton(
                                      onPressed: requesetGalleryPermission,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: backgroundColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        elevation: 2,
                                      ),
                                      child: Text(
                                        'Gallery',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'PublicSans',
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: textColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Divider(
                            color: backgroundColor,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.name,
                            controller: _firstNameController,
                            focusNode: _firstNameFocus,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: textColor,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 10),
                              labelText: 'First Name',
                              labelStyle: TextStyle(
                                fontFamily: 'PublicSans',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                              ),
                              errorMaxLines: 2,
                              hintText: 'Enter First Name',
                              hintStyle: TextStyle(
                                fontFamily: 'PublicSans',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: tcGray,
                              ),
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
                            validator: (value) => validateFirstName(value!),
                          ),
                          Divider(
                            color: backgroundColor,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.name,
                            controller: _middleNameController,
                            focusNode: _middleNameFocus,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: textColor,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 10),
                              labelText: 'Middle Name',
                              labelStyle: TextStyle(
                                fontFamily: 'PublicSans',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                              ),
                              errorMaxLines: 2,
                              hintText: 'Enter Middle Name',
                              hintStyle: TextStyle(
                                fontFamily: 'PublicSans',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: tcGray,
                              ),
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
                            validator: (value) => validateMiddleName(value!),
                          ),
                          Divider(
                            color: backgroundColor,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.name,
                            controller: _lastNameController,
                            focusNode: _lastNameFocus,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: textColor,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 10),
                              labelText: 'Last Name',
                              labelStyle: TextStyle(
                                fontFamily: 'PublicSans',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                              ),
                              errorMaxLines: 2,
                              hintText: 'Enter Last Name',
                              hintStyle: TextStyle(
                                fontFamily: 'PublicSans',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: tcGray,
                              ),
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
                            validator: (value) => validateLastName(value!),
                          ),
                          Divider(
                            color: backgroundColor,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: _ageController,
                            focusNode: _ageFocus,
                            textAlign: TextAlign.start,
                            maxLength: 3,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: textColor,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 10),
                              counterText: '',
                              labelText: 'Age',
                              labelStyle: TextStyle(
                                fontFamily: 'PublicSans',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                              ),
                              errorMaxLines: 2,
                              hintText: 'Enter your age',
                              hintStyle: TextStyle(
                                fontFamily: 'PublicSans',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: tcGray,
                              ),
                              prefixIcon: Icon(
                                Icons.numbers,
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
                            validator: (value) => validateAge(value!),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.transparent,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Back',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: tcViolet,
                            fontFamily: 'PublicSans',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        width: 80.w,
                        height: 50.h,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_image != null) {
                              if (_formKey.currentState!.validate()) {
                                Navigator.push(
                                  context,
                                  SlideLeftAnimation(
                                    RegisterScreenTwo(
                                      userAge: int.parse(_ageController.text),
                                    ),
                                  ),
                                );
                              }
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Error'),
                                  content: const Text('Image is required'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'OK'),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: tcViolet,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 2,
                          ),
                          child: Icon(
                            Icons.arrow_right_alt_outlined,
                            color: backgroundColor,
                            size: 40,
                          ),
                        ),
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

class RegisterScreenTwo extends StatefulWidget {
  final int userAge;
  RegisterScreenTwo({super.key, required this.userAge});

  @override
  State<RegisterScreenTwo> createState() => _RegisterScreenTwoState();
}

class _RegisterScreenTwoState extends State<RegisterScreenTwo> {
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color backgroundColor = theme.scaffoldBackgroundColor;
    final Color textColor = theme.colorScheme.onBackground;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: RichText(
          textAlign: TextAlign.start,
          text: TextSpan(
            style: TextStyle(
              fontFamily: 'PublicSans',
              fontSize: 20.sp,
              fontWeight: FontWeight.w900,
              color: tcViolet,
            ),
            children: [
              TextSpan(
                text: 'TAG',
              ),
              TextSpan(
                text: 'CONNECT',
                style: TextStyle(
                  color: tcRed,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SIGN UP',
                      style: TextStyle(
                        fontFamily: 'PublicSans',
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w900,
                        color: textColor,
                      ),
                    ),
                    Text(
                      'Part 2/3',
                      style: TextStyle(
                        fontFamily: 'PublicSans',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: tcGray,
                      ),
                    ),
                    Divider(
                      color: Colors.transparent,
                    ),
                    Form(
                      key: _formKey2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Personal Information',
                            style: TextStyle(
                              fontFamily: 'PublicSans',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: textColor,
                            ),
                          ),
                          Divider(
                            color: Colors.transparent,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.datetime,
                            controller: _birthdayController,
                            focusNode: _birthdayFocus,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: textColor,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 10),
                              labelText: 'Date of Birth',
                              labelStyle: TextStyle(
                                fontFamily: 'PublicSans',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                              ),
                              errorMaxLines: 2,
                              hintText: 'YYYY / MM / DD',
                              hintStyle: TextStyle(
                                fontFamily: 'PublicSans',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: tcGray,
                              ),
                              prefixIcon: Icon(
                                Icons.celebration,
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
                              suffixIcon: IconButton(
                                onPressed: () async {
                                  if (_birthdayController.text.isNotEmpty) {
                                    try {
                                      selectedDate = DateTime.parse(
                                          _birthdayController.text);
                                    } catch (e) {
                                      print(
                                          'Invalid date format: ${_birthdayController.text}');
                                    }
                                  }

                                  final DateTime? pickedDate =
                                      await showDatePicker(
                                    context: context,
                                    initialDate: selectedDate,
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now(),
                                  );

                                  if (pickedDate != null &&
                                      pickedDate != selectedDate) {
                                    if (mounted) {
                                      setState(() {
                                        selectedDate = pickedDate;

                                        // Format the selected date and set it to the dateController.text
                                        final formattedDate =
                                            DateFormat('yyyy/MM/dd')
                                                .format(pickedDate);
                                        _birthdayController.text =
                                            formattedDate;
                                      });
                                    }
                                  }
                                },
                                icon: Icon(Icons.calendar_month),
                              ),
                            ),
                            validator: (value) =>
                                validateBirthdate(value!, widget.userAge),
                          ),
                          Divider(
                            color: backgroundColor,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.phone,
                            controller: _contactController,
                            focusNode: _contactFocus,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: textColor,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 10),
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
                          Divider(
                            color: backgroundColor,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.streetAddress,
                            controller: _addressController,
                            focusNode: _addressFocus,
                            textAlign: TextAlign.start,
                            maxLines: 3,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: textColor,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 10),
                              labelText: 'Address',
                              labelStyle: TextStyle(
                                fontFamily: 'PublicSans',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                              ),
                              errorMaxLines: 2,
                              hintText: 'Enter your address',
                              hintStyle: TextStyle(
                                fontFamily: 'PublicSans',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: tcGray,
                              ),
                              prefixIcon: Icon(
                                Icons.home,
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
                            validator: (value) => validateAddress(value!),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.transparent,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Back',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: tcViolet,
                            fontFamily: 'PublicSans',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        width: 80.w,
                        height: 50.h,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey2.currentState!.validate()) {
                              Navigator.push(
                                context,
                                SlideLeftAnimation(
                                  const RegisterScreenThree(),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: tcViolet,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 2,
                          ),
                          child: Icon(
                            Icons.arrow_right_alt_outlined,
                            color: backgroundColor,
                            size: 40,
                          ),
                        ),
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

class RegisterScreenThree extends StatefulWidget {
  const RegisterScreenThree({super.key});

  @override
  State<RegisterScreenThree> createState() => _RegisterScreenThreeState();
}

class _RegisterScreenThreeState extends State<RegisterScreenThree> {
  final GlobalKey<FormState> _formKey3 = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> register({
    required String firstName,
    required String middleName,
    required String lastName,
    required int age,
    required String birthdate,
    required String contactNumber,
    required String address,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String image,
    String? token,
  }) async {
    bool isConnected = await NetworkConfig.isConnected();
    final userService = UserService();

    try {
      if (isConnected) {
        final success = await userService.registerUser(
          firstName,
          middleName,
          lastName,
          age,
          birthdate,
          contactNumber,
          address,
          email,
          password,
          passwordConfirmation,
          image,
          token,
        );

        if (success) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Register Successful"),
          ));
          Navigator.push(
            context,
            SlideLeftAnimation(VerificationScreen(userEmail: email)),
          );
          clearText();
        } else {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Register Failed, Please try again later."),
          ));
        }
      } else {
        if (mounted) {
          setState(() {
            showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('No Internet'),
                content:
                    const Text('Check your internet connection in settings'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => {Navigator.pop(context, 'OK')},
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          });
        }
      }
    } catch (e) {
      print('Error creating user: $e');
    }
  }

  Future<String?> getFCM() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('fCMToken');
      return token;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFCM();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color backgroundColor = theme.scaffoldBackgroundColor;
    final Color textColor = theme.colorScheme.onBackground;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: RichText(
          textAlign: TextAlign.start,
          text: TextSpan(
            style: TextStyle(
              fontFamily: 'PublicSans',
              fontSize: 20.sp,
              fontWeight: FontWeight.w900,
              color: tcViolet,
            ),
            children: [
              TextSpan(
                text: 'TAG',
              ),
              TextSpan(
                text: 'CONNECT',
                style: TextStyle(
                  color: tcRed,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SIGN UP',
                        style: TextStyle(
                          fontFamily: 'PublicSans',
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w900,
                          color: textColor,
                        ),
                      ),
                      Text(
                        'Part 3/3',
                        style: TextStyle(
                          fontFamily: 'PublicSans',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: tcGray,
                        ),
                      ),
                      Divider(
                        color: backgroundColor,
                      ),
                      Form(
                        key: _formKey3,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Account Setup',
                                  style: TextStyle(
                                    fontFamily: 'PublicSans',
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              color: Colors.transparent,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              controller: _emailController,
                              focusNode: _emailFocus,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: textColor,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 10),
                                labelText: 'Email',
                                labelStyle: TextStyle(
                                  fontFamily: 'PublicSans',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                                errorMaxLines: 2,
                                hintText: 'Enter your Email Address',
                                hintStyle: TextStyle(
                                  fontFamily: 'PublicSans',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: tcGray,
                                ),
                                prefixIcon: Icon(
                                  Icons.email,
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
                              validator: (value) => validateEmail(value!),
                            ),
                            Divider(
                              color: backgroundColor,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.visiblePassword,
                              controller: _passwordController,
                              focusNode: _passwordFocus,
                              obscureText: true,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: textColor,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 10),
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                  fontFamily: 'PublicSans',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                                errorMaxLines: 2,
                                hintText: 'Minimum of 6 characters',
                                hintStyle: TextStyle(
                                  fontFamily: 'PublicSans',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: tcGray,
                                ),
                                prefixIcon: Icon(
                                  Icons.lock,
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
                              validator: (value) => validatePassword(value!),
                              onChanged: (value) {
                                setState(() {
                                  hasUppercase =
                                      value.contains(RegExp(r'[A-Z]'));
                                  hasLowercase =
                                      value.contains(RegExp(r'[a-z]'));
                                  hasSpecialChar = value.contains(
                                      RegExp(r'[!@#\$%^&*(),.?":{}|<>-]'));
                                  hasDigit = value.contains(RegExp(r'[0-9]'));
                                  is6char = value.length >= 6;
                                });
                              },
                            ),
                            Divider(
                              color: backgroundColor,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.visiblePassword,
                              controller: _confirmPassController,
                              focusNode: _confirmPassFocus,
                              obscureText: true,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: textColor,
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Password cannot be empty';
                                } else if (value != _passwordController.text) {
                                  return 'Password do not match';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 10),
                                labelText: 'Confirm Password',
                                labelStyle: TextStyle(
                                  fontFamily: 'PublicSans',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                                errorMaxLines: 2,
                                hintText: 'Minimum of 6 characters',
                                hintStyle: TextStyle(
                                  fontFamily: 'PublicSans',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: tcGray,
                                ),
                                prefixIcon: Icon(
                                  Icons.lock,
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
                              color: backgroundColor,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      is6char
                                          ? Icons.check_circle
                                          : Icons.circle,
                                      color: is6char ? tcGreen : tcRed,
                                    ),
                                    Text(
                                      'Is six character long',
                                      style: TextStyle(
                                        fontFamily: 'PublicSans',
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w300,
                                        color: textColor,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      hasSpecialChar
                                          ? Icons.check_circle
                                          : Icons.circle,
                                      color: hasSpecialChar ? tcGreen : tcRed,
                                    ),
                                    Text(
                                      'Has Special Character',
                                      style: TextStyle(
                                        fontFamily: 'PublicSans',
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w300,
                                        color: textColor,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      hasUppercase
                                          ? Icons.check_circle
                                          : Icons.circle,
                                      color: hasUppercase ? tcGreen : tcRed,
                                    ),
                                    Text(
                                      'Has Uppercase',
                                      style: TextStyle(
                                        fontFamily: 'PublicSans',
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w300,
                                        color: textColor,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      hasLowercase
                                          ? Icons.check_circle
                                          : Icons.circle,
                                      color: hasLowercase ? tcGreen : tcRed,
                                    ),
                                    Text(
                                      'Has Lowercase',
                                      style: TextStyle(
                                        fontFamily: 'PublicSans',
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w300,
                                        color: textColor,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      hasDigit
                                          ? Icons.check_circle
                                          : Icons.circle,
                                      color: hasDigit ? tcGreen : tcRed,
                                    ),
                                    Text(
                                      'Has Digit',
                                      style: TextStyle(
                                        fontFamily: 'PublicSans',
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w300,
                                        color: textColor,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: backgroundColor,
                  height: 30,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Back',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: tcViolet,
                            fontFamily: 'PublicSans',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        width: 120.w,
                        height: 50.h,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey3.currentState!.validate()) {
                              if (mounted) {
                                setState(() {
                                  isLoading = true;
                                });
                              }

                              //final fcmToken = await getFCM();
                              final byte64Image =
                                  await convertXFileToBase64(_image);

                              await register(
                                  firstName: _firstNameController.text,
                                  middleName: _middleNameController.text,
                                  lastName: _lastNameController.text,
                                  age: int.parse(_ageController.text),
                                  birthdate: _birthdayController.text,
                                  contactNumber: _contactController.text,
                                  address: _addressController.text,
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                  passwordConfirmation:
                                      _confirmPassController.text,
                                  image: byte64Image ?? '',
                                  token: '');

                              if (mounted) {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: tcViolet,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 2,
                          ),
                          child: isLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      backgroundColor,
                                    ),
                                    strokeWidth: 3,
                                  ),
                                )
                              : Text(
                                  'Register',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'PublicSans',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: backgroundColor,
                                  ),
                                ),
                        ),
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

class VerificationScreen extends StatefulWidget {
  final String userEmail;
  const VerificationScreen({super.key, required this.userEmail});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController txtOne = TextEditingController();
  final TextEditingController txtTwo = TextEditingController();
  final TextEditingController txtThree = TextEditingController();
  final TextEditingController txtFour = TextEditingController();
  final TextEditingController txtFive = TextEditingController();
  final TextEditingController txtSix = TextEditingController();

  final FocusNode fnOne = FocusNode();
  final FocusNode fnTwo = FocusNode();
  final FocusNode fnThree = FocusNode();
  final FocusNode fnFour = FocusNode();
  final FocusNode fnFive = FocusNode();
  final FocusNode fnSix = FocusNode();

  Future<void> verifyCode({
    required String email,
    required String code,
  }) async {
    final userService = UserService();
    try {
      final response = await userService.verify(email, code);
      if (response) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Email Verified"),
        ));
        Navigator.push(context, SlideLeftAnimation(LoginScreen()));
      } else {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Failed to Provide code"),
        ));
      }
    } catch (e) {
      print('Error creating user: $e');
    }
  }

  Future<void> sendCode(String email) async {
    try {
      final userService = UserService();
      final response = await userService.sendCode(email);
      if (response) {
        print('Code sent');
      } else {
        print('Code sent failed');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  String combineTextControllers() {
    final combinedText = StringBuffer();

    combinedText.write(txtOne.text);
    combinedText.write(txtTwo.text);
    combinedText.write(txtThree.text);
    combinedText.write(txtFour.text);
    combinedText.write(txtFive.text);
    combinedText.write(txtSix.text);

    return combinedText.toString();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color backgroundColor = theme.scaffoldBackgroundColor;
    final Color textColor = theme.colorScheme.onBackground;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: RichText(
          textAlign: TextAlign.start,
          text: TextSpan(
            style: TextStyle(
              fontFamily: 'PublicSans',
              fontSize: 20.sp,
              fontWeight: FontWeight.w900,
              color: tcViolet,
            ),
            children: [
              TextSpan(
                text: 'TAG',
              ),
              TextSpan(
                text: 'CONNECT',
                style: TextStyle(
                  color: tcRed,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'OTP VERIFICATION',
                style: TextStyle(
                  fontFamily: 'PublicSans',
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w900,
                  color: textColor,
                ),
              ),
              Text(
                'Provide the 6 digit code',
                style: TextStyle(
                  fontFamily: 'PublicSans',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: tcGray,
                ),
              ),
              Divider(
                color: backgroundColor,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 50,
                          child: TextFormField(
                            controller: txtOne,
                            focusNode: fnOne,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                                fontSize: 25,
                                color: tcViolet,
                                fontWeight: FontWeight.w700),
                            maxLength: 1,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 10),
                              counterText: '',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: tcGray,
                                  width: 2.w,
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
                            ),
                            onChanged: (value) {
                              if (value.length == 1) {
                                FocusScope.of(context).requestFocus(fnTwo);
                              }
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Empty';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          width: 50,
                          child: TextFormField(
                            controller: txtTwo,
                            focusNode: fnTwo,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                                fontSize: 25,
                                color: tcViolet,
                                fontWeight: FontWeight.w700),
                            maxLength: 1,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 10),
                              counterText: '',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: tcGray,
                                  width: 2.w,
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
                            ),
                            onChanged: (value) {
                              if (value.length == 1) {
                                FocusScope.of(context).requestFocus(fnThree);
                              } else if (value.length == 0) {
                                FocusScope.of(context).requestFocus(fnOne);
                              }
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Empty';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          width: 50,
                          child: TextFormField(
                            controller: txtThree,
                            focusNode: fnThree,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                                fontSize: 25,
                                color: tcViolet,
                                fontWeight: FontWeight.w700),
                            maxLength: 1,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 10),
                              counterText: '',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: tcGray,
                                  width: 2.w,
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
                            ),
                            onChanged: (value) {
                              if (value.length == 1) {
                                FocusScope.of(context).requestFocus(fnFour);
                              } else if (value.length == 0) {
                                FocusScope.of(context).requestFocus(fnTwo);
                              }
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Empty';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          width: 50,
                          child: TextFormField(
                            controller: txtFour,
                            focusNode: fnFour,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                                fontSize: 25,
                                color: tcViolet,
                                fontWeight: FontWeight.w700),
                            maxLength: 1,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 10),
                              counterText: '',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: tcGray,
                                  width: 2.w,
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
                            ),
                            onChanged: (value) {
                              if (value.length == 1) {
                                FocusScope.of(context).requestFocus(fnFive);
                              } else if (value.length == 0) {
                                FocusScope.of(context).requestFocus(fnThree);
                              }
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Empty';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          width: 50,
                          child: TextFormField(
                            controller: txtFive,
                            focusNode: fnFive,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                                fontSize: 25,
                                color: tcViolet,
                                fontWeight: FontWeight.w700),
                            maxLength: 1,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 10),
                              counterText: '',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: tcGray,
                                  width: 2.w,
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
                            ),
                            onChanged: (value) {
                              if (value.length == 1) {
                                FocusScope.of(context).requestFocus(fnSix);
                              } else if (value.length == 0) {
                                FocusScope.of(context).requestFocus(fnFour);
                              }
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Empty';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          width: 50,
                          child: TextFormField(
                            controller: txtSix,
                            focusNode: fnSix,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                                fontSize: 25,
                                color: tcViolet,
                                fontWeight: FontWeight.w700),
                            maxLength: 1,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 10),
                              counterText: '',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: tcGray,
                                  width: 2.w,
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
                            ),
                            onChanged: (value) {
                              if (value.length == 1) {
                                FocusScope.of(context).unfocus();
                              } else if (value.length == 0) {
                                FocusScope.of(context).requestFocus(fnFive);
                              }
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Empty';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.transparent,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Didn\'t receive code? ',
                    style: TextStyle(
                        fontFamily: 'PublicSans',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: textColor),
                  ),
                  TextButton(
                    onPressed: () {
                      sendCode(widget.userEmail);
                    },
                    child: Text(
                      'Resend OTP',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'PublicSans',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: tcViolet),
                    ),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState != null &&
                        _formKey.currentState!.validate()) {
                      final printText = txtOne.text +
                          txtTwo.text +
                          txtThree.text +
                          txtFour.text +
                          txtFive.text +
                          txtSix.text;
                      verifyCode(email: widget.userEmail, code: printText);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tcViolet,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    'Verify',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PublicSans',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: backgroundColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String? validateFirstName(String value) {
  if (value.isEmpty) {
    return 'Please enter your first name';
  }

  // Check if the name contains numbers
  if (RegExp(r'\d').hasMatch(value)) {
    return 'first name should not contain numbers';
  }

  return null; // Return null if the name is valid
}

String? validateMiddleName(String value) {
  if (value.isEmpty) {
    return 'Please enter your middle name';
  }

  // Check if the name contains numbers
  if (RegExp(r'\d').hasMatch(value)) {
    return 'middle name should not contain numbers';
  }

  return null; // Return null if the name is valid
}

String? validateLastName(String value) {
  if (value.isEmpty) {
    return 'Please enter your last name';
  }

  // Check if the name contains numbers
  if (RegExp(r'\d').hasMatch(value)) {
    return 'last name should not contain numbers';
  }

  return null; // Return null if the name is valid
}

String? validateAge(String value) {
  if (value.isEmpty) {
    return 'Please enter your age';
  }
  int age;
  try {
    age = int.parse(value);
    if (age < 0 || age > 120) {
      return 'Age should be between 0 and 150';
    }
  } catch (e) {
    return 'Age should be a valid number';
  }
  return null; // Return null if the age is valid
}

String? validateBirthdate(String value, int userAge) {
  if (value.isEmpty) {
    return 'Please enter your birthdate';
  }

  // Define a regular expression pattern to match the YYYY/MM/DD format
  const pattern = r'^\d{4}/(0[1-9]|1[0-2])/(0[1-9]|[12][0-9]|3[01])$';
  final regExp = RegExp(pattern);

  if (!regExp.hasMatch(value)) {
    return 'Birthdate should be in the YYYY/MM/DD format';
  }

  return null; // Return null if the birthdate is valid
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

String? validateAddress(String value) {
  if (value.isEmpty) {
    return 'Please enter your address';
  }

  return null; // Return null if the address is valid
}

String? validateEmail(String value) {
  if (value.isEmpty) {
    return 'Please enter an email address';
  }

  // Use a regular expression to check if the input is in a valid email format
  final emailPattern =
      RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)*(\.[a-z]{2,})$');

  if (!emailPattern.hasMatch(value)) {
    return 'Please enter a valid email address';
  }

  return null; // Return null if the email is valid
}

String? validatePassword(String value) {
  if (value.isEmpty) {
    return 'Please enter a password';
  }

  if (value.length < 6) {
    return 'Password should be at least 6 characters long';
  }

  // Define regular expressions to check for uppercase, lowercase, digit, and special character
  final hasUppercase = RegExp(r'[A-Z]').hasMatch(value);
  final hasLowercase = RegExp(r'[a-z]').hasMatch(value);
  final hasDigit = RegExp(r'[0-9]').hasMatch(value);
  final hasSpecialChar = RegExp(r'[!@#\$%^&*(),.?":{}|<>-]')
      .hasMatch(value); // Include hyphen in special characters

  if (!(hasUppercase && hasLowercase && hasDigit && hasSpecialChar)) {
    return 'Password should contain at least one uppercase, one lowercase, one number, and one special character (including hyphen).';
  }

  return null; // Return null if the password is valid
}

Future<String?> convertXFileToBase64(XFile? imageFile) async {
  if (imageFile == null) {
    return null; // Handle the case where there is no image.
  }

  final Uint8List uint8list = await imageFile.readAsBytes();
  final String base64String = base64Encode(uint8list);

  return base64String;
}

void clearText() {
  _firstNameController.clear();
  _middleNameController.clear();
  _lastNameController.clear();
  _ageController.clear();
  _birthdayController.clear();
  _addressController.clear();
  _contactController.clear();
  _emailController.clear();
  _passwordController.clear();
  _confirmPassController.clear();
  _image = null;
  isEnabled = false;
  hasUppercase = false;
  hasLowercase = false;
  hasSpecialChar = false;
  hasDigit = false;
  is6char = false;
}
