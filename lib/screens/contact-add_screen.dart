// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:taguigconnect/constants/color_constant.dart';
// import 'package:taguigconnect/models/contact_model.dart';

// class ContactAddScreen extends StatefulWidget {
//   const ContactAddScreen({super.key});

//   @override
//   State<ContactAddScreen> createState() => _ContactAddScreenState();
// }

// class _ContactAddScreenState extends State<ContactAddScreen> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _contactController = TextEditingController();
//   final FocusNode _nameFocus = FocusNode();
//   final FocusNode _contactFocus = FocusNode();
//   XFile? _image;

//   void _pickImage() async {
//     final picker = ImagePicker();
//     final pickedImage = await picker.pickImage(source: ImageSource.gallery);

//     setState(() {
//       _image = pickedImage;
//     });
//   }

//   Future<void> saveContact(String name, String number, String? image) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();

//     // Get the last used ID or default to 0 if it doesn't exist
//     int lastUsedId = prefs.getInt('last_used_id') ?? 0;

//     // Check if image is null or empty and set it to null in that case

//     final contact = ContactModel(
//       id: lastUsedId + 1, // Auto-increment the ID
//       name: name,
//       number: number,
//       image: image, // Use the updated _image variable
//     );

//     // Encode the contact using toJson
//     final encodedContact = contact.toJson();

//     // Save the contact in SharedPreferences
//     final contactsData = prefs.getStringList('contactData') ?? [];
//     contactsData.add(jsonEncode(encodedContact));

//     // Update the last used ID
//     await prefs.setInt('last_used_id', contact.id!);

//     await prefs.setStringList('contactData', contactsData);

//     // Check if data insertion was successful
//     if (prefs.getStringList('contactData') != null) {
//       print('insert successful contact data.');
//     } else {
//       print('Failed to insert contact data.');
//     }
//   }

//   Future<String?> convertXFileToBase64(XFile? file) async {
//     if (file == null) {
//       return null;
//     }

