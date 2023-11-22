import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taguigconnect/constants/color_constant.dart';
import 'package:taguigconnect/constants/endpoint_constant.dart';
import 'package:taguigconnect/models/user_model.dart';
import 'package:taguigconnect/services/user_service.dart';

class AccountEditWidget extends StatefulWidget {
  final VoidCallback callbackFunction;
  final UserModel userModel;
  const AccountEditWidget(
      {super.key, required this.userModel, required this.callbackFunction});

  @override
  State<AccountEditWidget> createState() => _AccountEditWidgetState();
}

class _AccountEditWidgetState extends State<AccountEditWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _middleNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _ageFocus = FocusNode();
  final FocusNode _birthdayFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();
  final FocusNode _contactFocus = FocusNode();
  DateTime selectedDate = DateTime.now();
  bool isLoading = false;
  XFile? _image;
  String? imageUrl;

  Future<void> updateUser(UserModel userdata) async {
    try {
      final userService = UserService();
      final response = await userService.patchUser(userdata);

      if (response) {
        widget.callbackFunction.call();
        Navigator.pop(
          context,
        );
        print('Update Success');
      } else {
        print('Update Failed');
      }
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  Future<void> requestCameraPermission() async {
    var status = await Permission.camera.request();

    if (status.isGranted) {
      _takePhoto();
    } else {
      if (status.isPermanentlyDenied) {
        openAppSettings();
      } else {
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

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = pickedImage;
    });
  }

  void _takePhoto() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = pickedImage;
    });
  }

  void clearText() {
    _firstNameController.clear();
    _ageController.clear();
    _birthdayController.clear();
    _addressController.clear();
    _contactController.clear();
    _image = null;
  }

  @override
  void initState() {
    super.initState();
    _firstNameController.text = widget.userModel.firstname ?? '';
    _middleNameController.text = widget.userModel.middlename ?? '';
    _lastNameController.text = widget.userModel.lastname ?? '';
    _ageController.text = widget.userModel.age.toString();
    _birthdayController.text = widget.userModel.birthdate ?? '';
    _addressController.text = widget.userModel.address ?? '';
    _contactController.text = widget.userModel.contactnumber ?? '';
    imageUrl = widget.userModel.image != null
        ? ApiConstants.baseUrl + widget.userModel.image!
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tcWhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: CloseButton(),
        iconTheme: const IconThemeData(color: tcBlack),
        backgroundColor: tcWhite,
        elevation: 0,
        title: Text(
          'EDIT',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: tcBlack,
            fontFamily: 'Roboto',
            fontSize: 20.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(10.0),
                              color: tcWhite,
                              border: Border.all(
                                width: 1,
                                color: tcBlack,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: _image != null
                                  ? Image.file(
                                      File(_image!.path),
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    )
                                  : imageUrl != null
                                      ? Image.network(
                                          imageUrl!,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        )
                                      : Icon(
                                          Icons.question_mark,
                                          color: tcBlack,
                                          size: 50,
                                        ),
                            ),
                          ),
                          VerticalDivider(
                            color: tcWhite,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 200.w,
                                height: 40.h,
                                child: ElevatedButton(
                                  onPressed: () => setState(() {
                                    _takePhoto();
                                  }),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: tcWhite,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
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
                                      color: tcBlack,
                                    ),
                                  ),
                                ),
                              ),
                              Divider(
                                color: tcWhite,
                              ),
                              Container(
                                width: 200.w,
                                height: 40.h,
                                child: ElevatedButton(
                                  onPressed: () => setState(() {
                                    _pickImage();
                                  }),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: tcWhite,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
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
                                      color: tcBlack,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.transparent,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.name,
                        controller: _firstNameController,
                        focusNode: _firstNameFocus,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: tcBlack,
                        ),
                        decoration: InputDecoration(
                          labelText: 'First Name',
                          labelStyle: TextStyle(
                            fontFamily: 'PublicSans',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          errorMaxLines: 2,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 14, horizontal: 10),
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
                      TextFormField(
                        keyboardType: TextInputType.name,
                        controller: _middleNameController,
                        focusNode: _middleNameFocus,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: tcBlack,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Middle Name',
                          labelStyle: TextStyle(
                            fontFamily: 'PublicSans',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          errorMaxLines: 2,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 14, horizontal: 10),
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
                      TextFormField(
                        keyboardType: TextInputType.name,
                        controller: _lastNameController,
                        focusNode: _lastNameFocus,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: tcBlack,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Last Name',
                          labelStyle: TextStyle(
                            fontFamily: 'PublicSans',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          errorMaxLines: 2,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 14, horizontal: 10),
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
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _ageController,
                        focusNode: _ageFocus,
                        textAlign: TextAlign.start,
                        maxLength: 3,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: tcBlack,
                        ),
                        decoration: InputDecoration(
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
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 14, horizontal: 10),
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
                        validator: (value) => validateAge(value!),
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
                          color: tcBlack,
                        ),
                        decoration: InputDecoration(
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
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 14, horizontal: 10),
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
                          suffixIcon: IconButton(
                            onPressed: () async {
                              if (_birthdayController.text.isNotEmpty) {
                                try {
                                  selectedDate =
                                      DateTime.parse(_birthdayController.text);
                                } catch (e) {
                                  print(
                                      'Invalid date format: ${_birthdayController.text}');
                                }
                              }

                              final DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );

                              if (pickedDate != null &&
                                  pickedDate != selectedDate) {
                                setState(() {
                                  selectedDate = pickedDate;

                                  // Format the selected date and set it to the dateController.text
                                  final formattedDate = DateFormat('yyyy/MM/dd')
                                      .format(pickedDate);
                                  _birthdayController.text = formattedDate;
                                });
                              }
                            },
                            icon: Icon(Icons.calendar_month),
                          ),
                        ),
                      ),
                      Divider(
                        color: tcWhite,
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
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 10),
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
                      Divider(
                        color: tcWhite,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.streetAddress,
                        controller: _addressController,
                        focusNode: _addressFocus,
                        textAlign: TextAlign.start,
                        maxLines: 3,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: tcBlack,
                        ),
                        decoration: InputDecoration(
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
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 10),
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
                        validator: (value) => validateAddress(value!),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.transparent,
                ),
                Container(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_image != null) {
                        final imageByte = await convertXFileToBase64(_image);
                        if (_formKey.currentState != null &&
                            _formKey.currentState!.validate()) {
                          final data = UserModel(
                            firstname: _firstNameController.text,
                            middlename: _middleNameController.text,
                            lastname: _lastNameController.text,
                            age: int.parse(_ageController.text),
                            birthdate: _birthdayController.text,
                            contactnumber: _contactController.text,
                            address: _addressController.text,
                            image: imageByte.toString(),
                          );
                          setState(() {
                            isLoading == true;
                          });

                          await updateUser(data);

                          setState(() {
                            isLoading == false;
                          });
                        }
                      } else {
                        if (_formKey.currentState != null &&
                            _formKey.currentState!.validate()) {
                          final data = UserModel(
                            firstname: _firstNameController.text,
                            middlename: _middleNameController.text,
                            lastname: _lastNameController.text,
                            age: int.parse(_ageController.text),
                            birthdate: _birthdayController.text,
                            contactnumber: _contactController.text,
                            address: _addressController.text,
                            image: null,
                          );
                          setState(() {
                            isLoading == true;
                          });

                          await updateUser(data);

                          setState(() {
                            isLoading == false;
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
                              color: tcWhite,
                            ),
                          )
                        : Text(
                            'Update',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'PublicSans',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: tcWhite,
                            ),
                          ),
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

String? validateName(String value) {
  if (value.isEmpty) {
    return 'Please enter your full name';
  }

  // Check if the name contains numbers
  if (RegExp(r'\d').hasMatch(value)) {
    return 'Name should not contain numbers';
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
      return 'Age should be between 0 and 120';
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

  // Parse and validate the date using intl's DateFormat
  final dateFormat = DateFormat('yyyy/MM/dd');
  DateTime? date;
  try {
    date = dateFormat.parse(value);
  } catch (e) {
    return 'Invalid date';
  }

  // Calculate the expected birth year based on the user's age
  final today = DateTime.now();
  var expectedBirthYear = today.year - userAge;

  // Consider the cases where the birthday has not occurred yet
  if (today.month < date.month ||
      (today.month == date.month && today.day < date.day)) {
    expectedBirthYear--; // Decrease the expected year if the birthday hasn't occurred yet
  }

  // Ensure the birth year matches the user's age
  if (date.year != expectedBirthYear) {
    return 'Birth year should match your age';
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

Future<String?> convertXFileToBase64(XFile? imageFile) async {
  if (imageFile == null) {
    return null; // Handle the case where there is no image.
  }

  final Uint8List uint8list = await imageFile.readAsBytes();
  final String base64String = base64Encode(uint8list);

  return base64String;
}
