import 'package:kido/Models/level3/numbers/learning_item.dart';

class ShapesLessonRepo {
  static const List<LearningItem> shapes = [
    LearningItem(
      id: "circle",
      title: "Circle",
      imagePath: "assets/images/shapes/circle.png",
      audioPath: "audio/shapes/circle.mp3",
    ),

    LearningItem(
      id: "square",
      title: "Square",
      imagePath: "assets/images/shapes/square.png",
      audioPath: "audio/shapes/square.mp3",
    ),

    LearningItem(
      id: "triangle",
      title: "Triangle",
      imagePath: "assets/images/shapes/triangle.png",
      audioPath: "audio/shapes/triangle.mp3",
    ),

    LearningItem(
      id: "rectangle",
      title: "Rectangle",
      imagePath: "assets/images/shapes/rectangle.png",
      audioPath: "audio/shapes/rectangle.mp3",
    ),
  ];
}