//     final Uint8List uint8list = await File(file.path).readAsBytes();
//     final buffer = uint8list.buffer.asUint8List();
//     final base64String = base64Encode(buffer);
//     return base64String;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: tcWhite,
//       resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         leading: BackButton(),
//         iconTheme: IconThemeData(color: tcBlack),
//         backgroundColor: tcWhite,
//         elevation: 0,
//         title: Text(
//           'ADD CONTACTS',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             color: tcBlack,
//             fontFamily: 'Roboto',
//             fontSize: 20.sp,
//             fontWeight: FontWeight.w900,
//           ),
//         ),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             onPressed: () async {
//               if (_image != null) {
//                 final imageStr = await convertXFileToBase64(_image);
//                 if (_formKey.currentState != null &&
//                     _formKey.currentState!.validate()) {
//                   saveContact(
//                       _nameController.text, _contactController.text, imageStr);
//                   Navigator.pop(context);
//                 }
//               } else {
//                 if (_formKey.currentState != null &&
//                     _formKey.currentState!.validate()) {
//                   saveContact(
//                       _nameController.text, _contactController.text, null);
//                   Navigator.pop(context);
//                 }
//               }
//             },
//             icon: Icon(Icons.check),
//           ),
//           VerticalDivider(
//             width: 10.w,
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//           child: Column(
//             children: [
//               Container(
//                 width: 100,
//                 height: 100,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.rectangle,
//                   borderRadius: BorderRadius.circular(15.0),
//                   color: tcWhite,
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(15.0),
//                   child: _image != null
//                       ? Image.file(
//                           File(_image!.path),
//                           width: 100,
//                           height: 100,
//                           fit: BoxFit.cover,
//                         )
//                       : Image.asset(
//                           'assets/images/user.png',
//                           width: 100,
//                           height: 100,
//                           fit: BoxFit.cover,
//                         ),
//                 ),
//               ),
//               Divider(
//                 color: Colors.transparent,
//               ),
//               Container(
//                 height: 40.h,
//                 child: ElevatedButton(
//                   onPressed: () => setState(() {
//                     _pickImage();
//                   }),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: tcViolet,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     elevation: 2,
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.browse_gallery_outlined,
//                         size: 20,
//                         color: tcWhite,
//                       ),
//                       SizedBox(
//                         width: 5,
//                       ),
//                       Text(
//                         'Choose from Gallery',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontFamily: 'PublicSans',
//                           fontSize: 14.sp,
//                           fontWeight: FontWeight.w600,
//                           color: tcWhite,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Divider(
//                 color: Colors.transparent,
//               ),
//               Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     TextFormField(
//                       keyboardType: TextInputType.name,
//                       controller: _nameController,
//                       focusNode: _nameFocus,
//                       textAlign: TextAlign.start,
//                       style: TextStyle(
//                         fontSize: 14.sp,
//                         color: tcBlack,
//                       ),
//                       decoration: InputDecoration(
//                         labelText: 'Name',
//                         labelStyle: TextStyle(
//                           fontFamily: 'PublicSans',
//                           fontSize: 14.sp,
//                           fontWeight: FontWeight.w400,
//                         ),
//                         errorMaxLines: 2,
//                         hintText: 'Enter Name',
//                         hintStyle: TextStyle(
//                           fontFamily: 'PublicSans',
//                           fontSize: 14.sp,
//                           fontWeight: FontWeight.w400,
//                           color: tcGray,
//                         ),
//                         contentPadding: EdgeInsets.symmetric(vertical: 14),
//                         prefixIcon: Icon(
//                           Icons.person,
//                           size: 20,
//                         ),
//                         border: OutlineInputBorder(
//                           borderSide: BorderSide(
//                             width: 1.w,
//                           ),
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide(
//                             color: tcBlack,
//                             width: 1.w,
//                           ),
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(
//                             color: tcViolet,
//                             width: 2.w,
//                           ),
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         errorBorder: OutlineInputBorder(
//                           borderSide: BorderSide(
//                             color: tcRed,
//                             width: 2.w,
//                           ),
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         disabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide(
//                             color: tcGray,
//                             width: 2.w,
//                           ),
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                       ),
//                       validator: (value) {
//                         if (value == null) {
//                           return 'Name cannot be empty';
//                         }
//                         return null;
//                       },
//                     ),
//                     Divider(
//                       color: Colors.transparent,
//                     ),
//                     TextFormField(
//                       keyboardType: TextInputType.phone,
//                       controller: _contactController,
//                       focusNode: _contactFocus,
//                       textAlign: TextAlign.start,
//                       style: TextStyle(
//                         fontSize: 14.sp,
//                         color: tcBlack,
//                       ),
//                       decoration: InputDecoration(
//                         labelText: 'Contact',
//                         labelStyle: TextStyle(
//                           fontFamily: 'PublicSans',
//                           fontSize: 14.sp,
//                           fontWeight: FontWeight.w400,
//                         ),
//                         errorMaxLines: 2,
//                         hintText: 'Enter your phonenumber',
//                         hintStyle: TextStyle(
//                           fontFamily: 'PublicSans',
//                           fontSize: 14.sp,
//                           fontWeight: FontWeight.w400,
//                           color: tcGray,
//                         ),
//                         contentPadding: EdgeInsets.symmetric(vertical: 16),
//                         prefixIcon: Icon(
//                           Icons.phone,
//                           size: 20,
//                         ),
//                         border: OutlineInputBorder(
//                           borderSide: BorderSide(
//                             width: 1.w,
//                           ),
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide(
//                             color: tcBlack,
//                             width: 1.w,
//                           ),
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(
//                             color: tcViolet,
//                             width: 2.w,
//                           ),
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         errorBorder: OutlineInputBorder(
//                           borderSide: BorderSide(
//                             color: tcRed,
//                             width: 2.w,
//                           ),
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         disabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide(
//                             color: tcGray,
//                             width: 2.w,
//                           ),
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                       ),
//                       validator: (value) => validatePhoneNumber(value!),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// String? validatePhoneNumber(String value) {
//   if (value.isEmpty) {
//     return 'Please enter your phone number';
//   }

//   if (value.startsWith('09') && value.length == 11) {
//     return null; // Return null if the phone number is valid
//   }

//   return 'Invalid Format: 09 + 9 digits';
// }
