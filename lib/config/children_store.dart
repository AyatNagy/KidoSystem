import 'dart:convert';
import 'package:kido/config/cache_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChildrenStore {
  static const _childrenKeyPrefix = 'children_for_parent_';

  static Future<String> _key() async {
    final parentId = await LocalStorage.getUserId();
    return '$_childrenKeyPrefix${parentId ?? 'guest'}';
  }

  static Future<List<Map<String, dynamic>>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(await _key());
    if (raw == null || raw.isEmpty) return [];
    final decoded = jsonDecode(raw);
    if (decoded is! List) return [];
    return decoded
        .whereType<Map>()
        .map((m) => m.map((k, v) => MapEntry(k.toString(), v)))
        .toList();
  }

  static Future<void> save(List<Map<String, dynamic>> children) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(await _key(), jsonEncode(children));
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(await _key());
  }
}
