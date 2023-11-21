import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taguigconnect/configs/request_service.dart';
import 'package:taguigconnect/constants/color_constant.dart';
import 'package:taguigconnect/models/barangay_model.dart';
import 'package:taguigconnect/models/create-report_model.dart';
import 'package:taguigconnect/services/report_service.dart';

class ReportEmergencyScreen extends StatefulWidget {
  const ReportEmergencyScreen({super.key});

  @override
  State<ReportEmergencyScreen> createState() => _ReportEmergencyScreenState();
}

class _ReportEmergencyScreenState extends State<ReportEmergencyScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  final FocusNode _descriptionFocus = FocusNode();
  late List<BarangayModel> barangayData = [];
  BarangayModel? specificBarangay;
  String? selectedEmergencyType;
  String? selectedForWhom;
  bool? selectedCasualties;
  bool anotherperson = false;
  String? locationData;
  String? _imageName;
  double? userLatitude;
  double? userLongitude;
  XFile? _image;
  bool isLoading = false;
  double? screenWidth;

  Future<void> requesetGalleryPermission() async {
    try {
      final galleryStatus = await RequestService.galleryPermission();
      if (galleryStatus) {
        _pickImage();
      } else {
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
    } catch (e) {
      print('Error: $e');
    }
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      // Extract the file name from the image path
      final imageName = pickedImage.path.split('/').last;
      if (mounted) {
        setState(() {
          _imageName = imageName;
          _image = pickedImage;
        });
      }
    }
  }

  void _clearImage() {
    if (mounted) {
      setState(() {
        _imageName = null;
        _image = null;
      });
    }
  }

  void _clearForm() {
    if (mounted) {
      setState(() {
        selectedEmergencyType = null;
        selectedForWhom = null;
        selectedCasualties = null;
        _descriptionController.clear();
        _imageName = null;
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

  Future<void> fetchLocationData() async {
    try {
      final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
      final Position position = await geolocator.getCurrentPosition(
        locationSettings: AndroidSettings(accuracy: LocationAccuracy.best),
      );
      setState(() {
        userLatitude = position.latitude;
        userLongitude = position.longitude;
      });
      print('Latitude: $userLatitude, Longitude: $userLongitude');
    } catch (e) {
      print('Error fetching location: $e');
    }
  }

  Future<void> submitReport(
      String emergencyType, forWhom, description, casualties, imahe) async {
    final reportService = ReportService();

    try {
      await fetchLocationData();
      final locationUser =
          userLoc(latitude: userLatitude!, longitude: userLongitude!);

      final reportMod = CreateReportModel(
          emergencyType: emergencyType,
          forWhom: forWhom,
          description: description,
          casualties: casualties,
          location: locationUser,
          image: imahe);

      final response = await reportService.createReport(reportMod);

      if (response) {
        _clearForm();
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tcWhite,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: CloseButton(),
        iconTheme: IconThemeData(color: tcBlack),
        backgroundColor: tcWhite,
        elevation: 0,
        title: Text(
          'ADD REPORT',
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'EMERGENCY TYPE',
                              style: TextStyle(
                                fontFamily: 'PublicSans',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: tcBlack,
                              ),
                            ),
                            VerticalDivider(
                              color: Colors.transparent,
                              width: 5,
                            ),
                            Text(
                              '(required)',
                              style: TextStyle(
                                fontFamily: 'PublicSans',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: tcGray,
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.transparent,
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: tcBlack),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                              border: InputBorder.none,
                            ),
                            value: selectedEmergencyType,
                            items: [
                              DropdownMenuItem<String>(
                                value: 'General',
                                child: Text(
                                  'General',
                                  style: TextStyle(
                                    fontFamily: 'PublicSans',
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: tcBlack,
                                  ),
                                ),
                              ),
                              DropdownMenuItem<String>(
                                value: 'Medical',
                                child: Text(
                                  'Medical',
                                  style: TextStyle(
                                    fontFamily: 'PublicSans',
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: tcBlack,
                                  ),
                                ),
                              ),
                              DropdownMenuItem<String>(
                                value: 'Fire',
                                child: Text(
                                  'Fire',
                                  style: TextStyle(
                                    fontFamily: 'PublicSans',
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: tcBlack,
                                  ),
                                ),
                              ),
                              DropdownMenuItem<String>(
                                value: 'Crime',
                                child: Text(
                                  'Crime',
                                  style: TextStyle(
                                    fontFamily: 'PublicSans',
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: tcBlack,
                                  ),
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                selectedEmergencyType = value;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Please select an emergency type';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.transparent,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'FOR WHOM?',
                              style: TextStyle(
                                fontFamily: 'PublicSans',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: tcBlack,
                              ),
                            ),
                            VerticalDivider(
                              color: Colors.transparent,
                              width: 5,
                            ),
                            Text(
                              '(required)',
                              style: TextStyle(
                                fontFamily: 'PublicSans',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: tcGray,
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.transparent,
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: tcBlack),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                              border: InputBorder.none,
                            ),
                            value: selectedForWhom,
                            items: [
                              DropdownMenuItem<String>(
                                value: 'Myself',
                                child: Text(
                                  'Myself',
                                  style: TextStyle(
                                    fontFamily: 'PublicSans',
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: tcBlack,
                                  ),
                                ),
                              ),
                              DropdownMenuItem<String>(
                                value: 'Another_Person',
                                child: Text(
                                  'Another Person',
                                  style: TextStyle(
                                    fontFamily: 'PublicSans',
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: tcBlack,
                                  ),
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                selectedForWhom = value;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Please select an for whom';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.transparent,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'DESCRIPTION',
                              style: TextStyle(
                                fontFamily: 'PublicSans',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: tcBlack,
                              ),
                            ),
                            VerticalDivider(
                              color: Colors.transparent,
                              width: 5,
                            ),
                            Text(
                              '(required)',
                              style: TextStyle(
                                fontFamily: 'PublicSans',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: tcGray,
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.transparent,
                          height: 10,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          controller: _descriptionController,
                          focusNode: _descriptionFocus,
                          textAlign: TextAlign.start,
                          maxLines: 3,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: tcBlack,
                          ),
                          decoration: InputDecoration(
                            errorMaxLines: 2,
                            hintText: 'Describe the situation',
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
                          validator: (value) {
                            if (value == null) {
                              return 'Please enter the description';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.transparent,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          "ANY CASUALTIES?",
                          style: TextStyle(
                            fontFamily: 'PublicSans',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: tcBlack,
                          ),
                        ),
                        Radio(
                          value: true,
                          groupValue: selectedCasualties,
                          onChanged: (value) {
                            setState(() {
                              selectedCasualties = value;
                            });
                          },
                        ),
                        Text(
                          "YES",
                          style: TextStyle(
                            fontFamily: 'PublicSans',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: tcBlack,
                          ),
                        ),
                        Radio(
                          value: false,
                          groupValue: selectedCasualties,
                          onChanged: (value) {
                            setState(() {
                              selectedCasualties = value;
                            });
                          },
                        ),
                        Text(
                          "NO",
                          style: TextStyle(
                            fontFamily: 'PublicSans',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: tcBlack,
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.transparent,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'IMAGE OF THE INCIDENT',
                              style: TextStyle(
                                fontFamily: 'PublicSans',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: tcBlack,
                              ),
                            ),
                            VerticalDivider(
                              color: Colors.transparent,
                              width: 5,
                            ),
                            Text(
                              '(optional)',
                              style: TextStyle(
                                fontFamily: 'PublicSans',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: tcGray,
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.transparent,
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: requesetGalleryPermission,
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: tcWhite,
                                    border: Border.all(
                                      color: tcBlack,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: _imageName != null
                                        ? AutoSizeText(
                                            _imageName!,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: 'PublicSans',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: tcBlack,
                                            ),
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.upload,
                                                size: 20,
                                              ),
                                              Text(
                                                'UPLOAD',
                                                style: TextStyle(
                                                  fontFamily: 'PublicSans',
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w700,
                                                  color: tcBlack,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: _clearImage,
                              icon: Icon(
                                Icons.clear,
                                color: tcBlack,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
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
                      final imageStr = await convertXFileToBase64(_image);
                      if (_formKey.currentState != null &&
                          _formKey.currentState!.validate() &&
                          selectedCasualties != null) {
                        setState(() {
                          if (mounted) {
                            isLoading = true;
                          }
                        });

                        await submitReport(
                            selectedEmergencyType!,
                            selectedForWhom,
                            _descriptionController.text,
                            selectedCasualties,
                            imageStr);

                        setState(() {
                          if (mounted) {
                            isLoading = false;
                          }
                        });
                      }
                    } else {
                      if (_formKey.currentState != null &&
                          _formKey.currentState!.validate() &&
                          selectedCasualties != null) {
                        setState(() {
                          if (mounted) {
                            isLoading = true;
                          }
                        });

                        await submitReport(
                            selectedEmergencyType!,
                            selectedForWhom,
                            _descriptionController.text,
                            selectedCasualties,
                            null);

                        setState(() {
                          if (mounted) {
                            isLoading = false;
                          }
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
                  child: isLoading != false
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Submit',
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
    );
  }
}
