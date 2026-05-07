// lib/progress_manager.dart
import 'package:shared_preferences/shared_preferences.dart';

class ProgressManager {
  static const String _levelKey = "unlocked_level";

  static Future<void> unlockUpTo(int level) async {
    final prefs = await SharedPreferences.getInstance();
    int current = prefs.getInt(_levelKey) ?? 1;
    if (level > current) {
      await prefs.setInt(_levelKey, level);
    }
  }

  static Future<int> getUnlockedLevel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_levelKey) ?? 1;
  }
}