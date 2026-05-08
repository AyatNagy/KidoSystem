class SenseData {
  final String title;
  final String audio;
  final String questionAudio;
  final String featureImage;
  final String faceWithoutFeature;
  final double topFactor;
  final double leftFactor;
  final double widthFactor;

  const SenseData({
    required this.title,
    required this.audio,
    required this.questionAudio,
    required this.featureImage,
    required this.faceWithoutFeature,
    required this.topFactor,
    required this.leftFactor,
    required this.widthFactor,
  });
}
