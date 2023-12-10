import 'package:TagConnect/constants/color_constant.dart';
import 'package:TagConnect/constants/provider_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    var notificationsProvider = Provider.of<NotificationProvider>(context);
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final ThemeData theme = Theme.of(context);
    final Color backgroundColor = theme.scaffoldBackgroundColor;
    final Color textColor = theme.colorScheme.onBackground;
    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: const CloseButton(),
        iconTheme: IconThemeData(color: textColor),
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          'NOTIFICATION',
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
            onPressed: () {
              notificationsProvider.clearNotification();
            },
            icon: Icon(Icons.clear_all_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Consumer<NotificationProvider>(
            builder: (context, notificationsProvider, child) {
              return ListView.builder(
                itemCount: notificationsProvider.notifications.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      // handles when tap it will go to report details
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Card(
                      color: themeNotifier.isDarkMode ? tcDark : tcWhite,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '${notificationsProvider.notifications[index].title} ${notificationsProvider.notifications[index].data['report_id']}',
                                  style: TextStyle(
                                    color: textColor,
                                    fontFamily: 'Roboto',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    notificationsProvider
                                        .removeNotification(index);
                                  },
                                  borderRadius: BorderRadius.circular(50),
                                  child: Icon(
                                    Icons.clear_rounded,
                                  ),
                                )
                              ],
                            ),
                            Divider(
                              color: Colors.transparent,
                              height: 5,
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                notificationsProvider.notifications[index].body,
                                style: TextStyle(
                                  color: textColor,
                                  fontFamily: 'PublicSans',
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Divider(
                              color: Colors.transparent,
                              height: 10,
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                notificationsProvider
                                    .notifications[index].data['notified_at'],
                                style: TextStyle(
                                  color: textColor,
                                  fontFamily: 'Roboto',
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
