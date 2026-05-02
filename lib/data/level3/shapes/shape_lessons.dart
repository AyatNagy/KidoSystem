import 'package:flutter/material.dart';
import 'package:kido/Models/level3/numbers/learning_item.dart';

class ShapesLessonRepo {
  static const List<LearningItem> shapes = [
    LearningItem(
      id: "circle",
      title: "Circle",
      imagePath: 'assets/images/shapes/circle.png',
      audioPath: 'audio/shapes/circle.mp3',
      primaryColor: Colors.orange,
    ),
    LearningItem(
      id: "square",
      title: "Square",
      imagePath: 'assets/images/shapes/square.png',
      audioPath: 'audio/shapes/square.mp3',
      primaryColor: Colors.blue,
    ),
  ];
}
