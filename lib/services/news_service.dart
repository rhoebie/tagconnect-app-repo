import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:TagConnect/constants/endpoint_constant.dart';
import 'package:TagConnect/models/news_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsService {
  final String baseUrl = ApiConstants.apiUrl;

  Future<List<NewsModel>?> getNews(int page) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    try {
      final url = '$baseUrl${ApiConstants.newsEndpoint}?page=$page';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'];

        List<NewsModel> fetchNewsList =
            data.map((item) => NewsModel.fromJson(item)).toList();

        // Sort the list based on the date
        fetchNewsList.sort((a, b) => a.date!.compareTo(b.date!));

        return fetchNewsList;
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
