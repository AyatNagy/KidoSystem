class MatchingLessonData {
  final String id;
  final String targetGif;
  final String questionAudio;
  final String correctImage;
  final String wrongImage;
  final String? backgroundImage;

  MatchingLessonData({
    required this.id,
    required this.targetGif,
    required this.questionAudio,
    required this.correctImage,
    required this.wrongImage,
    this.backgroundImage,
  });
}
