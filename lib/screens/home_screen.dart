import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taguigconnect/constants/color_constant.dart';
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
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300), // Adjust the duration as needed
        curve: Curves.easeInOut, // Adjust the curve as needed
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tcWhite,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: tcWhite,
        automaticallyImplyLeading: false,
        centerTitle: true,
        toolbarHeight: 40,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                print('Hello');
              },
              child: Container(
                child: Icon(
                  Icons.menu,
                  size: 25,
                  color: tcBlack,
                ),
              ),
            ),
            Text(
              getTitleForIndex(_currentIndex),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 20.sp,
                fontWeight: FontWeight.w900,
                color: tcBlack,
              ),
            ),
            InkWell(
              onTap: () {
                print('Hello');
              },
              child: Container(
                child: Icon(
                  Icons.notifications_rounded,
                  size: 25,
                  color: tcBlack,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
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
          physics: NeverScrollableScrollPhysics(), // Use BouncingScrollPhysics
        )),
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
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.language_rounded),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.phone_rounded),
            label: 'Contacts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_rounded),
            label: 'Explore',
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
      return 'FEED';
    case 2:
      return 'CONTACTS';
    case 3:
      return 'EXPLORE';
    default:
      return 'HOME'; // Default title
  }
}
