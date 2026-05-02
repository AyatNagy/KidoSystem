import 'package:flutter/material.dart';
import 'package:kido/Models/level3/numbers/tracing_question.dart';

final tracingCircle = TracingQuestion(
  id: 'circle',
  label: 'Circle',
  audioPath: 'audio/shapes/circle.mp3',
  characterImage: 'assets/images/rabbit_tracing.png',

  backgroundImage1: 'assets/images/shapes/circle_stage1.png',
  backgroundImage2: 'assets/images/shapes/circle_stage2.png',
  backgroundImage3: 'assets/images/shapes/circle_stage3.png',
  backgroundImage4: 'assets/images/shapes/circle_stage4.png',

  startPosition: const Offset(0.5, 0.2),
  midTarget: const Offset(0.8, 0.5),
  endTarget: const Offset(0.5, 0.8),

  pathPoints: [
    const Offset(0.5, 0.2),
    const Offset(0.75, 0.3),
    const Offset(0.8, 0.5),
    const Offset(0.75, 0.7),
    const Offset(0.5, 0.8),
    const Offset(0.25, 0.7),
    const Offset(0.2, 0.5),
    const Offset(0.25, 0.3),
    const Offset(0.5, 0.2),
  ],
);
