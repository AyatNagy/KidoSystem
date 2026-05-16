/// يتطابق مع الـ response الجاي من backend:
/// {
///   "success": true,
///   "message": "...",
///   "data": { "id": 1, "childId": 5, "score": 80, "level": 1, "createdAt": "..." },
///   "levelUnlocked": true,
///   "currentAllowedLevel": 2
/// }
class AssessmentResult {
  final int? id;
  final int childId;
  final int score;
  final int level;
  final bool levelUnlocked;
  final int currentAllowedLevel;
  final String message;
  final DateTime createdAt;

  AssessmentResult({
    this.id,
    required this.childId,
    required this.score,
    required this.level,
    this.levelUnlocked = false,
    this.currentAllowedLevel = 0,
    this.message = '',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory AssessmentResult.fromJson(Map<String, dynamic> json) {
    // الـ backend بيرجع top-level fields + nested data object
    // الـ cubit بيعمل merge عليهم، فكل حاجة موجودة على top level
    return AssessmentResult(
      id: json['id'] as int?,
      childId: (json['childId'] as num?)?.toInt() ?? 0,
      score: (json['score'] as num?)?.toInt() ?? 0,
      level: (json['level'] as num?)?.toInt() ?? 0,
      levelUnlocked: json['levelUnlocked'] as bool? ?? false,
      currentAllowedLevel: (json['currentAllowedLevel'] as num?)?.toInt() ?? 0,
      message: json['message'] as String? ?? '',
      createdAt:
          json['createdAt'] != null
              ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
              : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'childId': childId,
    'score': score,
    'level': level,
    'levelUnlocked': levelUnlocked,
    'currentAllowedLevel': currentAllowedLevel,
    'message': message,
    'createdAt': createdAt.toIso8601String(),
  };
}
