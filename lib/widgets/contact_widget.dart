import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:TagConnect/constants/color_constant.dart';
import 'package:TagConnect/models/contact_model.dart';
import 'package:TagConnect/screens/contact-add_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactWidget extends StatefulWidget {
  const ContactWidget({super.key});

  @override
  State<ContactWidget> createState() => _ContactWidgetState();
}

class _ContactWidgetState extends State<ContactWidget> {
  List<ContactModel> contacts = [];
  List<ContactModel> filteredContacts = [];

  Future<void> loadContacts() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    File file = File('${documentsDirectory.path}/contacts.txt');

    if (file.existsSync()) {
      String jsonData = file.readAsStringSync();
      List<dynamic> contactsData = json.decode(jsonData);
      setState(() {
        contacts =
            contactsData.map((data) => ContactModel.fromJson(data)).toList();
        contacts
            .sort((a, b) => (a.firstname ?? '').compareTo(b.firstname ?? ''));
        filteredContacts = contacts;
      });
    }
  }

  void filterContacts(String query) {
    query = query.toLowerCase();
    setState(() {
      if (query.isEmpty || query == '') {
        // Show all contacts when the query is empty or null
        filteredContacts = List.from(contacts);
      } else {
        // Filter based on the search query
        filteredContacts = contacts
            .where(
                (contact) => contact.firstname!.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: false,
              floating: true,
              snap: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: tcWhite,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        onChanged: (value) {
                          filterContacts(value);
                        },
                        decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle: TextStyle(
                            color: tcGray,
                          ),
                          icon: Icon(
                            Icons.search,
                            color: tcGray,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  VerticalDivider(
                    color: Colors.transparent,
                    width: 10,
                  ),
                  Card(
                    shape: CircleBorder(),
                    elevation: 5,
                    color: tcViolet,
                    child: IconButton(
                      tooltip: 'Add Contact',
                      icon: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return ContactAddScreen(
                                callbackFunction: loadContacts,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
              centerTitle: true,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(
                      color: Colors.transparent,
                    ),
                    Text(
                      'All Contacts',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: tcBlack,
                      ),
                    ),
                    Divider(
                      color: Colors.transparent,
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      height: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () async {
                              final Uri launchUri = Uri(
                                scheme: 'tel',
                                path: '911',
                              );
                              await launchUrl(launchUri);
                            },
                            borderRadius: BorderRadius.circular(50),
                            child: Container(
                              width: 80,
                              margin: EdgeInsets.symmetric(horizontal: 2.5),
                              decoration: BoxDecoration(
                                color: tcOrange,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'General',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w700,
                                        color: tcWhite,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              final Uri launchUri = Uri(
                                scheme: 'tel',
                                path: '143',
                              );
                              await launchUrl(launchUri);
                            },
                            borderRadius: BorderRadius.circular(50),
                            child: Container(
                              width: 80,
                              margin: EdgeInsets.symmetric(horizontal: 2.5),
                              decoration: BoxDecoration(
                                color: tcGreen,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Medical',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w700,
                                        color: tcWhite,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              final Uri launchUri = Uri(
                                scheme: 'tel',
                                path: '160',
                              );
                              await launchUrl(launchUri);
                            },
                            borderRadius: BorderRadius.circular(50),
                            child: Container(
                              width: 80,
                              margin: EdgeInsets.symmetric(horizontal: 2.5),
                              decoration: BoxDecoration(
                                color: tcRed,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Fire',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w700,
                                        color: tcWhite,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              final Uri launchUri = Uri(
                                scheme: 'tel',
                                path: '117',
                              );
                              await launchUrl(launchUri);
                            },
                            borderRadius: BorderRadius.circular(50),
                            child: Container(
                              width: 80,
                              margin: EdgeInsets.symmetric(horizontal: 2.5),
                              decoration: BoxDecoration(
                                color: tcBlue,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Crime',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w700,
                                        color: tcWhite,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return filteredContacts[index].buildContactWidget(
                      context, filteredContacts[index], loadContacts);
                },
                childCount: filteredContacts.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}