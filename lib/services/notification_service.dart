import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:TagConnect/constants/endpoint_constant.dart';

class NotificationService {
  final String baseUrl = ApiConstants.apiUrl;

  Future<bool> triggerNotification(String fcmToken) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/send-notif'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'userToken': fcmToken,
          'title': 'New Incident Report: Action Needed',
          'body':
              'A new incident report has been submitted within your designated barangay boundary.',
        }),
      );

      if (response.statusCode == 200) {
        print(response.body);
        return true;
      } else {
        print(response.statusCode);
        print(response.body);
        throw Exception('Failed to send notif');
      }
    } catch (e) {
      throw Exception('Failed $e');
    }
  }
}
