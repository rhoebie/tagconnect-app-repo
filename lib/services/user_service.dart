import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:TagConnect/constants/endpoint_constant.dart';
import 'package:TagConnect/models/user_model.dart';

class UserService {
  final String baseUrl = ApiConstants.apiUrl;

  Future<UserModel> getUserById(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl${ApiConstants.userEndpoint}/$id'),
      headers: {
        'Authorization':
            'Bearer $token', // Include the token as an Authorization header
      },
    );

    if (response.statusCode == 200) {
      // Parse the response JSON
      Map<String, dynamic> responseData = json.decode(response.body);

      // Extract the "data" list from the response and provide default values for fields
      Map<String, dynamic> data = responseData['data'];

      return UserModel.fromJson(data);
    } else {
      print(response.statusCode);
      print(response.body);
      throw Exception('Failed to load user');
    }
  }

  Future<bool> registerUser(
      String firstName,
      String middleName,
      String lastName,
      int age,
      String birthdate,
      String contactNumber,
      String address,
      String email,
      String password,
      String passwordConfirmation,
      String image,
      String? fCMToken) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final body = json.encode({
      'firstname': firstName,
      'middlename': middleName,
      'lastname': lastName,
      'age': age,
      'birthdate': birthdate,
      'contactnumber': contactNumber,
      'address': address,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'image': image,
      'fCMToken': fCMToken
    });

    try {
      final response = await http.post(
        Uri.parse('$baseUrl${ApiConstants.registerUser}'),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        print(response.body);
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> changePw(String oldPw, newPw, confPw) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final uId = prefs.getInt('userId');
      final token = prefs.getString('token');
      final response = await http.patch(
        Uri.parse('$baseUrl${ApiConstants.changePassword}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'Accept': 'application/json'
        },
        body: json.encode({
          'id': uId,
          'old_password': oldPw,
          'new_password': newPw,
          'new_password_confirmation': confPw,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print(response.body);
        return false;
      }
    } catch (e) {
      throw Exception('Failed to change password');
    }
  }

  Future<bool> sendCode(String email) async {
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({'email': email});

    try {
      final response = await http.post(
        Uri.parse('$baseUrl${ApiConstants.requestCode}'),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> verify(String email, String code) async {
    final prefs = await SharedPreferences.getInstance();
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({'email': email, 'verification_code': code});

    try {
      final response = await http.post(
        Uri.parse('$baseUrl${ApiConstants.verifyCode}'),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final token = data['token'] as String;
        await prefs.setString('passwordToken', token);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> resetPassword(String uEmail, password) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final pToken = await prefs.getString('passwordToken');
      print(uEmail);
      print(pToken);
      final response = await http.post(
          Uri.parse('$baseUrl${ApiConstants.resetPassword}'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          },
          body: json.encode({
            'email': uEmail,
            'password_reset_token': pToken,
            'password': password
          }));

      if (response.statusCode == 200) {
        return true;
      } else {
        print('${response.statusCode}:${response.body}');
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<String?> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({'email': email, 'password': password});

    await prefs.remove('userId');
    await prefs.remove('token');
    await prefs.remove('userEmail');
    await prefs.remove('userPassword');

    // try to login
    try {
      final response = await http.post(
        Uri.parse('$baseUrl${ApiConstants.loginUser}'),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final userId = data['user_id'] as int;
        final token = data['token'] as String;

        // Save the token in SharedPreferences
        await prefs.setInt('userId', userId);
        await prefs.setString('token', token);
        await prefs.setString('userEmail', email);
        await prefs.setString('userPassword', password);
        return token;
      } else {
        // Handle login error
        print('Login failed. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      // Handle login exception
      print('Login error: $e');
      return null;
    }
  }

  Future<bool> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString('userEmail');
    final String? password = prefs.getString('userPassword');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({'email': email, 'password': password});

    try {
      final response = await http.post(
        Uri.parse('$baseUrl${ApiConstants.logoutUser}'),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        await prefs.remove('userId');
        await prefs.remove('token');
        await prefs.remove('userEmail');
        await prefs.remove('userPassword');
        print('Logging Out, Deleting Previous User');
        return true;
      } else {
        print(response.body);
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> patchUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId = prefs.getInt('userId');

    try {
      final response = await http.patch(
        Uri.parse('$baseUrl${ApiConstants.userEndpoint}/${userId}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'Accept': 'application/json'
        },
        body: json.encode(user.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('${response.statusCode}: ${response.body}');
        return false;
      }
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }
}
