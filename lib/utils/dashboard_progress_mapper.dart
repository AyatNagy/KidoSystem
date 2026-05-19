import 'package:kido/Models/progress_report.dart';
import 'package:kido/data/lesson_catalog.dart';

/// Maps API progress + [LessonCatalog] into dashboard category progress (0.0–1.0).
class DashboardProgressMapper {
  DashboardProgressMapper._();

  static Set<int> _completedLessonIds(ProgressReport? report) {
    final ids = <int>{};
    if (report == null) return ids;
    for (final levelMap in report.grouped.values) {
      for (final lessons in levelMap.values) {
        for (final row in lessons) {
          if (row.isCompleted && row.lessonId > 0) {
            ids.add(row.lessonId);
          }
        }
      }
    }
    return ids;
  }

  /// Progress keys match [level1Data] / [level2Data] / [level3Data] in `data/dashboard.dart`.
  static Map<String, double> buildProgress({
    required int allowedLevel,
    ProgressReport? report,
  }) {
    final level = allowedLevel.clamp(1, 3);
    final completed = _completedLessonIds(report);

    switch (level) {
      case 3:
        return _level3(completed);
      case 2:
        return _level2(completed);
      default:
        return _level1(completed);
    }
  }

  static double _ratio(List<int> lessonIds, Set<int> completed) {
    if (lessonIds.isEmpty) return 0;
    final done = lessonIds.where(completed.contains).length;
    return done / lessonIds.length;
  }

  static CategorySeed? _cat(String name) {
    for (final c in LessonCatalog.categories) {
      if (c.name.toLowerCase() == name.toLowerCase()) return c;
    }
    return null;
  }

  static Map<String, double> _level1(Set<int> completed) {
    return {
      'Emotions': _ratio(_cat('Feelings')?.lessonIds ?? [], completed),
      'Self-Care': _ratio(_cat('Self Care')?.lessonIds ?? [], completed),
      'Counting': _ratio(_cat('Counting')?.lessonIds ?? [], completed),
      'Senses': _ratio(_cat('Senses')?.lessonIds ?? [], completed),
      'Matching': _ratio(_cat('Matching')?.lessonIds ?? [], completed),
      'Sorting': _ratio(_cat('Sorting')?.lessonIds ?? [], completed),
      'PegBoard': _ratio(_cat('Pegboard')?.lessonIds ?? [], completed),
    };
  }

  static Map<String, double> _level2(Set<int> completed) {
    final sizeNames = ['Big', 'Small', 'Tall', 'Short', 'Thin'];
    final sizeIds = <int>[];
    for (final n in sizeNames) {
      sizeIds.addAll(_cat(n)?.lessonIds ?? []);
    }

    return {
      'Puzzle': 0,
      'Drawing-Lines': _ratio(_cat('Draw Line')?.lessonIds ?? [], completed),
      'Shapes': _ratio(_cat('Shapes')?.lessonIds ?? [], completed),
      'Sizes': _ratio(sizeIds, completed),
      'Colors': _ratio(_cat('Colors')?.lessonIds ?? [], completed),
    };
  }

  static Map<String, double> _level3(Set<int> completed) {
    return {
      'Letters': _ratio(_cat('Letters')?.lessonIds ?? [], completed),
      'Numbers': _ratio(_cat('Numbers')?.lessonIds ?? [], completed),
      'Vegetables': _ratio(_cat('Vegetables')?.lessonIds ?? [], completed),
      'Fruits': _ratio(_cat('Fruits')?.lessonIds ?? [], completed),
      'Animals': _ratio(_cat('Animals')?.lessonIds ?? [], completed),
      'Family': _ratio(_cat('Family')?.lessonIds ?? [], completed),
    };
  }

}
