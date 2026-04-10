import 'package:kido/config/cache_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLaunch {
  static const _onboardingSeenKey = 'onboarding_seen_v1';

  static Future<bool> isOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingSeenKey) ?? false;
  }

  static Future<void> setOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingSeenKey, true);
  }

  static Future<bool> isParentLoggedIn() async {
    final loggedIn = await LocalStorage.getLoggedIn();
    final token = await LocalStorage.getParentToken();
    return loggedIn && token != null && token.isNotEmpty;
  }
}

