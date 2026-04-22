import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const _isLoggedInKey = 'isLoggedIn';
  static const _parentTokenKey = 'parent_token';
  static const _childTokenKey = 'child_token';
  static const _userIdKey = 'user_id';
  static const _childIdKey = 'child_id';

  // Login Status
  static Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, value);
  }

  static Future<bool> getLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Parent Token
  static Future<void> setParentToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_parentTokenKey, token);
  }

  static Future<String?> getParentToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_parentTokenKey);
  }

  // Child Token
  static Future<void> setChildToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_childTokenKey, token);
  }

  static Future<String?> getChildToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_childTokenKey);
  }

  // User ID
  static Future<void> setUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_userIdKey, userId);
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey);
  }

  // Child ID
  static Future<void> setChildId(int childId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_childIdKey, childId);
  }

  static Future<int?> getChildId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_childIdKey);
  }

  // Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, false);
    await prefs.remove(_parentTokenKey);
    await prefs.remove(_childTokenKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_childIdKey);
  }
}
