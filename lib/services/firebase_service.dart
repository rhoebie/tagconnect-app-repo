// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class FirebaseApiService {
//   final _firebaseMessaging = FirebaseMessaging.instance;

//   Future<void> initNotifications() async {
//     final prefs = await SharedPreferences.getInstance();
//     await _firebaseMessaging.requestPermission();

//     final fCMToken = await _firebaseMessaging.getToken();
//     await prefs.setString('fCMToken', fCMToken!);
//     print('Token: $fCMToken');
//   }
// }
