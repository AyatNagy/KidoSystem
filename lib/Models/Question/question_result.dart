/// Model لنتيجة السؤال
class QuestionResult {
  final String questionId;
  final int correctCount;
  final int totalCount;
  final Map<String, String> answers; // itemId -> groupId

  const QuestionResult({
    required this.questionId,
    required this.correctCount,
    required this.totalCount,
    required this.answers,
  });

  double get score => totalCount > 0 ? correctCount / totalCount : 0.0;
  bool get isPerfect => correctCount == totalCount;

  @override
  String toString() {
    return 'QuestionResult(questionId: $questionId, score: $correctCount/$totalCount)';
  }
}

