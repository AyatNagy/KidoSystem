import 'package:kido/data/lesson_catalog.dart';
import 'package:kido/utils/lesson_completion.dart';

/// Maps journey node index → DB [lessonId] for a category name.
int? lessonIdByCategoryIndex(String categoryName, int index) {
  for (final c in LessonCatalog.categories) {
    if (c.name.toLowerCase() != categoryName.toLowerCase()) continue;
    if (c.lessonIds.isEmpty) return null;
    if (index < c.lessonIds.length) return c.lessonIds[index];
    return c.lessonIds.last;
  }
  return null;
}

int? sizeLessonIdFromCharName(String? charName) {
  switch (charName?.toLowerCase()) {
    case 'big':
    case 'fat':
      return 21;
    case 'small':
      return 22;
    case 'tall':
      return 23;
    case 'short':
      return 24;
    case 'thin':
      return 25;
    default:
      return null;
  }
}

/// Marks every lesson in a category (used when a full category chain finishes).
Future<void> completeCategoryLessons({
  required int childId,
  required String categoryName,
}) async {
  if (childId <= 0) return;
  for (final c in LessonCatalog.categories) {
    if (c.name.toLowerCase() != categoryName.toLowerCase()) continue;
    for (final id in c.lessonIds) {
      await completeLessonForChild(childId: childId, lessonId: id);
    }
    return;
  }
}
