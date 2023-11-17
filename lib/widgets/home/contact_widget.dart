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

  Future<List<BarangayModel>?> fetchBarangay() async {
    try {
      final barangayService = BarangayService();
      final List<BarangayModel> fetchData =
          await barangayService.getbarangays();
      return fetchData;
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
                children: [
                  Divider(
                    color: Colors.transparent,
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    width: double.infinity,
                    height: 200.h,
                    child: FutureBuilder(
                      future: fetchBarangay(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          final barangayData = snapshot.data;
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: barangayData?.length,
                            itemBuilder: (context, index) {
                              final item = barangayData![index];
                              return InkWell(
                                child: Card(
                                  elevation: 2,
                                  child: Container(
                                    width: 120.w,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            color: tcAsh,
                                            child: item.image != null
                                                ? Image.network(
                                                    item.image!,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Center(
                                                    child: Icon(
                                                      Icons.question_mark,
                                                      color: tcBlack,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 5),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  item.name ?? '',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily: 'PublicSans',
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w700,
                                                    color: tcBlack,
                                                  ),
                                                ),
                                                Text(
                                                  item.contact ?? '',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily: 'PublicSans',
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: tcBlack,
                                                  ),
                                                ),
                                              ],
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
                        } else {
                          return Center(
                            child: Text('No data available'),
                          );
                        }
                      },
                    ),
                  ),
                ],
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
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return contacts[index].buildContactWidget();
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
