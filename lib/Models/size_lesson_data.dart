import 'package:kido/enum/size_goal.dart';

class SizeLessonData {
  final String title;
  final String audio;
  final String questionAudio;
  //final String correctAudio;
  final String correctImage;
  final String secondImage;

  SizeLessonData({
    required this.title,
    required this.audio,
    required this.questionAudio,
    //required this.correctAudio,
    required this.correctImage,
    required this.secondImage,
  });
}

class SizeLessonMapper {
  static SizeLessonData get(SizeGoal goal) {
    switch (goal) {
      case SizeGoal.tall:
        return SizeLessonData(
          title: "طويل",
          audio: "sizes/tall.mp3",
          questionAudio: "sizes/where_tall.mp3",
          //correctAudio: "sizes/tall_correct.mp3",
          correctImage: "assets/images/sizes/tall.png",
          secondImage: "assets/images/sizes/short.png",
        );

      case SizeGoal.short:
        return SizeLessonData(
          title: "قصير",
          audio: "sizes/short.mp3",
          questionAudio: "sizes/where_short.mp3",
          //correctAudio: "sizes/short_correct.mp3",
          correctImage: "assets/images/sizes/short.png",
          secondImage: "assets/images/sizes/tall.png",
        );

      case SizeGoal.fat:
        return SizeLessonData(
          title: "تخين",
          audio: "sizes/fat.mp3",
          questionAudio: "sizes/where_fat.mp3",
          //correctAudio: "sizes/fat_correct.mp3",
          correctImage: "assets/images/sizes/fat.png",
          secondImage: "assets/images/sizes/thin.png",
        );
      case SizeGoal.thin:
        return SizeLessonData(
          title: "رفيع",
          audio: "sizes/thin.mp3",
          questionAudio: "sizes/where_thin.mp3",
          //correctAudio: "sizes/thin_correct.mp3",
          correctImage: "assets/images/sizes/thin.png",
          secondImage: "assets/images/sizes/fat.png",
        );

      case SizeGoal.big:
        return SizeLessonData(
          title: "كبير",
          audio: "sizes/big.mp3",
          questionAudio: "sizes/where_big.mp3",
          //correctAudio: "sizes/big_correct.mp3",
          correctImage: "assets/images/sizes/big.png",
          secondImage: "assets/images/sizes/small.png",
        );

      case SizeGoal.small:
        return SizeLessonData(
          title: "صغير",
          audio: "sizes/small.mp3",
          questionAudio: "sizes/where_small.mp3",
          //correctAudio: "sizes/small_correctmp3",
          correctImage: "assets/images/sizes/small.png",
          secondImage: "assets/images/sizes/big.png",
        );
    }
  }
}
