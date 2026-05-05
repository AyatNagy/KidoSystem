import 'package:dio/dio.dart';
import 'package:kido/Models/user.dart';
import 'package:kido/Models/child.dart';
import 'package:kido/Models/placement_exam_model.dart';
import 'package:kido/config/cache_helper.dart';

class ApiService {
  // static const String baseUrl = "http://localhost:3000/api";
  //static const String baseUrl = "https://kidosystem.duckdns.org/api";
  static const String baseUrl = "https://kido-backendd.vercel.app/api";

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
        print(
          "Error during registration: ${e.response?.statusCode} - ${e.response?.data}",
        );
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

        // Save parent token and user ID
        if (data['token'] != null) {
          await LocalStorage.setParentToken(data['token']);
        }
        if (data['user'] != null && data['user']['id'] != null) {
          await LocalStorage.setUserId(data['user']['id']);
        }

        return data;
      } else {
        print("Login Failed: ${response.statusCode} - ${response.data}");
        return null;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print(
          "Error during login: ${e.response?.statusCode} - ${e.response?.data}",
        );
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
        // Return error response data to show proper error message
        print(
          "Forget Password Failed: ${response.statusCode} - ${response.data}",
        );
        return response.data as Map<String, dynamic>?;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print(
          "Error during forget password: ${e.response?.statusCode} - ${e.response?.data}",
        );
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
        data: {"email": email, "otpCode": otpCode, "newPassword": newPassword},
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
        // Return error response data to show proper error message
        print(
          "Reset Password Failed: ${response.statusCode} - ${response.data}",
        );
        return response.data as Map<String, dynamic>?;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print(
          "Error during reset password: ${e.response?.statusCode} - ${e.response?.data}",
        );
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
        // Return error response data to show proper error message
        print("Verify OTP Failed: ${response.statusCode} - ${response.data}");
        return response.data as Map<String, dynamic>?;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print(
          "Error during OTP verification: ${e.response?.statusCode} - ${e.response?.data}",
        );
      } else {
        print("Error during OTP verification: ${e.message}");
      }
      return null;
    } catch (e) {
      print("Error during OTP verification: $e");
      return null;
    }
  }

  // Child Registration (requires parent authentication)
  static Future<Map<String, dynamic>?> registerChild(Child child) async {
    final dio = Dio();
    final url = '$baseUrl/child/register';

    // Get parent token from storage
    final parentToken = await LocalStorage.getParentToken();

    if (parentToken == null) {
      print("Error: Parent token not found. Please login as parent first.");
      return null;
    }

    try {
      final response = await dio.post(
        url,
        data: child.toJson(),
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization":
                "Bearer $parentToken", // Add parent token to header
          },
          validateStatus: (status) {
            return status! < 500; // Don't throw for 4xx errors
          },
        ),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data;
        print("Child Registered Successfully: ${data['child']}");

        // Save child data if needed
        if (data['child'] != null && data['child']['id'] != null) {
          await LocalStorage.setChildId(data['child']['id']);
        }

        return data;
      } else {
        // Return error response data to show proper error message
        print(
          "Child Registration Failed: ${response.statusCode} - ${response.data}",
        );
        return response.data as Map<String, dynamic>?;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print(
          "Error during child registration: ${e.response?.statusCode} - ${e.response?.data}",
        );
      } else {
        print("Error during child registration: ${e.message}");
      }
      return null;
    } catch (e) {
      print("Error during child registration: $e");
      return null;
    }
  }

  static Future<PlacementExamResult> getPlacementExam({
    required int age,
    required int childId,
  }) async {
    final dio = Dio();
    final url = '$baseUrl/placement-exam/by-age';

    final parentToken = await LocalStorage.getParentToken();

    if (parentToken == null) {
      throw Exception("Parent token not found. Please login first.");
    }

    try {
      final response = await dio.post(
        url,
        data: {'age': age, 'childId': childId},
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $parentToken",
          },
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200) {
        return PlacementExamResult.fromJson(response.data);
      } else {
        throw Exception(
          "Placement exam failed: ${response.statusCode} - ${response.data}",
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          "Dio error: ${e.response?.statusCode} - ${e.response?.data}",
        );
      } else {
        throw Exception("Network error: ${e.message}");
      }
    }
  }

  static Future<Map<String, dynamic>> submitPlacementExam({
    required int childId,
    required int placementExamId,
    required double score,
  }) async {
    final dio = Dio();
    final url = '$baseUrl/placement-exam/submit';

    final parentToken = await LocalStorage.getParentToken();
    if (parentToken == null) {
      throw Exception("Parent token not found. Please login first.");
    }

    try {
      final response = await dio.post(
        url,
        data: {
          'childId': childId,
          'placementExamId': placementExamId,
          'score': score,
        },
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $parentToken",
          },
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(
          "Submit placement exam failed: ${response.statusCode} - ${response.data}",
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          "Dio error: ${e.response?.statusCode} - ${e.response?.data}",
        );
      } else {
        throw Exception("Network error: ${e.message}");
      }
    }
  }
}
