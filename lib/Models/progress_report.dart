/// Parsed body from `GET /progress/my` (child) or parent proxy with same shape.
class ProgressReport {
  final int totalLessons;
  final int completedLessons;
  final int completionPercentage;

  /// Level name → category name → list of lesson rows
  final Map<String, Map<String, List<LessonProgressRow>>> grouped;

  ProgressReport({
    required this.totalLessons,
    required this.completedLessons,
    required this.completionPercentage,
    required this.grouped,
  });

  factory ProgressReport.fromApiJson(Map<String, dynamic> json) {
    final summary = json['summary'];
    int total = 0;
    int done = 0;
    int pct = 0;
    if (summary is Map) {
      total = (summary['totalLessons'] as num?)?.toInt() ?? 0;
      done = (summary['completedLessons'] as num?)?.toInt() ?? 0;
      pct = (summary['completionPercentage'] as num?)?.toInt() ?? 0;
    }

    final raw = json['data'];
    final grouped = <String, Map<String, List<LessonProgressRow>>>{};
    if (raw is Map) {
      raw.forEach((levelName, categories) {
        if (categories is! Map) return;
        final catMap = <String, List<LessonProgressRow>>{};
        categories.forEach((catName, lessons) {
          if (lessons is! List) return;
          catMap[catName.toString()] =
              lessons.map((e) {
                if (e is! Map) {
                  return LessonProgressRow(
                    lessonId: 0,
                    lessonTitle: '',
                    isCompleted: false,
                  );
                }
                final m = Map<String, dynamic>.from(e);
                return LessonProgressRow(
                  lessonId: (m['lessonId'] as num?)?.toInt() ?? 0,
                  lessonTitle: m['lessonTitle']?.toString() ?? '',
                  isCompleted: m['isCompleted'] == true,
                );
              }).toList();
        });
        grouped[levelName.toString()] = catMap;
      });
    }

    return ProgressReport(
      totalLessons: total,
      completedLessons: done,
      completionPercentage: pct,
      grouped: grouped,
    );
  }
}

class LessonProgressRow {
  final int lessonId;
  final String lessonTitle;
  final bool isCompleted;

  LessonProgressRow({
    required this.lessonId,
    required this.lessonTitle,
    required this.isCompleted,
  });
}
