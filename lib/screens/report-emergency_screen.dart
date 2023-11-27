import 'package:TagConnect/widgets/emergency/another-person_widget.dart';
import 'package:TagConnect/widgets/emergency/myself_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:TagConnect/constants/color_constant.dart';

class ReportEmergencyScreen extends StatefulWidget {
  const ReportEmergencyScreen({super.key});

  @override
  State<ReportEmergencyScreen> createState() => _ReportEmergencyScreenState();
}

class _ReportEmergencyScreenState extends State<ReportEmergencyScreen> {
  int _currentIndex = 0;
  PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });

      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
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
      body: PageView(
        controller: _pageController,
        children: [
          MyselfWidget(),
          AnotherPersonWidget(),
        ],
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        physics: NeverScrollableScrollPhysics(), // Use BouncingScrollPhysics
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: tcWhite,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: tcBlack,
        selectedItemColor: tcViolet,
        showUnselectedLabels: false,
        showSelectedLabels: true,
        currentIndex: _currentIndex,
        onTap: (index) {
          _onItemTapped(index);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Myself',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Another Person',
          ),
        ],
      ),
    );
  }
}

String getTitleForIndex(int index) {
  switch (index) {
    case 0:
      return 'SEND REPORT';
    case 1:
      return 'ADD REPORT';
    default:
      return 'TAP TO SEND REPORT';
  }
}
