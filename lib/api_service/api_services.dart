import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kido/Models/user.dart';

class ApiService {
  static const String baseUrl = "http://localhost:3000/api";
  //static const String baseUrl = "https://kidosystem.duckdns.org/api";

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

  static Future<Map<String, dynamic>?> forgetPassword(String email) async {
    final url = Uri.parse('$baseUrl/auth/forget');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("OTP Sent Successfully: ${data['message']}");
        return data;
      } else {
        print("Forget Password Failed: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error during forget password: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> resetPassword(
    String email,
    String otpCode,
    String newPassword,
  ) async {
    final url = Uri.parse('$baseUrl/auth/reset-password');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "otpCode": otpCode,
          "newPassword": newPassword,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Password Reset Successful: ${data['message']}");
        return data;
      } else {
        print("Reset Password Failed: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error during reset password: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> verifyOtp(
    String email,
    String otpCode,
  ) async {
    final url = Uri.parse('$baseUrl/auth/verify-otp');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "otpCode": otpCode}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("OTP Verified Successfully: ${data['message']}");
        return data;
      } else {
        print("Verify OTP Failed: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error during OTP verification: $e");
      return null;
    }
  }
}
