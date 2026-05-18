import 'package:kido/services/lesson_progress_service.dart';

/// Call when the child finishes a lesson screen (before navigating away).
Future<void> completeLessonForChild({
  required int childId,
  required int lessonId,
}) async {
  if (childId <= 0 || lessonId <= 0) return;
  await LessonProgressService.markLessonCompleted(
    lessonId,
    childId: childId,
  );
}
