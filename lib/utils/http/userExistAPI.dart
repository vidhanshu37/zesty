import 'dart:convert';

import 'package:http/http.dart' as http;

class UserExistAPI {
  static Future<int> userExistPhone(phoneNumber) async {
    final url = Uri.parse('https://zesty-backend.onrender.com/user/user-exist');
    try {
      final response = await http.post(
          url,
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "mobile": phoneNumber,
          })
      );
      return response.statusCode;
    } catch (e) {
      return 500;
    }
  }

  static Future<int> userRegisterAPI(phoneNumber, email, address, latitude,
      longitude) async {
    final url = Uri.parse('https://zesty-backend.onrender.com/user/register');
    try {
      final response = await http.post(
          url,
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "mobile": phoneNumber,
            "email": email,
            "address": address,
            "latitute": latitude,
            "longitude": longitude
          }));
      return response.statusCode;
    } catch (e) {
      return 500;
    }
  }
}