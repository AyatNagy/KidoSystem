import 'package:dio/dio.dart';
import 'package:kido/Models/user.dart';

class ApiService {
  static const String baseUrl = "http://localhost:3000/api";
  //static const String baseUrl = "https://kidosystem.duckdns.org/api";

  static Future<bool> registerUser(User user) async {
    final dio = Dio();
    final url = '$baseUrl/auth/register';

    try {
      final response = await dio.post(
        url,
        data: user.toJson(),
        options: Options(
          headers: {"Content-Type": "application/json"},
          validateStatus: (status) {
            return status! < 500; // Don't throw for 4xx errors
          },
        ),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print("Registered Successfully");
        return true;
      } else {
        print("Register Failed: ${response.statusCode} - ${response.data}");
        return false;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print("Error during registration: ${e.response?.statusCode} - ${e.response?.data}");
      } else {
        print("Error during registration: ${e.message}");
      }
      return false;
    } catch (e) {
      print("Error during registration: $e");
      return false;
    }
  }

  static Future<Map<String, dynamic>?> loginUser(
    String email,
    String password,
  ) async {
    final dio = Dio();
    final url = '$baseUrl/auth/login';

    try {
      final response = await dio.post(
        url,
        data: {"email": email, "password": password},
        options: Options(
          headers: {"Content-Type": "application/json"},
          validateStatus: (status) {
            return status! < 500; // Don't throw for 4xx errors
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        print("Login Successful: ${data['user']}");
        return data;
      } else {
        print("Login Failed: ${response.statusCode} - ${response.data}");
        return null;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print("Error during login: ${e.response?.statusCode} - ${e.response?.data}");
      } else {
        print("Error during login: ${e.message}");
      }
      return null;
    } catch (e) {
      print("Error during login: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> forgetPassword(String email) async {
    final dio = Dio();
    final url = '$baseUrl/auth/forget';

    try {
      final response = await dio.post(
        url,
        data: {"email": email},
        options: Options(
          headers: {"Content-Type": "application/json"},
          validateStatus: (status) {
            return status! < 500; // Don't throw for 4xx errors
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        print("OTP Sent Successfully: ${data['message']}");
        return data;
      } else {
        print("Forget Password Failed: ${response.statusCode} - ${response.data}");
        return null;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print("Error during forget password: ${e.response?.statusCode} - ${e.response?.data}");
      } else {
        print("Error during forget password: ${e.message}");
      }
      return null;
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
    final dio = Dio();
    final url = '$baseUrl/auth/reset-password';

    try {
      final response = await dio.post(
        url,
        data: {
          "email": email,
          "otpCode": otpCode,
          "newPassword": newPassword,
        },
        options: Options(
          headers: {"Content-Type": "application/json"},
          validateStatus: (status) {
            return status! < 500; // Don't throw for 4xx errors
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        print("Password Reset Successful: ${data['message']}");
        return data;
      } else {
        print("Reset Password Failed: ${response.statusCode} - ${response.data}");
        return null;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print("Error during reset password: ${e.response?.statusCode} - ${e.response?.data}");
      } else {
        print("Error during reset password: ${e.message}");
      }
      return null;
    } catch (e) {
      print("Error during reset password: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> verifyOtp(
    String email,
    String otpCode,
  ) async {
    final dio = Dio();
    final url = '$baseUrl/auth/verify-otp';

    try {
      final response = await dio.post(
        url,
        data: {"email": email, "otpCode": otpCode},
        options: Options(
          headers: {"Content-Type": "application/json"},
          validateStatus: (status) {
            return status! < 500; // Don't throw for 4xx errors
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        print("OTP Verified Successfully: ${data['message']}");
        return data;
      } else {
        print("Verify OTP Failed: ${response.statusCode} - ${response.data}");
        return null;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print("Error during OTP verification: ${e.response?.statusCode} - ${e.response?.data}");
      } else {
        print("Error during OTP verification: ${e.message}");
      }
      return null;
    } catch (e) {
      print("Error during OTP verification: $e");
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
