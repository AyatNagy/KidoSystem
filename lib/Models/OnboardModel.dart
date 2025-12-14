import 'dart:ui';

class OnboardModel {
  final String image;
  final String title;
  final String desc;
  final Color color;
  final List<Color> gradientColors;

  OnboardModel({
    required this.image,
    required this.title,
    required this.desc,
    required this.color,
    required this.gradientColors
  });
}
