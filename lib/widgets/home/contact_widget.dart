import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:taguigconnect/constants/color_constant.dart';
import 'package:taguigconnect/models/barangay_model.dart';
import 'package:taguigconnect/models/contact_model.dart';
import 'package:taguigconnect/screens/contact-add_screen.dart';
import 'package:taguigconnect/services/barangay_service.dart';

class ContactWidget extends StatefulWidget {
  const ContactWidget({super.key});

  @override
  State<ContactWidget> createState() => _ContactWidgetState();
}

class _ContactWidgetState extends State<ContactWidget> {
  List<ContactModel> contacts = [];
  List<BarangayModel> barangayData = [];

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
      });
    }
  }

  Future<void> fetchBarangay() async {
    try {
      final barangayService = BarangayService();
      final List<BarangayModel> fetchData =
          await barangayService.getbarangays();

      setState(() {
        barangayData = fetchData;
      });
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchBarangay();
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
                    elevation: 5,
                    color: tcViolet,
                    child: IconButton(
                      icon: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return ContactAddScreen();
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
              child: Column(
                children: [],
              ),
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
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: barangayData.length,
                        itemBuilder: (context, index) {
                          final item = barangayData[index];
                          return InkWell(
                            onTap: () {},
                            borderRadius: BorderRadius.circular(50),
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 2.5),
                              decoration: BoxDecoration(
                                color: tcAsh,
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
                                    item.name ?? '',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      color: tcBlack,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                ],
                              )),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return contacts[index]
                      .buildContactWidget(context, contacts[index]);
                },
                childCount: contacts.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
