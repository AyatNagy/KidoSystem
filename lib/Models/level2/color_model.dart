class ColorTarget {
  final String id;
  final String colorNameAr;

  final String introAudio;
  final String questionAudio;

  final String colorImage;
  final String splashImage;
  final String balloonImage;
  final String bucketImage;

  final List<String> targetImages;

  final String mixingCommandAudio;

  ColorTarget({
    required this.id,
    required this.colorNameAr,
    required this.introAudio,
    required this.questionAudio,
    required this.colorImage,
    required this.splashImage,
    required this.balloonImage,
    required this.bucketImage,
    required this.targetImages,
    required this.mixingCommandAudio,
  });
}

class ColorGroup {
  final String groupName;
  final List<ColorTarget> colors;

  ColorGroup({required this.groupName, required this.colors});
}
