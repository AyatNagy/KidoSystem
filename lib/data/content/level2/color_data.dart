import 'package:kido/Models/level2/color_model.dart';

final List<ColorGroup> allColorGroups = [
  ColorGroup(
    groupName: "المجموعة الأولى",
    colors: [
      ColorTarget(
        id: "red",
        colorNameAr: "أحمر",
        introAudio: "colors/red.mp3",
        questionAudio: "colors/where_red.mp3",
        colorImage: "colors/red_apple.png",
        splashImage: "colors/red.png",
        balloonImage: "colors/red_balloon.png",
        bucketImage: "colors/red_box.png",
        targetImages: [
          "colors/red_apple.png",
          "colors/red_strawberry.png",
          "colors/red_ball.png",
        ],
        mixingCommandAudio: "colors/put_red_in_its_basket.mp3",
      ),

      ColorTarget(
        id: "yellow",
        colorNameAr: "أصفر",
        introAudio: "colors/yellow.mp3",
        questionAudio: "colors/where_yellow.mp3",
        colorImage: "colors/yellow_banana.png",
        splashImage: "colors/yellow.png",
        balloonImage: "colors/yellow_balloon.png",
        bucketImage: "colors/yellow_box.png",
        targetImages: [
          "colors/yellow_banana.png",
          "colors/yellow_duck.png",
          "colors/yellow_ball.png",
        ],
        mixingCommandAudio: "colors/put_yellow_in_its_basket.mp3",
      ),
    ],
  ),
];
