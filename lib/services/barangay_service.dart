import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:TagConnect/constants/endpoint_constant.dart';
import 'package:TagConnect/models/barangay_model.dart';

class BarangayService {
  final String baseUrl = ApiConstants.apiUrl;

  Future<List<BarangayModel>> getbarangays() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    try {
      final response = await http.get(
        Uri.parse('$baseUrl${ApiConstants.barangayEndpoint}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Parse the response JSON
        Map<String, dynamic> responseData = json.decode(response.body);

        // Extract the "data" list from the response
        List<dynamic> data = responseData['data'];

        // Map the list of role data to BarangayModels
        return data.map((item) => BarangayModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load barangay');
      }
    } catch (e) {
      throw Exception('Failed to load barangay');
    }
  }

  Future<BarangayModel> getbarangayID(int iD) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    try {
      final response = await http.get(
        Uri.parse('https://taguigconnect.online/api/barangays/$iD'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Parse the response JSON
        Map<String, dynamic> responseData = json.decode(response.body);

        // Extract the "data" list from the response
        Map<String, dynamic> data = responseData['data'];

        // Map the list of role data to BarangayModels
        return BarangayModel.fromJson(data);
      } else {
        print(response.statusCode);
        print(response.body);
        throw Exception('Failed to load barangay');
      }
    } catch (e) {
      throw Exception('Failed to load barangay');
    }
  }
}
