import 'package:TagConnect/constants/color_constant.dart';
import 'package:TagConnect/constants/provider_constant.dart';
import 'package:TagConnect/screens/report-list_screen.dart';
import 'package:TagConnect/services/report_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isLoading = false;
  Future<void> getReportDetails(int id) async {
    final reportService = ReportService();
    try {
      final fetchData = await reportService.getReportbyID(id);
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return ReportDetail(
              reportModel: fetchData,
            );
          },
        ),
      );
    } catch (e) {
      throw Exception('Failed to load reports $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final notificationsProvider = Provider.of<NotificationProvider>(context);
    final themeNotifier = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);
    final backgroundColor = theme.scaffoldBackgroundColor;
    final textColor = theme.colorScheme.onBackground;

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
                  // Sort the notifications in descending order based on timestamp
                  notificationsProvider.notifications.sort((a, b) {
                    final timestampA = DateTime.parse(a.data['notified_at']);
                    final timestampB = DateTime.parse(b.data['notified_at']);
                    return timestampB.compareTo(timestampA);
                  });

                  final notification =
                      notificationsProvider.notifications[index];

                  return GestureDetector(
                    onTap: () async {
                      setState(() {
                        isLoading = true;
                      });
                      await getReportDetails(
                          int.parse(notification.data['report_id']));
                      print('Hello');
                    },
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
                                  '${notification.title} ${notification.data['report_id']}',
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
                                notification.body,
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
                                notification.data['notified_at'],
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
