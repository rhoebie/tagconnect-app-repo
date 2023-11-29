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
      Uri.parse('$baseUrl${ApiConstants.countReportEndpoint}'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Parse the response JSON directly as a list
      List<dynamic> responseData = json.decode(response.body);

      // Map the list of report data to ReportModels
      return responseData.map((item) => ReportModel.fromJson(item)).toList();
    } else {
      print(response.statusCode);
      throw Exception('Failed to load reports');
    }
  }

  Future<ReportModel> getReportById(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl${ApiConstants.countReportEndpoint}/$id'),
      headers: {
        'Authorization':
            'Bearer $token', // Include the token as an Authorization header
      },
    );

    if (response.statusCode == 200) {
      // Parse the response JSON
      Map<String, dynamic> responseData = json.decode(response.body);

      // Extract the "data" list from the response
      Map<String, dynamic> data = responseData['data'];

      return ReportModel.fromJson(data);
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<bool> createReport(CreateReportModel report) async {
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
      print('Report submitted successfully');
      return true;
    } else {
      print('Error submitting the report: ${response.body}');
      return false;
    }
  }

  Future<void> putReport(ReportModel report) async {
    final response = await http.put(
      Uri.parse('$baseUrl${ApiConstants.countReportEndpoint}/${report.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(report.toJson()),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to update report');
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

  Future<void> deleteReport(int id) async {
    final response = await http
        .delete(Uri.parse('$baseUrl${ApiConstants.countReportEndpoint}/$id'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete report');
    }
  }
}
