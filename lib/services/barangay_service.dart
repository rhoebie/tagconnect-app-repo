import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:TagConnect/constants/endpoint_constant.dart';
import 'package:TagConnect/models/barangay_model.dart';

class BarangayService {
  final String baseUrl = ApiConstants.apiUrl;

  Future<List<BarangayModel>> getbarangays() async {
    final response = await http.get(
      Uri.parse('$baseUrl${ApiConstants.barangayEndpoint}'),
      // headers: {
      //   'Authorization': 'Bearer $token',
      // },
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
  }

  Future<BarangayModel> getbarangayById(int id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl${ApiConstants.barangayEndpoint}/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return BarangayModel.fromJson(data);
    } else {
      throw Exception('Failed to load barangay');
    }
  }

  Future<void> createbarangay(BarangayModel barangay) async {
    final response = await http.post(
      Uri.parse('$baseUrl${ApiConstants.barangayEndpoint}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(barangay.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create barangay');
    }
  }

  Future<void> updatebarangay(BarangayModel barangay) async {
    final response = await http.put(
      Uri.parse('$baseUrl${ApiConstants.barangayEndpoint}/${barangay.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(barangay.toJson()),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to update barangay');
    }
  }

  Future<void> deletebarangay(int id) async {
    final response = await http
        .delete(Uri.parse('$baseUrl${ApiConstants.barangayEndpoint}/$id'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete barangay');
    }
  }
}
