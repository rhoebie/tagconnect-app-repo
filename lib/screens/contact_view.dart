import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taguigconnect/constants/color_constant.dart';
import 'package:taguigconnect/models/contact_model.dart';

class ContactViewScreen extends StatelessWidget {
  final ContactModel contact;
  const ContactViewScreen({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
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
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {},
            icon: Icon(Icons.edit),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: tcAsh,
                            radius: 30,
                            child: Icon(
                              Icons.message,
                              color: tcViolet,
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
                          CircleAvatar(
                            backgroundColor: tcAsh,
                            radius: 30,
                            child: Icon(
                              Icons.phone,
                              color: tcViolet,
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
                          CircleAvatar(
                            backgroundColor: tcAsh,
                            radius: 30,
                            child: Icon(
                              Icons.email,
                              color: tcViolet,
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
                  ),
                  Divider(
                    color: Colors.transparent,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
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
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: tcBlack,
                          ),
                        ),
                        Text(
                          contact.firstname ?? '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14.sp,
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
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: tcBlack,
                          ),
                        ),
                        Text(
                          contact.lastname ?? '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14.sp,
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
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: tcBlack,
                          ),
                        ),
                        Text(
                          contact.email ?? '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14.sp,
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
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: tcBlack,
                          ),
                        ),
                        Text(
                          contact.contact ?? '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: tcBlack,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () async {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tcRed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    'Delete',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PublicSans',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: tcWhite,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
