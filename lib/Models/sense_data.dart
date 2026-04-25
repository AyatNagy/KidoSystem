class SenseData {
  final String title;
  final String audio;
  final String featureImage;
  final String faceWithoutFeature;
  final double topFactor;
  final double leftFactor;
  final double widthFactor; // الحجم المناسب لكل حاسة

  const SenseData({
    required this.title,
    required this.audio,
    required this.featureImage,
    required this.faceWithoutFeature,
    required this.topFactor,
    required this.leftFactor,
    required this.widthFactor,
  });
}
