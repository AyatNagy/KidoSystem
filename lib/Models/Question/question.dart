import 'question_item.dart';
import 'question_group.dart';

/// Model للسؤال الكامل
class Question {
  final String id;
  final String title;
  final List<QuestionGroup> groups;
  final List<QuestionItem> items;

  const Question({
    required this.id,
    required this.title,
    required this.groups,
    required this.items,
  });

  bool get isValid {
    if (groups.isEmpty || items.isEmpty) return false;
    final groupIds = groups.map((g) => g.id).toSet();
    return items.every((item) => groupIds.contains(item.correctGroupId));
  }
}

