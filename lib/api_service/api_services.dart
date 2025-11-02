import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kido/Models/user.dart';

class ApiService {
  static const String baseUrl = "https://kidosystem.duckdns.org/api";

  static Future<bool> registerUser(User user) async {
    final url = Uri.parse('$baseUrl/auth/register');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print("Registered Successfully");
        return true;
      } else {
        print(" Register Failed: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error during registration: $e");
      return false;
    }
  }

  static Future<Map<String, dynamic>?> loginUser(
    String email,
    String password,
  ) async {
    final url = Uri.parse('$baseUrl/auth/login');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Login Successful: ${data['user']}");
        return data;
      } else {
        print(" Login Failed: ${response.body}");
        return null;
      }
    } catch (e) {
      print(" Error during login: $e");
      return null;
    }
  }
}
