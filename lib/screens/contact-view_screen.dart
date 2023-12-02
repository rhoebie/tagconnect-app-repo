import 'dart:convert';
import 'dart:io';

import 'package:TagConnect/constants/provider_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:TagConnect/constants/color_constant.dart';
import 'package:TagConnect/models/contact_model.dart';
import 'package:TagConnect/screens/contact-edit_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactViewScreen extends StatefulWidget {
  final ContactModel contact;
  final VoidCallback callbackFunction;
  const ContactViewScreen(
      {super.key, required this.contact, required this.callbackFunction});

  @override
  State<ContactViewScreen> createState() => _ContactViewScreenState();
}

class _ContactViewScreenState extends State<ContactViewScreen> {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final ThemeData theme = Theme.of(context);
    final Color backgroundColor = theme.scaffoldBackgroundColor;
    final Color textColor = theme.colorScheme.onBackground;

    void navPop() {
      widget.callbackFunction.call();
      Navigator.of(context).pop();
    }

    Future<void> deleteContact(int contactId) async {
      try {
        Directory documentsDirectory = await getApplicationDocumentsDirectory();
        File file = File('${documentsDirectory.path}/contacts.txt');

        if (file.existsSync()) {
          String existingJsonData = file.readAsStringSync();
          if (existingJsonData.isNotEmpty) {
            List<Map<String, dynamic>> existingContactsData =
                (json.decode(existingJsonData) as List<dynamic>)
                    .cast<Map<String, dynamic>>();

            // Find the contact in existing data by ID
            int existingIndex = existingContactsData
                .indexWhere((data) => data['id'] == contactId);

            if (existingIndex != -1) {
              // Remove the contact from the existing data
              existingContactsData.removeAt(existingIndex);

              // Write the updated data back to the file
              String jsonData = json.encode(existingContactsData);
              file.writeAsStringSync(jsonData);

              print('Contact deleted successfully');
              navPop();
            } else {
              print('Contact not found in existing data');
            }
          }
        }
      } catch (e) {
        print(e);
      }
    }

    String firstLetter = widget.contact.firstname!.isNotEmpty
        ? widget.contact.firstname![0].toUpperCase()
        : '?';

    void showImageDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Image.memory(
                    base64Decode(widget.contact.image!),
                    width: 350,
                    height: 350,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                ),
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        leading: CloseButton(),
        iconTheme: IconThemeData(color: textColor),
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          widget.contact.firstname ?? '',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor,
            fontFamily: 'Roboto',
            fontSize: 20.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () async {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return ContactEditScreen(
                      contact: widget.contact,
                      callbackFunction: navPop,
                    );
                  },
                ),
              );
            },
            icon: Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('System'),
                  content: Text(
                      'Are you sure you want to delete ${widget.contact.firstname ?? ''} in your contacts?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('No'),
                    ),
                    TextButton(
                      onPressed: () async {
                        await deleteContact(widget.contact.id);
                        navPop();
                      },
                      child: const Text('Yes'),
                    ),
                  ],
                ),
              );
            },
            icon: Icon(Icons.delete),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  widget.contact.image != null
                      ? GestureDetector(
                          onTap: () {
                            showImageDialog(context);
                          },
                          child: CircleAvatar(
                            radius: 70,
                            backgroundColor:
                                themeNotifier.isDarkMode ? tcDark : tcAsh,
                            backgroundImage: MemoryImage(
                              base64Decode(widget.contact.image!),
                            ),
                          ),
                        )
                      : CircleAvatar(
                          radius: 70,
                          backgroundColor: tcViolet,
                          child: Center(
                            child: Text(
                              firstLetter,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 40.sp,
                                fontWeight: FontWeight.w700,
                                color: backgroundColor,
                              ),
                            ),
                          ),
                        ),
                  Divider(
                    color: Colors.transparent,
                  ),
                  widget.contact.email != ''
                      ? Row(
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
                                      path: widget.contact.contact,
                                    );
                                    await launchUrl(launchUri);
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: themeNotifier.isDarkMode
                                        ? tcDark
                                        : tcAsh,
                                    radius: 30,
                                    child: Icon(
                                      Icons.message,
                                      color: themeNotifier.isDarkMode
                                          ? tcWhite
                                          : tcBlack,
                                    ),
                                  ),
                                ),
                                Divider(
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
                                      path: widget.contact.contact,
                                    );
                                    await launchUrl(launchUri);
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: themeNotifier.isDarkMode
                                        ? tcDark
                                        : tcAsh,
                                    radius: 30,
                                    child: Icon(
                                      Icons.phone,
                                      color: themeNotifier.isDarkMode
                                          ? tcWhite
                                          : tcBlack,
                                    ),
                                  ),
                                ),
                                Divider(
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
                            Column(
                              children: [
                                InkWell(
                                  borderRadius: BorderRadius.circular(50),
                                  onTap: () async {
                                    final Uri launchUri = Uri(
                                      scheme: 'mailto',
                                      path: widget.contact.email,
                                    );
                                    await launchUrl(launchUri);
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: themeNotifier.isDarkMode
                                        ? tcDark
                                        : tcAsh,
                                    radius: 30,
                                    child: Icon(
                                      Icons.email,
                                      color: themeNotifier.isDarkMode
                                          ? tcWhite
                                          : tcBlack,
                                    ),
                                  ),
                                ),
                                Divider(
                                  color: Colors.transparent,
                                  height: 5,
                                ),
                                Text(
                                  'Email',
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
                        )
                      : Row(
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
                                      path: widget.contact.contact,
                                    );
                                    await launchUrl(launchUri);
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: themeNotifier.isDarkMode
                                        ? tcDark
                                        : tcAsh,
                                    radius: 30,
                                    child: Icon(
                                      Icons.message,
                                      color: themeNotifier.isDarkMode
                                          ? tcWhite
                                          : tcBlack,
                                    ),
                                  ),
                                ),
                                Divider(
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
                                      path: widget.contact.contact,
                                    );
                                    await launchUrl(launchUri);
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: themeNotifier.isDarkMode
                                        ? tcDark
                                        : tcAsh,
                                    radius: 30,
                                    child: Icon(
                                      Icons.phone,
                                      color: themeNotifier.isDarkMode
                                          ? tcWhite
                                          : tcBlack,
                                    ),
                                  ),
                                ),
                                Divider(
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
                  Divider(
                    color: Colors.transparent,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Personal Information',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.transparent,
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'First Name',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: textColor,
                              ),
                            ),
                            Text(
                              widget.contact.firstname ?? '',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.transparent,
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Last Name',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: textColor,
                              ),
                            ),
                            Text(
                              widget.contact.lastname ?? '',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.transparent,
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Email',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: textColor,
                              ),
                            ),
                            Text(
                              widget.contact.email ?? '',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.transparent,
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Phone Number',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: textColor,
                              ),
                            ),
                            Text(
                              widget.contact.contact ?? '',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Roboto',
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
