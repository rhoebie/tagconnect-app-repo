import 'dart:convert';
import 'package:TagConnect/models/update-report_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:TagConnect/constants/endpoint_constant.dart';
import 'package:TagConnect/models/create-report_model.dart';
import 'package:TagConnect/models/report_model.dart';

class ReportService {
  final String baseUrl = ApiConstants.apiUrl;

  Future<List<ReportModel>> getReports() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl${ApiConstants.userReport}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Parse the response JSON directly as a list
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> data = responseData['data'];

      // Map the list of report data to ReportModels
      return data.map((item) => ReportModel.fromJson(item)).toList();
    } else {
      print(response.statusCode);
      throw Exception('Failed to load reports');
    }
  }

  Future<ReportModel> getReportbyID(int id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl${ApiConstants.reportEndpoint}/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Parse the response JSON directly as a list
      final Map<String, dynamic> responseData = json.decode(response.body);
      final Map<String, dynamic> data = responseData['data'];

      // Map the list of report data to ReportModels
      return ReportModel.fromJson(data);
    } else {
      print(response.statusCode);
      throw Exception('Failed to load reports');
    }
  }

  Future<String> createReport(CreateReportModel report) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('$baseUrl${ApiConstants.reportEndpoint}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Accept': 'application/json'
      },
      body: json.encode(report.toJson()),
    );

    if (response.statusCode == 201) {
      // Successfully created the report
      print('Report submitted successfully: ${response.body}');

      // Extract fcmToken from the JSON response
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      String fcmToken = jsonResponse['fcmToken'];
      return fcmToken;
    } else {
      print('Error submitting the report: ${response.body}');
      return '';
    }
  }

  Future<bool> patchReport(int id, UpdateReportModel report) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.patch(
      Uri.parse('$baseUrl${ApiConstants.reportEndpoint}/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Accept': 'application/json'
      },
      body: json.encode(report.toJson()),
    );

    if (response.statusCode == 200) {
      // Successfully created the report
      print('Report updated successfully');
      return true;
    } else {
      print('Error updating the report: ${response.body}');
      return false;
    }
  }

  Future<List<ReportModel>?> getFeedReports(String barangayName,
      {int page = 1}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    try {
      final url = Uri.parse('$baseUrl${ApiConstants.feedReports}?page=$page');
      final response = await http.post(
        url,
        body: json.encode({'barangayName': barangayName}),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'];
        List<ReportModel> reports =
            data.map((item) => ReportModel.fromJson(item)).toList();
        return reports;
      }
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }
}
