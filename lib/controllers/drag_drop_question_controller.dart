import 'package:flutter/foundation.dart';
import '../Models/Question/question.dart';
import '../Models/Question/question_item.dart';
import '../Models/Question/item_placement.dart';
import '../Models/Question/question_result.dart';

class DragDropQuestionController extends ChangeNotifier {
  final Question question;
  late List<ItemPlacement> _placements;


  DragDropQuestionController({required this.question}) {
    _placements = question.items.map((e) => ItemPlacement(item: e)).toList();
  }

  List<QuestionItem> get availableItems =>
      _placements.where((p) => !p.isPlaced).map((p) => p.item).toList();

  List<QuestionItem> getItemsInGroup(String groupId) =>
      _placements
          .where((p) => p.groupId == groupId)
          .map((p) => p.item)
          .toList();

  bool get areAllItemsPlaced =>
      _placements.every((placement) => placement.isPlaced);

  void moveItemToGroup(String itemId, String groupId) {
    final index = _placements.indexWhere((p) => p.item.id == itemId);
    if (index != -1) {
      _placements[index] = _placements[index].copyWith(groupId: groupId);
      notifyListeners();
    }
  }

  void removeItemFromGroup(String itemId) {
    final index = _placements.indexWhere((p) => p.item.id == itemId);
    if (index != -1) {
      _placements[index] = _placements[index].copyWith(groupId: null);
      notifyListeners();
    }
  }

  QuestionResult calculateResult() {
    int correctCount = _placements.where((p) => p.isCorrect).toList().length;
    return QuestionResult(
      questionId: question.id,
      correctCount: correctCount,
      totalCount: _placements.length,
      answers: {for (var p in _placements) p.item.id: p.groupId ?? ''},
    );
  }
}
