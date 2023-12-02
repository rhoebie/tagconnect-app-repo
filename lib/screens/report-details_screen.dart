import 'dart:ui';

import 'package:TagConnect/models/report_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:TagConnect/constants/color_constant.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportDetail extends StatefulWidget {
  final ReportModel reportModel;
  final String barangayModel;
  const ReportDetail(
      {super.key, required this.reportModel, required this.barangayModel});

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
          widget.reportModel.emergencyType?.toUpperCase() ?? '',
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
                  'https://maps.google.com/?q=${widget.reportModel.location!.latitude!},${widget.reportModel.location!.longitude!}');
              await launchUrl(launchUri);
            },
            icon: Icon(
              Icons.location_pin,
              color: tcBlack,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    if (mounted) {
                      setState(() {
                        isBlurred = !isBlurred;
                      });
                    }
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Card(
                        elevation: 5,
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          child: widget.reportModel.image != '' ||
                                  widget.reportModel.image != null
                              ? Image.network(
                                  widget.reportModel.image!,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    } else {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  },
                                  errorBuilder: (BuildContext context,
                                      Object error, StackTrace? stackTrace) {
                                    return Icon(Icons.error);
                                  },
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
                ),
                Divider(
                  color: Colors.transparent,
                  height: 10,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Tap to unblur',
                    style: TextStyle(
                      color: textColor,
                      fontFamily: 'Roboto',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Divider(
                  color: Colors.transparent,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.barangayModel,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: textColor,
                            fontFamily: 'Roboto',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Date: ${formatCustomDateTime(widget.reportModel.createdAt.toString())}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'PublicSans',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.normal,
                            color: textColor,
                          ),
                        ),
                        Text(
                          'Resolved in: ${calculateTimeDifference(widget.reportModel.createdAt!, widget.reportModel.updatedAt!)}',
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
                      widget.reportModel.id.toString(),
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
                      widget.reportModel.forWhom ?? '',
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
                      widget.reportModel.casualties == 1 ? 'Yes' : 'No',
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
                      'Status',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'PublicSans',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                    Text(
                      widget.reportModel.status ?? '',
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
                      widget.reportModel.description ?? '',
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
              ],
            ),
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

String calculateTimeDifference(DateTime createdAt, DateTime updatedAt) {
  Duration difference = updatedAt.difference(createdAt);

  if (difference.inSeconds < 60) {
    return '${difference.inSeconds} ${difference.inSeconds == 1 ? 'second' : 'seconds'}';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'}';
  } else {
    return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'}';
  }
}
