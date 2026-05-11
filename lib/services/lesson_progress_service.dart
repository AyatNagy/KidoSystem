import 'package:kido/api_service/api_services.dart';
import 'package:kido/config/cache_helper.dart';

/// Call when a child finishes a lesson (needs child JWT from login).
class LessonProgressService {
  LessonProgressService._();

  static Future<bool> markLessonCompleted(int lessonId) async {
    final token = await LocalStorage.getChildToken();
    if (token == null) return false;
    final res = await ApiService.completeLesson(lessonId: lessonId);
    return res != null && res['success'] == true;
  }
}
