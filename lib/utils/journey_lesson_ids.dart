import 'package:kido/Models/level3/letters/letter_map.dart';
import 'package:kido/data/lesson_catalog.dart';

/// Lesson id for a numbers-map node (skips train-only nodes).
int? numbersMapLessonId(LetterJourney item, int index, {required bool isEnglish}) {
  if (item.charName?.startsWith('train') == true) return null;

  for (final c in LessonCatalog.categories) {
    if (c.name != 'Numbers') continue;
    final ids = c.lessonIds;
    if (ids.isEmpty) return null;
    if (index < ids.length) return ids[index];
    return ids.last;
  }
  return null;
}

/// English / Arabic letter maps: 4 nodes → first 4 letter lesson ids in DB.
int? lettersMapLessonId(int index) {
  for (final c in LessonCatalog.categories) {
    if (c.name != 'Letters') continue;
    if (index < c.lessonIds.length) return c.lessonIds[index];
    return null;
  }
  return null;
}
