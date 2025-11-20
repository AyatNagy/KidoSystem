class QuestionItem {
  final String id;
  final String imagePath;
  final String correctGroupId;
  final double size; // الحجم الخاص بكل عنصر

  const QuestionItem({
    required this.id,
    required this.imagePath,
    required this.correctGroupId,
    this.size = 80.0,
  });

  QuestionItem copyWith({double? size}) {
    return QuestionItem(
      id: id,
      imagePath: imagePath,
      correctGroupId: correctGroupId,
      size: size ?? this.size,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestionItem &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
