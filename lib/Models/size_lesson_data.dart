import 'package:kido/enum/size_goal.dart';

class SizeLessonData {
  final String title;
  final String audio;
  final String questionAudio;
  final String correctAudio;
  final String firstImage;
  final String secondImage;

  SizeLessonData({
    required this.title,
    required this.audio,
    required this.questionAudio,
    required this.correctAudio,
    required this.firstImage,
    required this.secondImage,
  });
}

class SizeLessonMapper {
  static SizeLessonData get(SizeGoal goal) {
    switch (goal) {
      case SizeGoal.longShort:
        return SizeLessonData(
          title: "طويل",
          audio: "tall.wav",
          questionAudio: "where_tall.wav",
          correctAudio: "tall_correct.wav",
          firstImage: "assets/images/sizes/tallcandel.png",
          secondImage: "assets/images/sizes/shortcandel.png",
        );

      case SizeGoal.thickThin:
        return SizeLessonData(
          title: "سميك",
          audio: "thick.wav",
          questionAudio: "where_thick.wav",
          correctAudio: "thick_correct.wav",
          firstImage: "assets/images/sizes/thick.png",
          secondImage: "assets/images/sizes/thin.png",
        );

      case SizeGoal.bigSmall:
        return SizeLessonData(
          title: "كبير",
          audio: "big.wav",
          questionAudio: "where_big.wav",
          correctAudio: "big_correct.wav",
          firstImage: "assets/images/sizes/big.png",
          secondImage: "assets/images/sizes/small.png",
        );
    }
  }
}
