import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:TagConnect/constants/color_constant.dart';
import 'package:TagConnect/models/barangay_model.dart';
import 'package:TagConnect/models/feed_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportDetail extends StatefulWidget {
  final FeedModel feedModel;
  final BarangayModel barangayModel;
  const ReportDetail(
      {super.key, required this.feedModel, required this.barangayModel});

  @override
  State<ReportDetail> createState() => _ReportDetailState();
}

class _ReportDetailState extends State<ReportDetail> {
  bool isBlurred = true;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color backgroundColor = theme.scaffoldBackgroundColor;
    final Color textColor = theme.colorScheme.onBackground;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        leading: CloseButton(),
        iconTheme: IconThemeData(color: textColor),
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          widget.feedModel.emergencyType?.toUpperCase() ?? '',
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
              final Uri launchUri = Uri.parse(
                  'https://maps.google.com/?q=${widget.feedModel.location!.latitude!},${widget.feedModel.location!.longitude!}');
              await launchUrl(launchUri);
            },
            icon: Icon(
              Icons.location_pin,
              color: tcRed,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Card(
                        elevation: 5,
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          child: widget.feedModel.image != '' ||
                                  widget.feedModel.image != null
                              ? Image.network(
                                  widget.feedModel.image!,
                                  fit: BoxFit.cover,
                                )
                              : Center(
                                  child: Icon(Icons.question_mark),
                                ),
                        ),
                      ),
                      isBlurred == true
                          ? BackdropFilter(
                              filter:
                                  ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                              child: Container(
                                color: Colors.transparent,
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  Divider(
                    color: Colors.transparent,
                    height: 10,
                  ),
                  Container(
                    width: 100,
                    height: 40.h,
                    child: ElevatedButton(
                      onPressed: () {
                        if (mounted) {
                          setState(() {
                            isBlurred = !isBlurred;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: tcViolet,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 2,
                      ),
                      child: isBlurred != true
                          ? Text(
                              'Blur',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'PublicSans',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: backgroundColor,
                              ),
                            )
                          : Text(
                              'Unblur',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'PublicSans',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: backgroundColor,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
              Divider(
                color: Colors.transparent,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: tcViolet,
                    foregroundColor: backgroundColor,
                    child: widget.barangayModel.image != null
                        ? ClipOval(
                            child: Image.network(
                              widget.barangayModel.image!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Icon(
                            Icons.question_mark,
                            size: 20,
                          ),
                  ),
                  VerticalDivider(
                    color: Colors.transparent,
                    width: 5,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.barangayModel.name ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: textColor,
                          fontFamily: 'Roboto',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Date: ${formatCustomDateTime(widget.feedModel.createdAt.toString())}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'PublicSans',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.normal,
                          color: textColor,
                        ),
                      ),
                      Text(
                        'Resolve Time: ${widget.feedModel.resolveTime}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'PublicSans',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.normal,
                          color: textColor,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Divider(
                color: Colors.transparent,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Report ID',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PublicSans',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  Text(
                    widget.feedModel.id.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PublicSans',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: textColor,
                    ),
                  ),
                ],
              ),
              Divider(
                color: Colors.transparent,
              ),
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Text(
              //       'Barangay ID',
              //       textAlign: TextAlign.center,
              //       style: TextStyle(
              //         fontFamily: 'PublicSans',
              //         fontSize: 14.sp,
              //         fontWeight: FontWeight.w700,
              //         color: textColor,
              //       ),
              //     ),
              //     Text(
              //       feedModel.barangayId.toString(),
              //       textAlign: TextAlign.center,
              //       style: TextStyle(
              //         fontFamily: 'PublicSans',
              //         fontSize: 12.sp,
              //         fontWeight: FontWeight.w400,
              //         color: textColor,
              //       ),
              //     ),
              //   ],
              // ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'For Whom?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PublicSans',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  Text(
                    widget.feedModel.forWhom ?? '',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PublicSans',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: textColor,
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
                    'Any Casualties?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PublicSans',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  Text(
                    widget.feedModel.casualties == 1 ? 'Yes' : 'No',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PublicSans',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: textColor,
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
                    'Description',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PublicSans',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  Text(
                    widget.feedModel.description ?? '',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontFamily: 'PublicSans',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: textColor,
                    ),
                  ),
                ],
              ),
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Text(
              //       'Image',
              //       textAlign: TextAlign.center,
              //       style: TextStyle(
              //         fontFamily: 'PublicSans',
              //         fontSize: 14.sp,
              //         fontWeight: FontWeight.w700,
              //         color: textColor,
              //       ),
              //     ),
              //     Container(
              //       width: double.infinity,
              //       height: 150,
              //       child: feedModel.image != '' || feedModel.image != null
              //           ? Image.network(
              //               feedModel.image!,
              //               fit: BoxFit.cover,
              //             )
              //           : Center(
              //               child: Icon(Icons.question_mark),
              //             ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

String formatCustomDateTime(String input) {
  final inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss.SSS");
  final dateTime = inputFormat.parse(input);

  // Updated output format
  final outputFormat = DateFormat("E, d MMM y hh:mma");
  final formattedDate = outputFormat.format(dateTime);

  return formattedDate;
}
