import 'package:dio/dio.dart';
import 'package:kido/Models/user.dart';
import 'package:kido/Models/child.dart';
import 'package:kido/Models/exams/placement_exam_model.dart';
import 'package:kido/Models/progress_report.dart';
import 'package:kido/config/cache_helper.dart';

class ApiService {
  /// Local backend. On Android emulator use `http://10.0.2.2:3000/api` instead of localhost.
  //static const String baseUrl = "http://localhost:3000/api";
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

  /// Child login (username + password). Saves child JWT and id on success.
  static Future<Map<String, dynamic>?> loginChild(
    String username,
    String password,
  ) async {
    final dio = Dio();
    final url = '$baseUrl/child/login';

    try {
      final response = await dio.post(
        url,
        data: {'username': username.trim(), 'password': password},
        options: Options(
          headers: {'Content-Type': 'application/json'},
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final data = response.data as Map<String, dynamic>;
        final token = data['token'] as String?;
        final child = data['child'];
        if (token != null) {
          await LocalStorage.setChildToken(token);
        }
        if (child is Map && child['id'] != null) {
          await LocalStorage.setChildId((child['id'] as num).toInt());
        }
        return data;
      }
      return response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : {'success': false, 'message': 'Login failed'};
    } on DioException catch (e) {
      if (e.response?.data is Map<String, dynamic>) {
        return e.response!.data as Map<String, dynamic>;
      }
      return {'success': false, 'message': e.message ?? 'Network error'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  /// Parent-only: list children for home screen (Bearer parent token).
  static Future<Map<String, dynamic>?> fetchMyChildren() async {
    final dio = Dio();
    final url = '$baseUrl/child/my';
    final parentToken = await LocalStorage.getParentToken();

    if (parentToken == null) {
      return null;
    }

    try {
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $parentToken',
          },
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200 &&
          response.data is Map &&
          response.data['success'] == true) {
        return Map<String, dynamic>.from(response.data as Map);
      }
      return response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : null;
    } on DioException catch (e) {
      print('fetchMyChildren: ${e.response?.statusCode} - ${e.response?.data}');
      return null;
    } catch (e) {
      print('fetchMyChildren: $e');
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

  /// Parent auth: updates child's `allowedLevel` (`setInitialLevel` on backend).
  /// Backend: `PUT /child/set-level` with `{ childId, levelId }` (see Child routes).
  static Map<String, dynamic>? _asJsonMap(dynamic data) {
    if (data == null) return null;
    if (data is Map<String, dynamic>) return Map<String, dynamic>.from(data);
    if (data is Map) {
      return data.map((k, v) => MapEntry(k.toString(), v));
    }
    return null;
  }

  /// True when the server accepted the update (handles slight API variations).
  static bool _setLevelResponseOk(int? status, Map<String, dynamic>? map) {
    if (status != 200 && status != 201) return false;
    if (map == null) return false;
    final s = map['success'];
    if (s == true || s == 'true') return true;
    if (map.containsKey('allowedLevel') && map['allowedLevel'] != null) {
      return true;
    }
    return false;
  }

  static Future<Map<String, dynamic>?> setChildAllowedLevel({
    required int childId,
    required int levelId,
  }) async {
    final parentToken = await LocalStorage.getParentToken();
    if (parentToken == null) {
      return {'success': false, 'message': 'Parent token missing'};
    }

    final dio = Dio();
    final url = '$baseUrl/child/set-level';
    final payload = {'childId': childId, 'levelId': levelId};

    try {
      final response = await dio.put(
        url,
        data: payload,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $parentToken',
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      final map = _asJsonMap(response.data);
      if (_setLevelResponseOk(response.statusCode, map)) {
        final out = Map<String, dynamic>.from(map ?? {});
        out['success'] = true;
        if (!out.containsKey('allowedLevel')) {
          out['allowedLevel'] = levelId;
        }
        return out;
      }
      if (map != null) {
        return map;
      }
      if (response.statusCode == 200) {
        return {'success': true, 'allowedLevel': levelId};
      }
      return {
        'success': false,
        'message': 'Unexpected status ${response.statusCode}',
      };
    } on DioException catch (e) {
      final map = _asJsonMap(e.response?.data);
      return map ?? {'success': false, 'message': e.message ?? 'Network error'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  /// Child JWT: mark lesson completed. Backend: `POST /progress/complete` `{ lessonId }`.
  static Future<Map<String, dynamic>?> completeLesson({
    required int lessonId,
  }) async {
    final token = await LocalStorage.getChildToken();
    if (token == null) {
      return {'success': false, 'message': 'Child token missing'};
    }

    final dio = Dio();
    final url = '$baseUrl/progress/complete';

    try {
      final response = await dio.post(
        url,
        data: {'lessonId': lessonId},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      final map = _asJsonMap(response.data);
      if (response.statusCode == 200 && map != null && map['success'] == true) {
        return map;
      }
      return map ?? {'success': false, 'message': 'completeLesson failed'};
    } on DioException catch (e) {
      return _asJsonMap(e.response?.data) ??
          {'success': false, 'message': e.message ?? 'Network error'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  /// Child JWT: grouped progress. Backend: `GET /progress/my`.
  static Future<ProgressReport?> fetchMyProgressAsChild() async {
    final token = await LocalStorage.getChildToken();
    if (token == null) return null;

    final dio = Dio();
    final url = '$baseUrl/progress/my';

    try {
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      final map = _asJsonMap(response.data);
      if (response.statusCode == 200 && map != null && map['success'] == true) {
        return ProgressReport.fromApiJson(map);
      }
      return null;
    } on DioException catch (_) {
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Parent JWT: detailed progress for one child (same JSON as child `getMyProgress`).
  ///
  /// Add on backend **before** `/:childId` catch-alls:
  /// `router.get('/:childId/progress', authenticateParent, getChildProgress)`
  /// mounted on `/child` → `GET /api/child/:childId/progress`
  /// Handler: verify `child.motherId === req.user.id`, then reuse `getMyProgress` query with `childId` param.
  static Future<ProgressReport?> fetchChildProgressAsParent(int childId) async {
    final token = await LocalStorage.getParentToken();
    if (token == null) return null;

    final dio = Dio();
    final url = '$baseUrl/child/$childId/progress';

    try {
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      final map = _asJsonMap(response.data);
      if (response.statusCode == 200 && map != null && map['success'] == true) {
        return ProgressReport.fromApiJson(map);
      }
      return null;
    } on DioException catch (_) {
      return null;
    } catch (_) {
      return null;
    }
  }
}
