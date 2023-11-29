import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:TagConnect/configs/request_service.dart';
import 'package:TagConnect/constants/barangay_constant.dart';
import 'package:TagConnect/models/barangay_model.dart';
import 'package:TagConnect/models/create-report_model.dart';
import 'package:TagConnect/screens/report-another-person_screen.dart';
import 'package:TagConnect/screens/report-myself_screen.dart';
import 'package:TagConnect/services/report_service.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:TagConnect/constants/color_constant.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

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
  bool? selectedVisibility = true;
  String? locationData;
  String? _imageName;
  double? userLatitude;
  double? userLongitude;
  XFile? _image;
  bool isLoading = false;
  ButtonState stateOnlyText = ButtonState.idle;
  ButtonState stateTextWithIcon = ButtonState.idle;

  Future<void> requestCameraPermission() async {
    try {
      final cameraStatus = await RequestService.cameraPermission();
      if (cameraStatus) {
        _takePhoto();
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
    } catch (e) {
      print('Error: $e');
    }
  }

  void _takePhoto() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);

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
    final barangayConstant = BarangayConstant();
    LocationChecker locationChecker;
    LocationService locationService;
    locationChecker = LocationChecker(
      barangayConstant.cityTaguig,
      barangayConstant.taguigBarangays,
    );

    locationService = LocationService(locationChecker);

    try {
      final locationStats = await RequestService.locationPermission();
      if (locationStats) {
        final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
        final Position position = await geolocator.getCurrentPosition(
          locationSettings: AndroidSettings(accuracy: LocationAccuracy.best),
        );

        userLatitude = position.latitude;
        userLongitude = position.longitude;
        print('Latitude: $userLatitude, Longitude: $userLongitude');

        final locationIdk = await locationService.getUserLocation(
            userLatitude!, userLongitude!);
        setState(() {
          var type = locationIdk['type'];
          var value = locationIdk['value'];
          if (type == 'exact') {
            print('Exact Value: $value');
            locationData = value;
          } else if (type == 'near') {
            print('Near Value: $value');
            locationData = value;
          } else {
            print("Other Location: $type");
          }
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Permission'),
              content: Text('Need Location/GPS Permission'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text('Yes'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Error fetching location: $e');
    }
  }

  Future<bool> submitReport(
      String emergencyType, description, casualties, visibility, imahe) async {
    final reportService = ReportService();

    try {
      await fetchLocationData();
      final locationUser =
          userLoc(latitude: userLatitude!, longitude: userLongitude!);

      final visib = visibility != true ? 'Public' : 'Private';
      final barangayName = locationData!;

      final reportMod = CreateReportModel(
        barangayId: barangayName,
        emergencyType: emergencyType,
        forWhom: 'Another_Person',
        description: description,
        casualties: casualties,
        location: locationUser,
        visibility: visib,
        image: imahe,
      );

      final bool response = await reportService.createReport(reportMod);

      if (response) {
        return true;
      }
    } catch (e) {
      print('Error: $e');
    }
    return false;
  }

  void onPressedIconWithText(
      {required String emergencyType,
      required String description,
      required bool casualties,
      required bool visibility,
      required String? imahe}) {
    switch (stateTextWithIcon) {
      case ButtonState.idle:
        stateTextWithIcon = ButtonState.loading;
        Future.delayed(
          Duration(seconds: 1),
          () async {
            bool isSent = await submitReport(
                emergencyType, description, casualties, visibility, imahe);
            setState(
              () {
                stateTextWithIcon =
                    isSent ? ButtonState.success : ButtonState.fail;
              },
            );
            if (isSent) {
              Future.delayed(
                Duration(seconds: 1),
                () async {
                  setState(() {});
                  _clearForm();
                },
              );
            }
          },
        );
        break;
      case ButtonState.loading:
        break;
      case ButtonState.success:
        stateTextWithIcon = ButtonState.idle;
        break;
      case ButtonState.fail:
        stateTextWithIcon = ButtonState.idle;
        break;
    }
    setState(
      () {
        stateTextWithIcon = stateTextWithIcon;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tcWhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: CloseButton(),
        iconTheme: IconThemeData(color: tcBlack),
        backgroundColor: tcWhite,
        elevation: 0,
        title: Text(
          'SEND REPORT',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 20.sp,
            fontWeight: FontWeight.w900,
            color: tcBlack,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
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
                                'Emergency Type',
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
                                'Details',
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
                            "Any Casualties?",
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
                            "Yes",
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
                            "No",
                            style: TextStyle(
                              fontFamily: 'PublicSans',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: tcBlack,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            "Visibility",
                            style: TextStyle(
                              fontFamily: 'PublicSans',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: tcBlack,
                            ),
                          ),
                          Radio(
                            value: true,
                            groupValue: selectedVisibility,
                            onChanged: (value) {
                              setState(() {
                                selectedVisibility = value;
                              });
                            },
                          ),
                          Text(
                            "Private",
                            style: TextStyle(
                              fontFamily: 'PublicSans',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: tcBlack,
                            ),
                          ),
                          Radio(
                            value: false,
                            groupValue: selectedVisibility,
                            onChanged: (value) {
                              setState(() {
                                selectedVisibility = value;
                              });
                            },
                          ),
                          Text(
                            "Public",
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
                                  onTap: requestCameraPermission,
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
                                                  Icons.photo_camera,
                                                  size: 20,
                                                ),
                                                VerticalDivider(
                                                  color: Colors.transparent,
                                                  width: 5,
                                                ),
                                                Text(
                                                  'CAMERA',
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
                ProgressButton.icon(
                    iconedButtons: {
                      ButtonState.idle: IconedButton(
                          text: 'Send',
                          icon: Icon(Icons.send, color: Colors.white),
                          color: tcViolet),
                      ButtonState.loading:
                          IconedButton(text: 'Loading', color: tcViolet),
                      ButtonState.fail: IconedButton(
                          text: 'Failed',
                          icon: Icon(Icons.cancel, color: Colors.white),
                          color: Colors.red.shade300),
                      ButtonState.success: IconedButton(
                          text: 'Success',
                          icon: Icon(
                            Icons.check_circle,
                            color: Colors.white,
                          ),
                          color: Colors.green.shade400)
                    },
                    onPressed: () async {
                      if (_image != null) {
                        final imageStr = await convertXFileToBase64(_image);
                        if (_formKey.currentState != null &&
                            _formKey.currentState!.validate() &&
                            selectedCasualties != null) {
                          onPressedIconWithText(
                              emergencyType: selectedEmergencyType!,
                              description: _descriptionController.text,
                              casualties: selectedCasualties!,
                              visibility: selectedVisibility!,
                              imahe: imageStr!);
                        }
                      } else {
                        if (_formKey.currentState != null &&
                            _formKey.currentState!.validate() &&
                            selectedCasualties != null) {
                          onPressedIconWithText(
                              emergencyType: selectedEmergencyType!,
                              description: _descriptionController.text,
                              casualties: selectedCasualties!,
                              visibility: selectedVisibility!,
                              imahe: null);
                        }
                      }
                    },
                    state: stateTextWithIcon),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
