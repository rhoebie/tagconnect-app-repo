import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taguigconnect/constants/color_constant.dart';
import 'package:taguigconnect/models/contact_model.dart';
import 'package:taguigconnect/screens/contact-add_screen.dart';
import 'package:taguigconnect/screens/contact-edit_screen.dart';

class ContactWidget extends StatefulWidget {
  const ContactWidget({super.key});

  @override
  State<ContactWidget> createState() => _ContactWidgetState();
}

class _ContactWidgetState extends State<ContactWidget> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  late List<ContactModel> originalContactData;
  List<ContactModel> filteredContact = [];

  Future<List<ContactModel>?> fetchContactData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final List<String>? cachedContactJsonList =
          prefs.getStringList('contactData');

      if (cachedContactJsonList != null) {
        final List<ContactModel> cachedContacts = cachedContactJsonList
            .map((jsonString) => ContactModel.fromJson(json.decode(jsonString)))
            .toList();

        return cachedContacts;
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching contacts: $e');
      throw e;
    }
  }

  void _handleSearchFilter(String enteredKeyword) {
    if (enteredKeyword.isEmpty) {
      if (mounted) {
        setState(() {
          // If the search query is empty, reset the filteredContact to the original data
          filteredContact = originalContactData;
        });
      }
    } else {
      final results = originalContactData.where((item) {
        return item.name!
                .toLowerCase()
                .contains(enteredKeyword.toLowerCase()) ||
            item.number!.toLowerCase().contains(enteredKeyword.toLowerCase());
      }).toList();

      if (mounted) {
        setState(() {
          filteredContact = results;
        });
      }
    }
  }

  Future<void> refreshAll() async {
    try {
      List<ContactModel>? results = await fetchContactData();

      if (mounted) {
        setState(() {
          filteredContact = results!;
        });
      }

      await Future.delayed(Duration(seconds: 1));
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchContactData().then((data) {
      if (data != null) {
        if (mounted) {
          setState(() {
            originalContactData = data;
            filteredContact =
                data; // Initialize both original and filtered data
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshAll,
      child: Container(
        width: double.infinity,
        color: tcWhite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    child: TextField(
                      onChanged: _handleSearchFilter,
                      keyboardType: TextInputType.text,
                      controller: _searchController,
                      focusNode: _searchFocus,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: tcBlack,
                      ),
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(
                          fontFamily: 'PublicSans',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: tcBlack,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                        prefixIcon: Icon(
                          Icons.search,
                          size: 20,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            if (mounted) {
                              setState(() {
                                _searchController.clear();
                              });
                            }
                          },
                          icon: Icon(
                            Icons.clear,
                            size: 20,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1.w,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: tcBlack,
                            width: 1.w,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: tcViolet,
                            width: 2.w,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                ),
                VerticalDivider(
                  color: Colors.transparent,
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: tcAsh,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return ContactAddScreen();
                            },
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.add_rounded,
                        color: tcBlack,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.transparent,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredContact.length,
                itemBuilder: (BuildContext context, int index) {
                  final items = filteredContact;
                  return Container(
                    height: 60,
                    margin: EdgeInsets.only(bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: ClipOval(
                                child: items[index].image != null
                                    ? Image.memory(
                                        decodeBase64ToUint8List(
                                            items[index].image!), // here
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        'assets/images/user.png',
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            VerticalDivider(
                              color: Colors.transparent,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  items[index].name ?? '',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontFamily: 'PublicSans',
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: tcBlack,
                                  ),
                                ),
                                Text(
                                  items[index].number ?? '',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontFamily: 'PublicSans',
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w400,
                                    color: tcBlack,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: tcAsh,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: IconButton(
                                  onPressed: () {
                                    if (mounted) {
                                      setState(() {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ContactEditScreen(
                                              contact: items[index],
                                            ),
                                          ),
                                        );
                                      });
                                    }
                                  },
                                  icon: Icon(
                                    Icons.edit_note,
                                    color: tcBlack,
                                  ),
                                ),
                              ),
                            ),
                            VerticalDivider(
                              color: Colors.transparent,
                              width: 10.w,
                            ),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: tcRed,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: IconButton(
                                  onPressed: () {
                                    if (mounted) {
                                      setState(() {
                                        deleteContactById(items[index].id!);
                                      });
                                    }
                                  },
                                  icon: Icon(
                                    Icons.delete_rounded,
                                    color: tcWhite,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> deleteContactById(int id) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  final contactsData = prefs.getStringList('contactData') ?? [];
  final updatedContactsData = List<String>.from(contactsData);

  // Find the index of the contact with the specified ID in the list
  final indexToDelete = updatedContactsData.indexWhere((contactJson) {
    final contact = ContactModel.fromJson(jsonDecode(contactJson));
    return contact.id == id;
  });

  if (indexToDelete != -1) {
    // Remove the contact at the specified index
    updatedContactsData.removeAt(indexToDelete);

    // Update the contact data in SharedPreferences
    await prefs.setStringList('contactData', updatedContactsData);

    // Optionally, you can handle success here
    print('Contact with ID $id deleted successfully.');
  } else {
    print('Contact with ID $id not found.');
  }
}

Uint8List decodeBase64ToUint8List(String base64String) {
  final Uint8List uint8list = base64Decode(base64String);
  return uint8list;
}
