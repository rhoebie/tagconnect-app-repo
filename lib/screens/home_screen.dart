import 'package:TagConnect/constants/provider_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:TagConnect/constants/color_constant.dart';
import 'package:TagConnect/screens/notification_screen.dart';
import 'package:TagConnect/widgets/feed_widget.dart';
import 'package:TagConnect/widgets/contact_widget.dart';
import 'package:TagConnect/widgets/home_widget.dart';
import 'package:TagConnect/widgets/menu_widget.dart';
import 'package:provider/provider.dart';

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
      if (mounted) {
        setState(() {
          _currentIndex = index;
        });
      }
      _pageController.jumpToPage(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);
    final hasNotifications = notificationProvider.notifications.isNotEmpty;
    final ThemeData theme = Theme.of(context);
    final Color backgroundColor = theme.scaffoldBackgroundColor;
    final Color textColor = theme.colorScheme.onBackground;

    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        automaticallyImplyLeading: false,
        centerTitle: false,
        toolbarHeight: 40,
        elevation: 0,
        title: Text(
          getTitleForIndex(_currentIndex),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 20.sp,
            fontWeight: FontWeight.w900,
            color: textColor,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return NotificationScreen();
                  },
                ),
              );
            },
            icon: Icon(
              hasNotifications
                  ? Icons.notifications_active_rounded
                  : Icons.notifications_none_rounded,
              size: 25,
              color: textColor,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          child: PageView(
            controller: _pageController,
            children: [
              HomeWidget(),
              FeedWidget(),
              ContactWidget(),
              MenuWidget(),
            ],
            onPageChanged: (index) {
              if (mounted) {
                setState(() {
                  _currentIndex = index;
                });
              }
            },
            physics:
                NeverScrollableScrollPhysics(), // Use BouncingScrollPhysics
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: backgroundColor,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: textColor,
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
            icon: Icon(Icons.menu_rounded),
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
      return 'FEED';
    case 2:
      return 'CONTACTS';
    case 3:
      return 'MENU';
    default:
      return 'HOME'; // Default title
  }
}
