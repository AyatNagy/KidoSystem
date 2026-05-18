import 'package:flutter/material.dart';
import 'package:kido/Pages/Auth/parent_login_screen.dart';
import 'package:kido/Pages/parent_content/parent_home_page.dart';
import 'package:kido/Pages/shared/start_page.dart';
import 'package:kido/config/cache_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum StartupDestination { parentHome, parentLogin, start }

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
    final token = await LocalStorage.getParentToken();
    if (token == null || token.isEmpty) return false;

    final loggedIn = await LocalStorage.getLoggedIn();
    if (!loggedIn) {
      await LocalStorage.setLoggedIn(true);
    }
    return true;
  }

  static Future<StartupDestination> getStartupDestination() async {
    if (await isParentLoggedIn()) {
      return StartupDestination.parentHome;
    }
    if (await isOnboardingSeen()) {
      return StartupDestination.parentLogin;
    }
    return StartupDestination.start;
  }

  static Widget widgetForDestination(StartupDestination destination) {
    switch (destination) {
      case StartupDestination.parentHome:
        return const ParentHomePage();
      case StartupDestination.parentLogin:
        return const ParentLogin();
      case StartupDestination.start:
        return const Start();
    }
  }

  static void navigateToLogin(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const ParentLogin()),
      (route) => false,
    );
  }
}
