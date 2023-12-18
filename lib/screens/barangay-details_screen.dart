import 'package:TagConnect/constants/provider_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:TagConnect/configs/request_config.dart';
import 'package:TagConnect/constants/color_constant.dart';
import 'package:TagConnect/models/barangay_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class BarangayDetailsWidget extends StatefulWidget {
  final BarangayModel barangayModel;
  const BarangayDetailsWidget({
    super.key,
    required this.barangayModel,
  });

  @override
  State<BarangayDetailsWidget> createState() => _BarangayDetailsWidgetState();
}

class _BarangayDetailsWidgetState extends State<BarangayDetailsWidget> {
  double? userLatitude;
  double? userLongitude;

  Future<void> getDistance() async {
    bool locationPermission = await RequestService.locationPermission();

    if (locationPermission) {
      try {
        showWaitSnackBar(context);
        final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
        final Position position = await geolocator.getCurrentPosition(
          locationSettings: AndroidSettings(accuracy: LocationAccuracy.best),
        );
        if (mounted) {
          setState(() {
            userLatitude = position.latitude;
            userLongitude = position.longitude;
          });
        }
      } catch (e) {
        print('Error: $e');
      }
    } else {
      return;
    }
  }

  void showWaitSnackBar(BuildContext context) {
    final snackBar = const SnackBar(
      content: Row(
        children: [
          CircularProgressIndicator(),
          SizedBox(width: 16),
          Text('Please Wait: Getting location'),
        ],
      ),
      duration: Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeProvider>(context);
    final ThemeData theme = Theme.of(context);
    final Color backgroundColor = theme.scaffoldBackgroundColor;
    final Color textColor = theme.colorScheme.onBackground;

    void showImageDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Image.network(
                    widget.barangayModel.image!,
                    width: 350,
                    height: 350,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                    errorBuilder: (BuildContext context, Object error,
                        StackTrace? stackTrace) {
                      return const Icon(Icons.error);
                    },
                  ),
                ),
                Text(
                  widget.barangayModel.name ?? '',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: const CloseButton(),
        iconTheme: IconThemeData(color: textColor),
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          widget.barangayModel.name ?? '',
          textAlign: TextAlign.start,
          style: TextStyle(
            color: textColor,
            fontFamily: 'Roboto',
            fontSize: 20.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () async {
              await getDistance();
              if (userLatitude != null && userLongitude != null) {
                final Uri launchUri = Uri.parse(
                    'https://www.google.com/maps/dir/$userLatitude, $userLongitude/${widget.barangayModel.location!.latitude!},${widget.barangayModel.location!.longitude!}');
                await launchUrl(launchUri);
              }
            },
            icon: Icon(
              Icons.map,
              color: textColor,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children: [
                    widget.barangayModel.image != null
                        ? GestureDetector(
                            onTap: () {
                              showImageDialog(context);
                            },
                            child: CircleAvatar(
                              radius: 70,
                              child: ClipOval(
                                child: Image.network(
                                  widget.barangayModel.image!,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    } else {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  },
                                  errorBuilder: (BuildContext context,
                                      Object error, StackTrace? stackTrace) {
                                    return const Icon(Icons.error);
                                  },
                                ),
                              ),
                            ),
                          )
                        : CircleAvatar(
                            radius: 70,
                            backgroundColor: tcAsh,
                            child: ClipOval(
                              child: Icon(
                                Icons.question_mark,
                                size: 40,
                                color: textColor,
                              ),
                            ),
                          ),
                    const Divider(
                      color: Colors.transparent,
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(50),
                              onTap: () async {
                                final Uri launchUri = Uri(
                                  scheme: 'sms',
                                  path: widget.barangayModel.contact,
                                );
                                await launchUrl(launchUri);
                              },
                              child: CircleAvatar(
                                backgroundColor:
                                    themeNotifier.isDarkMode ? tcDark : tcAsh,
                                radius: 30,
                                child: Icon(
                                  Icons.message,
                                  color: themeNotifier.isDarkMode
                                      ? tcWhite
                                      : tcBlack,
                                ),
                              ),
                            ),
                            const Divider(
                              color: Colors.transparent,
                              height: 5,
                            ),
                            Text(
                              'Message',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(50),
                              onTap: () async {
                                final Uri launchUri = Uri(
                                  scheme: 'tel',
                                  path: widget.barangayModel.contact,
                                );
                                await launchUrl(launchUri);
                              },
                              child: CircleAvatar(
                                backgroundColor:
                                    themeNotifier.isDarkMode ? tcDark : tcAsh,
                                radius: 30,
                                child: Icon(
                                  Icons.phone,
                                  color: themeNotifier.isDarkMode
                                      ? tcWhite
                                      : tcBlack,
                                ),
                              ),
                            ),
                            const Divider(
                              color: Colors.transparent,
                              height: 5,
                            ),
                            Text(
                              'Call',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(
                      color: Colors.transparent,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Barangay Information',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                    ),
                    const Divider(
                      color: Colors.transparent,
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Barangay ID',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: textColor,
                                ),
                              ),
                              Text(
                                widget.barangayModel.id.toString(),
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                            color: Colors.transparent,
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'District',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: textColor,
                                ),
                              ),
                              Text(
                                widget.barangayModel.district.toString(),
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                            color: Colors.transparent,
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Contact',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: textColor,
                                ),
                              ),
                              Text(
                                widget.barangayModel.contact ?? '',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                            color: Colors.transparent,
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Address',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: textColor,
                                ),
                              ),
                              Container(
                                width: 150,
                                child: Text(
                                  widget.barangayModel.address ?? '',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: textColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
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
