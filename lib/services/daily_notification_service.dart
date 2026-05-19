import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Daily encouraging notification for the child (bell icon in parent home).
class DailyNotificationService {
  DailyNotificationService._();

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const _channelId = 'kido_daily_reminder';
  static const _prefsEnabled = 'daily_notification_enabled';
  static const _prefsHour = 'daily_notification_hour';
  static const _prefsMinute = 'daily_notification_minute';

  static bool _initialized = false;

  static const _titlesEn = [
    'Time to learn with Kido!',
    'Your daily adventure awaits!',
    'Ready for a fun lesson today?',
  ];

  static const _titlesAr = [
    'وقت التعلّم مع كيدو!',
    'مغامرتك اليومية بانتظارك!',
    'جاهز لدرس ممتع اليوم؟',
  ];

  static const _bodiesEn = [
    'Open Kido and complete a lesson — you are doing great!',
    'A few minutes of play today keeps learning growing!',
    'Pick a level and have fun learning something new.',
  ];

  static const _bodiesAr = [
    'افتح كيدو وأكمل درساً — أنت رائع!',
    'دقائق لعب اليوم تبقي التعلّم ينمو!',
    'اختار مستواك واستمتع بتعلّم جديد.',
  ];

  static Future<void> initialize() async {
    if (_initialized) return;

    tz_data.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );

    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();

    _initialized = true;

    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_prefsEnabled) ?? true) {
      await scheduleDaily(isArabic: prefs.getString('app_locale_code') == 'ar');
    }
  }

  static Future<void> scheduleDaily({bool isArabic = false}) async {
    if (!_initialized) await initialize();

    final prefs = await SharedPreferences.getInstance();
    final hour = prefs.getInt(_prefsHour) ?? 9;
    final minute = prefs.getInt(_prefsMinute) ?? 0;

    final titles = isArabic ? _titlesAr : _titlesEn;
    final bodies = isArabic ? _bodiesAr : _bodiesEn;
    final dayIndex = DateTime.now().day % titles.length;

    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      'Daily learning reminder',
      channelDescription: 'Friendly daily reminder for kids to learn on Kido',
      importance: Importance.high,
      priority: Priority.high,
    );

    await _plugin.zonedSchedule(
      1001,
      titles[dayIndex],
      bodies[dayIndex],
      scheduled,
      const NotificationDetails(
        android: androidDetails,
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    await prefs.setBool(_prefsEnabled, true);
    if (kDebugMode) {
      debugPrint('DailyNotificationService: scheduled at $hour:$minute');
    }
  }

  static Future<void> showNow({bool isArabic = false}) async {
    if (!_initialized) await initialize();

    final titles = isArabic ? _titlesAr : _titlesEn;
    final bodies = isArabic ? _bodiesAr : _bodiesEn;
    final i = DateTime.now().day % titles.length;

    await _plugin.show(
      1002,
      titles[i],
      bodies[i],
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          'Daily learning reminder',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsEnabled, false);
  }
}
