import 'question_item.dart';

class ItemPlacement {
  final QuestionItem item;
  final String? groupId;

  const ItemPlacement({required this.item, this.groupId});

  bool get isPlaced => groupId != null;
  bool get isCorrect => groupId == item.correctGroupId;

  ItemPlacement copyWith({String? groupId}) {
    return ItemPlacement(item: item, groupId: groupId);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemPlacement &&
          runtimeType == other.runtimeType &&
          item.id == other.item.id &&
          groupId == other.groupId;

  @override
  int get hashCode => item.id.hashCode ^ groupId.hashCode;
}
