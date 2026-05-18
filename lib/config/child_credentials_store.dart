import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Username/password per child so we can obtain a child JWT for progress APIs.
class ChildCredentialsStore {
  static const _key = 'child_credentials_by_id';

  static Future<Map<int, Map<String, String>>> _loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return {};
    final decoded = jsonDecode(raw);
    if (decoded is! Map) return {};
    final out = <int, Map<String, String>>{};
    decoded.forEach((k, v) {
      final id = int.tryParse(k.toString());
      if (id == null || v is! Map) return;
      final username = v['username']?.toString();
      final password = v['password']?.toString();
      if (username != null && password != null) {
        out[id] = {'username': username, 'password': password};
      }
    });
    return out;
  }

  static Future<void> save({
    required int childId,
    required String username,
    required String password,
  }) async {
    final all = await _loadAll();
    all[childId] = {'username': username, 'password': password};
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode(
        all.map((id, creds) => MapEntry(id.toString(), creds)),
      ),
    );
  }

  static Future<Map<String, String>?> forChild(int childId) async {
    final all = await _loadAll();
    return all[childId];
  }
}
