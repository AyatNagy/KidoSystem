import 'package:kido/Models/level1/matching_model.dart';

class MatchingRepository {
  static List<MatchingLessonData> levels = [
    MatchingLessonData(
      id: "1",
      targetGif: "assets/images/matching/ball.gif",
      questionAudio: "audio/find_match.mp3",
      correctImage: "assets/images/matching/ball.png",
      wrongImage: "assets/images/matching/car.png",
      backgroundImage: "assets/images/matching/bg-ball.png",
    ),
    MatchingLessonData(
      id: "2",
      targetGif: "assets/images/matching/sun.gif",
      questionAudio: "audio/find_match.mp3",
      correctImage: "assets/images/matching/sun.png",
      wrongImage: "assets/images/matching/ball.png",
      backgroundImage: "assets/images/matching/bg-ball.png",
    ),
  ];
}
