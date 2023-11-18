import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:taguigconnect/constants/color_constant.dart';
import 'package:taguigconnect/models/contact_model.dart';
import 'package:taguigconnect/screens/contact-edit_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactViewScreen extends StatelessWidget {
  final ContactModel contact;
  final VoidCallback callbackFunction;
  const ContactViewScreen(
      {super.key, required this.contact, required this.callbackFunction});

  @override
  Widget build(BuildContext context) {
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
              callbackFunction.call();
              Navigator.of(context).pop();
            } else {
              print('Contact not found in existing data');
            }
          }
        }
      } catch (e) {
        print(e);
      }
    }

    String firstLetter = contact.firstname!.isNotEmpty
        ? contact.firstname![0].toUpperCase()
        : '?';

    return Scaffold(
      backgroundColor: tcWhite,
      appBar: AppBar(
        leading: BackButton(),
        iconTheme: IconThemeData(color: tcBlack),
        backgroundColor: tcWhite,
        elevation: 0,
        title: Text(
          contact.firstname ?? '',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: tcBlack,
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
                      contact: contact,
                      callbackFunction: callbackFunction,
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
                      'Are you sure you want to delete ${contact.firstname ?? ''} in your contacts?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('No'),
                    ),
                    TextButton(
                      onPressed: () async {
                        await deleteContact(contact.id);
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
                  contact.image != null
                      ? CircleAvatar(
                          radius: 50,
                          backgroundColor: tcAsh,
                          backgroundImage: MemoryImage(
                            base64Decode(contact.image!),
                          ),
                        )
                      : CircleAvatar(
                          radius: 50,
                          backgroundColor: tcViolet,
                          child: Center(
                            child: Text(
                              firstLetter,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 40.sp,
                                fontWeight: FontWeight.w700,
                                color: tcWhite,
                              ),
                            ),
                          ),
                        ),
                  Divider(
                    color: Colors.transparent,
                  ),
                  contact.email != ''
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
                                      path: contact.contact,
                                    );
                                    await launchUrl(launchUri);
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: tcAsh,
                                    radius: 30,
                                    child: Icon(
                                      Icons.message,
                                      color: tcViolet,
                                    ),
                                  ),
                                ),
                                Text(
                                  'Message',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: tcBlack,
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
                                      path: contact.contact,
                                    );
                                    await launchUrl(launchUri);
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: tcAsh,
                                    radius: 30,
                                    child: Icon(
                                      Icons.phone,
                                      color: tcViolet,
                                    ),
                                  ),
                                ),
                                Text(
                                  'Call',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: tcBlack,
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
                                      path: contact.email,
                                    );
                                    await launchUrl(launchUri);
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: tcAsh,
                                    radius: 30,
                                    child: Icon(
                                      Icons.email,
                                      color: tcViolet,
                                    ),
                                  ),
                                ),
                                Text(
                                  'Email',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: tcBlack,
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
                                      path: contact.contact,
                                    );
                                    await launchUrl(launchUri);
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: tcAsh,
                                    radius: 30,
                                    child: Icon(
                                      Icons.message,
                                      color: tcViolet,
                                    ),
                                  ),
                                ),
                                Text(
                                  'Message',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: tcBlack,
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
                                      path: contact.contact,
                                    );
                                    await launchUrl(launchUri);
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: tcAsh,
                                    radius: 30,
                                    child: Icon(
                                      Icons.phone,
                                      color: tcViolet,
                                    ),
                                  ),
                                ),
                                Text(
                                  'Call',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: tcBlack,
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
                    padding: EdgeInsets.symmetric(vertical: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'First Name',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: tcBlack,
                          ),
                        ),
                        Text(
                          contact.firstname ?? '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: tcBlack,
                          ),
                        ),
                        Divider(
                          color: Colors.transparent,
                        ),
                        Text(
                          'Last Name',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: tcBlack,
                          ),
                        ),
                        Text(
                          contact.lastname ?? '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: tcBlack,
                          ),
                        ),
                        Divider(
                          color: Colors.transparent,
                        ),
                        Text(
                          'Email',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: tcBlack,
                          ),
                        ),
                        Text(
                          contact.email ?? '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: tcBlack,
                          ),
                        ),
                        Divider(
                          color: Colors.transparent,
                        ),
                        Text(
                          'Phone Number',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: tcBlack,
                          ),
                        ),
                        Text(
                          contact.contact ?? '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: tcBlack,
                          ),
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
