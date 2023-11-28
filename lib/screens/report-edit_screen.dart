import 'package:TagConnect/constants/color_constant.dart';
import 'package:TagConnect/models/report_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReportEditScreen extends StatefulWidget {
  final ReportModel reportModel;
  const ReportEditScreen({super.key, required this.reportModel});

  @override
  State<ReportEditScreen> createState() => _ReportEditScreenState();
}

class _ReportEditScreenState extends State<ReportEditScreen> {
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
          'UPDATE REPORT',
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
    );
  }
}
