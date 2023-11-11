import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taguigconnect/animations/slideLeft_animation.dart';
import 'package:taguigconnect/constants/color_constant.dart';
import 'package:taguigconnect/screens/notification_screen.dart';
import 'package:taguigconnect/screens/report-list_screen.dart';
import 'package:taguigconnect/widgets/home/menu_widget.dart';
import 'package:taguigconnect/widgets/home/contact_widget.dart';
import 'package:taguigconnect/widgets/home/explore_widget.dart';
import 'package:taguigconnect/widgets/home/home_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      _pageController.jumpToPage(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tcWhite,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: tcWhite,
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context, SlideLeftAnimation(const NotificationScreen()));
            },
            icon: Icon(
              Icons.notifications_rounded,
              color: tcBlack,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                  context, SlideLeftAnimation(const ReportListScreen()));
            },
            icon: Icon(
              Icons.note_alt,
              color: tcBlack,
            ),
          ),
          VerticalDivider(
            color: Colors.transparent,
            width: 5,
          ),
        ],
        title: Text(
          getTitleForIndex(_currentIndex),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 20.sp,
            fontWeight: FontWeight.w900,
            color: tcBlack,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: PageView(
              controller: _pageController,
              children: [
                HomeWidget(),
                ContactWidget(),
                ExploreWidget(),
                MenuWidget(),
              ],
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              physics:
                  NeverScrollableScrollPhysics(), // Use BouncingScrollPhysics
            )),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: tcWhite,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: tcBlack,
        selectedItemColor: tcViolet,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        currentIndex: _currentIndex,
        onTap: (index) {
          _onItemTapped(index);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.phone),
            label: 'Contact',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Menu',
          ),
        ],
      ),
    );
  }
}

String getTitleForIndex(int index) {
  switch (index) {
    case 0:
      return 'HOME';
    case 1:
      return 'CONTACTS';
    case 2:
      return 'EXPLORE';
    case 3:
      return 'MENU';
    default:
      return 'HOME'; // Default title
  }
}
