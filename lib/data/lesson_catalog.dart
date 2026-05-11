/// Mirrors DB seed: categories + lesson ids (must stay in sync with Prisma seed).
class CategorySeed {
  final int id;
  final String name;
  final int levelNumber;
  final List<int> lessonIds;

  const CategorySeed({
    required this.id,
    required this.name,
    required this.levelNumber,
    required this.lessonIds,
  });

  int get totalLessons => lessonIds.length;
}

/// Static catalog for progress denominators & linking Flutter screens → [lessonId].
class LessonCatalog {
  LessonCatalog._();

  static const List<CategorySeed> categories = [
    CategorySeed(id: 1, name: 'Counting', levelNumber: 1, lessonIds: [1, 2, 3, 4]),
    CategorySeed(id: 2, name: 'Sorting', levelNumber: 1, lessonIds: [5, 6]),
    CategorySeed(id: 3, name: 'Pegboard', levelNumber: 1, lessonIds: [7, 8, 9, 10]),
    CategorySeed(id: 4, name: 'Senses', levelNumber: 1, lessonIds: [11]),
    CategorySeed(id: 5, name: 'Matching', levelNumber: 1, lessonIds: [12]),
    CategorySeed(id: 6, name: 'Drawing', levelNumber: 1, lessonIds: [13]),
    CategorySeed(id: 7, name: 'Self Care', levelNumber: 1, lessonIds: [14]),
    CategorySeed(id: 8, name: 'Feelings', levelNumber: 1, lessonIds: [15]),
    CategorySeed(
      id: 9,
      name: 'Draw Line',
      levelNumber: 2,
      lessonIds: [16, 17, 18, 19, 20],
    ),
    CategorySeed(id: 10, name: 'Big', levelNumber: 2, lessonIds: [21]),
    CategorySeed(id: 11, name: 'Small', levelNumber: 2, lessonIds: [22]),
    CategorySeed(id: 12, name: 'Tall', levelNumber: 2, lessonIds: [23]),
    CategorySeed(id: 13, name: 'Short', levelNumber: 2, lessonIds: [24]),
    CategorySeed(id: 14, name: 'Thin', levelNumber: 2, lessonIds: [25]),
    CategorySeed(id: 15, name: 'Shapes', levelNumber: 2, lessonIds: [26]),
    CategorySeed(
      id: 16,
      name: 'Letters',
      levelNumber: 3,
      lessonIds: [
        27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45,
        46,
      ],
    ),
    CategorySeed(
      id: 17,
      name: 'Numbers',
      levelNumber: 3,
      lessonIds: [47, 48, 49, 50, 51, 52, 53, 54, 55, 56],
    ),
    CategorySeed(id: 18, name: 'Colors', levelNumber: 3, lessonIds: []),
    CategorySeed(id: 19, name: 'Fruits', levelNumber: 3, lessonIds: [57]),
    CategorySeed(id: 20, name: 'Vegetables', levelNumber: 3, lessonIds: [58]),
    CategorySeed(id: 21, name: 'Family', levelNumber: 3, lessonIds: [59]),
    CategorySeed(
      id: 22,
      name: 'Animals',
      levelNumber: 3,
      lessonIds: [60, 61, 62, 63, 64, 65],
    ),
  ];

  /// Total lesson slots for all categories whose level ≤ [allowedLevel] (matches allowedLevel gate on server).
  static int totalLessonsUpToLevel(int allowedLevel) {
    final level = allowedLevel.clamp(1, 3);
    return categories
        .where((c) => c.levelNumber <= level)
        .fold<int>(0, (sum, c) => sum + c.totalLessons);
  }

  static CategorySeed? categoryContainingLesson(int lessonId) {
    for (final c in categories) {
      if (c.lessonIds.contains(lessonId)) return c;
    }
    return null;
  }
}
