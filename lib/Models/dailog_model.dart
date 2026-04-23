class DailogModel {
  final String title;
  final String message;
  final String image;
  final String? buttonText;

  DailogModel({
    required this.title,
    required this.message,
    required this.image,
    this.buttonText,
  });
}
