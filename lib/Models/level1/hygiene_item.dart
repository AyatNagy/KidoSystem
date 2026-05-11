class HygieneItem {
  final String image;
  final String title;
  bool isLocked;

  HygieneItem({
    required this.image,
    required this.title,
    this.isLocked = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is HygieneItem &&
              runtimeType == other.runtimeType &&
              title == other.title;

  @override
  int get hashCode => title.hashCode;
}