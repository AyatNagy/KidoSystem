import 'package:flutter/foundation.dart';
import 'package:kido/api_service/api_services.dart';
import 'package:kido/services/child_session_service.dart';

/// Persists lesson completion on the server (`POST /progress/complete`).
class LessonProgressService {
  LessonProgressService._();

  static Future<bool> markLessonCompleted(
    int lessonId, {
    required int childId,
  }) async {
    if (lessonId <= 0 || childId <= 0) return false;

    // Parent app flow: parent JWT + childId (backend Kido_backendd).
    var res = await ApiService.completeLessonAsParent(
      childId: childId,
      lessonId: lessonId,
    );
    if (res != null && res['success'] == true) return true;

    // Fallback: child JWT from stored credentials.
    if (await ChildSessionService.ensureLoggedIn(childId)) {
      res = await ApiService.completeLesson(lessonId: lessonId);
      if (res != null && res['success'] == true) return true;
    }

    if (kDebugMode) {
      debugPrint(
        'LessonProgressService: failed lessonId=$lessonId childId=$childId '
        '→ ${res?['message']}',
      );
    }
    return false;
  }
}
