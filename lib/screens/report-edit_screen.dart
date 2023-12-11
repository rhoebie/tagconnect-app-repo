import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:TagConnect/configs/request_config.dart';
import 'package:TagConnect/constants/color_constant.dart';
import 'package:TagConnect/models/report_model.dart';
import 'package:TagConnect/models/update-report_model.dart';
import 'package:TagConnect/services/report_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_state_button/progress_button.dart';

class ReportEditScreen extends StatefulWidget {
  final ReportModel reportModel;
  const ReportEditScreen({super.key, required this.reportModel});

  @override
  State<ReportEditScreen> createState() => _ReportEditScreenState();
}

class _ReportEditScreenState extends State<ReportEditScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  final FocusNode _descriptionFocus = FocusNode();
  String? selectedEmergencyType;
  String? selectedForWhom;
  bool? selectedCasualties;
  bool? selectedVisibility;
  ButtonState stateOnlyText = ButtonState.idle;
  ButtonState stateTextWithIcon = ButtonState.idle;
  XFile? _image;

  Future<String?> convertXFileToBase64(XFile? file) async {
    if (file == null) {
      return null;
    }

    final Uint8List uint8list = await File(file.path).readAsBytes();
    final buffer = uint8list.buffer.asUint8List();
    final base64String = base64Encode(buffer);
    return base64String;
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

    if (pickedImage != null) {
      if (mounted) {
        setState(() {
          _image = pickedImage;
        });
      }
    }
  }

  void _clearImage() {
    if (mounted) {
      setState(() {
        _image = null;
      });
    }
  }

  Future<bool> updateReport(
      String emergencyType,
      String forWhom,
      String description,
      bool casualties,
      bool visibility,
      String? imahe) async {
    final reportService = ReportService();

    try {
      final visib = visibility != true ? 'Public' : 'Private';

      final reportMod = UpdateReportModel(
        emergencyType: emergencyType,
        forWhom: forWhom,
        description: description,
        casualties: casualties,
        visibility: visib,
        image: imahe,
      );

      final bool response =
          await reportService.patchReport(widget.reportModel.id!, reportMod);

      if (response) {
        print('Success');
        return true;
      }
    } catch (e) {
      print('Error: $e');
    }
    return false;
  }

  void _clearForm() {
    if (mounted) {
      setState(() {
        selectedEmergencyType = null;
        selectedCasualties = null;
        _descriptionController.clear();
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.reportModel.location!.latitude!);
    selectedEmergencyType = widget.reportModel.emergencyType!;
    _descriptionController.text = widget.reportModel.description ?? '';
    selectedCasualties = widget.reportModel.casualties != 'Yes' ? false : true;
    selectedForWhom = widget.reportModel.forWhom;
    selectedVisibility =
        widget.reportModel.visibility != 'Private' ? false : true;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color backgroundColor = theme.scaffoldBackgroundColor;
    final Color textColor = theme.colorScheme.onBackground;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: CloseButton(),
        iconTheme: IconThemeData(color: textColor),
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          'UPDATE REPORT',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 20.sp,
            fontWeight: FontWeight.w900,
            color: textColor,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              String? imageStr;

              if (_image != null) {
                imageStr = await convertXFileToBase64(_image);
              }

              if (_formKey.currentState != null &&
                  _formKey.currentState!.validate() &&
                  selectedCasualties != null) {
                updateReport(
                  selectedEmergencyType!,
                  selectedForWhom!,
                  _descriptionController.text,
                  selectedCasualties!,
                  selectedVisibility!,
                  imageStr,
                );
              }
            },
            icon: Icon(Icons.check),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () => setState(() {
                              _pickImage();
                            }),
                            child: Container(
                              height: 200.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: tcAsh,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: _image != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.file(
                                        File(_image!.path),
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : widget.reportModel.image != null
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          child: Container(
                                            child: Image.network(
                                              widget.reportModel.image!,
                                              fit: BoxFit.cover,
                                              loadingBuilder:
                                                  (BuildContext context,
                                                      Widget child,
                                                      ImageChunkEvent?
                                                          loadingProgress) {
                                                if (loadingProgress == null) {
                                                  return child;
                                                } else {
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                }
                                              },
                                              errorBuilder:
                                                  (BuildContext context,
                                                      Object error,
                                                      StackTrace? stackTrace) {
                                                return Icon(Icons.error);
                                              },
                                            ),
                                          ),
                                        )
                                      : Center(
                                          child: Icon(Icons.question_mark),
                                        ),
                            ),
                          ),
                          Text(
                            'Tap to change the picture',
                            style: TextStyle(
                              fontFamily: 'PublicSans',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: tcGray,
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
                          Text(
                            'Emergency Type',
                            style: TextStyle(
                              fontFamily: 'PublicSans',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: textColor,
                            ),
                          ),
                          Divider(
                            color: Colors.transparent,
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: textColor),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 10),
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
                                      color: textColor,
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
                                      color: textColor,
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
                                      color: textColor,
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
                                      color: textColor,
                                    ),
                                  ),
                                ),
                              ],
                              onChanged: (value) {
                                if (mounted) {
                                  setState(() {
                                    selectedEmergencyType = value;
                                  });
                                }
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
                                'For Whom?',
                                style: TextStyle(
                                  fontFamily: 'PublicSans',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: textColor,
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
                              border: Border.all(color: textColor),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 10),
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
                                      color: textColor,
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
                                      color: textColor,
                                    ),
                                  ),
                                ),
                              ],
                              onChanged: (value) {
                                if (mounted) {
                                  setState(() {
                                    selectedForWhom = value;
                                  });
                                }
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
                          Text(
                            'Details',
                            style: TextStyle(
                              fontFamily: 'PublicSans',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: textColor,
                            ),
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
                              color: textColor,
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
                              color: textColor,
                            ),
                          ),
                          Radio(
                            value: true,
                            groupValue: selectedCasualties,
                            onChanged: (value) {
                              if (mounted) {
                                setState(() {
                                  selectedCasualties = value;
                                });
                              }
                            },
                          ),
                          Text(
                            "Yes",
                            style: TextStyle(
                              fontFamily: 'PublicSans',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: textColor,
                            ),
                          ),
                          Radio(
                            value: false,
                            groupValue: selectedCasualties,
                            onChanged: (value) {
                              if (mounted) {
                                setState(() {
                                  selectedCasualties = value;
                                });
                              }
                            },
                          ),
                          Text(
                            "No",
                            style: TextStyle(
                              fontFamily: 'PublicSans',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: textColor,
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
                              color: textColor,
                            ),
                          ),
                          Radio(
                            value: true,
                            groupValue: selectedVisibility,
                            onChanged: (value) {
                              if (mounted) {
                                setState(() {
                                  selectedVisibility = value;
                                });
                              }
                            },
                          ),
                          Text(
                            "Private",
                            style: TextStyle(
                              fontFamily: 'PublicSans',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: textColor,
                            ),
                          ),
                          Radio(
                            value: false,
                            groupValue: selectedVisibility,
                            onChanged: (value) {
                              if (mounted) {
                                setState(() {
                                  selectedVisibility = value;
                                });
                              }
                            },
                          ),
                          Text(
                            "Public",
                            style: TextStyle(
                              fontFamily: 'PublicSans',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // ProgressButton.icon(
                //     iconedButtons: {
                //       ButtonState.idle: IconedButton(
                //           text: 'Update',
                //           icon: Icon(Icons.update, color: Colors.white),
                //           color: tcViolet),
                //       ButtonState.loading:
                //           IconedButton(text: 'Loading', color: tcViolet),
                //       ButtonState.fail: IconedButton(
                //           text: 'Failed',
                //           icon: Icon(Icons.cancel, color: Colors.white),
                //           color: Colors.red.shade300),
                //       ButtonState.success: IconedButton(
                //           text: 'Success',
                //           icon: Icon(
                //             Icons.check_circle,
                //             color: Colors.white,
                //           ),
                //           color: Colors.green.shade400)
                //     },
                //     onPressed: () async {
                //       if (_image != null) {
                //         final imageStr = await convertXFileToBase64(_image);
                //         if (_formKey.currentState != null &&
                //             _formKey.currentState!.validate() &&
                //             selectedCasualties != null) {
                //           onPressedIconWithText(
                //               emergencyType: selectedEmergencyType!,
                //               description: _descriptionController.text,
                //               casualties: selectedCasualties!,
                //               visibility: selectedVisibility!,
                //               imahe: imageStr!);
                //         }
                //       } else {
                //         if (_formKey.currentState != null &&
                //             _formKey.currentState!.validate() &&
                //             selectedCasualties != null) {
                //           onPressedIconWithText(
                //               emergencyType: selectedEmergencyType!,
                //               description: _descriptionController.text,
                //               casualties: selectedCasualties!,
                //               visibility: selectedVisibility!,
                //               imahe: null);
                //         }
                //       }
                //     },
                //     state: stateTextWithIcon),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
