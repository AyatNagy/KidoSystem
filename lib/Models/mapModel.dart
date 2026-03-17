class Lesson {
  final String title;
  final String image;
  final bool isLocked;

  Lesson({
    required this.title,
    required this.image,
    this.isLocked = true,
  });
}