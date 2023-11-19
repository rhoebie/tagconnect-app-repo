import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:taguigconnect/constants/color_constant.dart';
import 'package:taguigconnect/models/feed_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportDetail extends StatelessWidget {
  final FeedModel feedModel;
  const ReportDetail({super.key, required this.feedModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tcWhite,
      appBar: AppBar(
        leading: CloseButton(),
        iconTheme: IconThemeData(color: tcBlack),
        backgroundColor: tcWhite,
        elevation: 0,
        title: Text(
          feedModel.emergencyType?.toUpperCase() ?? '',
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: tcViolet,
                    foregroundColor: tcWhite,
                    child: Icon(Icons.person_rounded),
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
                        'Anonymous',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: tcBlack,
                          fontFamily: 'Roboto',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        'Date: ${formatCustomDateTime(feedModel.createdAt.toString())}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'PublicSans',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.normal,
                          color: tcBlack,
                        ),
                      ),
                      Text(
                        'Resolve Time: ${feedModel.resolveTime}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'PublicSans',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.normal,
                          color: tcBlack,
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
                      color: tcBlack,
                    ),
                  ),
                  Text(
                    feedModel.id.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PublicSans',
                      fontSize: 12.sp,
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
                  Text(
                    'Barangay ID',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PublicSans',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: tcBlack,
                    ),
                  ),
                  Text(
                    feedModel.barangayId.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PublicSans',
                      fontSize: 12.sp,
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
                  Text(
                    'For Whom?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PublicSans',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: tcBlack,
                    ),
                  ),
                  Text(
                    feedModel.forWhom ?? '',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PublicSans',
                      fontSize: 12.sp,
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
                  Text(
                    'Any Casualties?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PublicSans',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: tcBlack,
                    ),
                  ),
                  Text(
                    feedModel.casualties == 1 ? 'Yes' : 'No',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PublicSans',
                      fontSize: 12.sp,
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
                  Text(
                    'Description',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PublicSans',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: tcBlack,
                    ),
                  ),
                  Text(
                    feedModel.description ?? '',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontFamily: 'PublicSans',
                      fontSize: 12.sp,
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
                  Text(
                    'Location',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PublicSans',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: tcBlack,
                    ),
                  ),
                  Container(
                    child: ElevatedButton(
                      onPressed: () async {
                        final Uri launchUri = Uri.parse(
                            'https://maps.google.com/?q=${feedModel.location!.latitude!},${feedModel.location!.longitude!}');
                        await launchUrl(launchUri);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: tcViolet,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        'View',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: tcWhite,
                        ),
                      ),
                    ),
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
                    'Image',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PublicSans',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: tcBlack,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 150,
                    child: feedModel.image != '' || feedModel.image != null
                        ? Image.network(
                            feedModel.image!,
                            fit: BoxFit.cover,
                          )
                        : Center(
                            child: Icon(Icons.question_mark),
                          ),
                  ),
                ],
              ),
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
