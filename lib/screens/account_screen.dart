import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:TagConnect/constants/color_constant.dart';
import 'package:TagConnect/constants/endpoint_constant.dart';
import 'package:TagConnect/models/user_model.dart';
import 'package:TagConnect/screens/account-edit_screen.dart';
import 'package:TagConnect/services/user_service.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String? imageUrl;
  late UserModel userModel;

  Future<UserModel?> fetchUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      // Initialize Service for User
      final userService = UserService();
      final userId = prefs.getInt('userId');

      if (userId != null) {
        final UserModel userData = await userService.getUserById(userId);
        userModel = userData;
        return userData;
      } else {
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<void> refresh() async {
    try {
      setState(() {});
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tcWhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: CloseButton(),
        iconTheme: const IconThemeData(color: tcBlack),
        backgroundColor: tcWhite,
        elevation: 0,
        title: Text(
          'ACCOUNT',
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
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return AccountEditWidget(
                        userModel: userModel, callbackFunction: refresh);
                  },
                ),
              );
            },
            icon: Icon(Icons.edit),
          ),
        ],
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: FutureBuilder(
            future: fetchUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  width: double.infinity,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: tcViolet,
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                final items = snapshot.data;
                items?.image != null
                    ? imageUrl = ApiConstants.baseUrl + items!.image!
                    : imageUrl = null;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(50),
                            ),
                            child: (imageUrl?.isEmpty ?? true)
                                ? Center(
                                    child: Icon(
                                      Icons.question_mark,
                                      size: 50,
                                      color: tcBlack,
                                    ),
                                  )
                                : Image.network(
                                    imageUrl!,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        VerticalDivider(
                          color: Colors.transparent,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 210,
                              child: AutoSizeText(
                                '${items!.lastname}, ${items.firstname} ${items.middlename}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: tcBlack,
                                  fontFamily: 'PublicSans',
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Divider(
                              color: Colors.transparent,
                              height: 5,
                            ),
                            RichText(
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                style: TextStyle(
                                  fontFamily: 'PublicSans',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: tcBlack,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Account ID: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  TextSpan(
                                    text: items.id.toString(),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              color: Colors.transparent,
                              height: 5,
                            ),
                            RichText(
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                style: TextStyle(
                                  fontFamily: 'PublicSans',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: tcBlack,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Role: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  TextSpan(
                                    text: items.roleId,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Divider(
                      color: Colors.transparent,
                      height: 30,
                    ),
                    Text(
                      'Personal Information',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: tcBlack,
                      ),
                    ),
                    Divider(
                      color: Colors.transparent,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Birth Date',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: tcBlack,
                                ),
                              ),
                              Text(
                                DateFormat.yMMMMd().format(
                                    DateTime.parse(items.birthdate.toString())),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: tcBlack,
                                  fontFamily: 'PublicSans',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.transparent,
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Age',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: tcBlack,
                                ),
                              ),
                              Text(
                                items.age.toString(),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: tcBlack,
                                  fontFamily: 'PublicSans',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.transparent,
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Address',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: tcBlack,
                                ),
                              ),
                              Container(
                                width: 150,
                                child: AutoSizeText(
                                  items.address ?? '',
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    fontFamily: 'PublicSans',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: tcBlack,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.transparent,
                      height: 30,
                    ),
                    Text(
                      'Contact Information',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: tcBlack,
                      ),
                    ),
                    Divider(
                      color: Colors.transparent,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Contact',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: tcBlack,
                                ),
                              ),
                              Text(
                                items.contactnumber ?? '',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: tcBlack,
                                  fontFamily: 'PublicSans',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.transparent,
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Email',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: tcBlack,
                                ),
                              ),
                              Text(
                                items.email ?? '',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: tcBlack,
                                  fontFamily: 'PublicSans',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.transparent,
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Status',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: tcBlack,
                                ),
                              ),
                              Text(
                                items.status ?? '',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: tcBlack,
                                  fontFamily: 'PublicSans',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.transparent,
                            height: 10,
                          ),
                        ],
                      ),
                    )
                  ],
                );
              } else {
                return Center(
                  child: Text('No data available'),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
