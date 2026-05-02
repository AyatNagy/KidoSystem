import 'package:flutter/material.dart';
import 'package:kido/Models/level3/numbers/tracing_question.dart';

final tracingCircle = TracingQuestion(
  id: "circle",
  label: "Circle",
  audioPath: "audio/shapes/circle.mp3",
  characterImage: "assets/images/bee.png",

  backgroundImage1: "assets/images/shapes/circle_bg1.png",
  backgroundImage2: "assets/images/shapes/circle_bg2.png",
  backgroundImage3: "assets/images/shapes/circle_bg3.png",
  backgroundImage4: "assets/images/shapes/circle_bg4.png",

  startPosition: const Offset(0.5, 0.1),
  midTarget: const Offset(0.9, 0.5),
  endTarget: const Offset(0.5, 0.9),

  pathPoints: const [
    Offset(0.5, 0.1),
    Offset(0.9, 0.5),
    Offset(0.5, 0.9),
    Offset(0.1, 0.5),
    Offset(0.5, 0.1),
  ],
);

final tracingSquare = TracingQuestion(
  id: "square",
  label: "Square",
  audioPath: "audio/shapes/square.mp3",
  characterImage: "assets/images/bee.png",

  backgroundImage1: "assets/images/shapes/square_bg1.png",
  backgroundImage2: "assets/images/shapes/square_bg2.png",
  backgroundImage3: "assets/images/shapes/square_bg3.png",
  backgroundImage4: "assets/images/shapes/square_bg4.png",

  startPosition: const Offset(0.2, 0.2),
  midTarget: const Offset(0.8, 0.2),
  endTarget: const Offset(0.8, 0.8),

  pathPoints: const [
    Offset(0.2, 0.2),
    Offset(0.8, 0.2),
    Offset(0.8, 0.8),
    Offset(0.2, 0.8),
    Offset(0.2, 0.2),
  ],
);
