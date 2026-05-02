import 'package:flutter/material.dart';

class TracingQuestion {
  final String id;
  final String label;

  final String audioPath;
  final String characterImage;

  final String backgroundImage1;
  final String backgroundImage2;
  final String backgroundImage3;
  final String backgroundImage4;

  final String? backgroundImage5;
  final String? backgroundImage6;
  final String? backgroundImage7;
  final String? backgroundImage8;
  final String? backgroundImage9;
  final String? backgroundImage10;

  final Offset startPosition;
  final Offset midTarget;
  final Offset endTarget;

  final List<Offset> pathPoints;

  const TracingQuestion({
    required this.id,
    required this.label,
    required this.audioPath,
    required this.characterImage,
    required this.backgroundImage1,
    required this.backgroundImage2,
    required this.backgroundImage3,
    required this.backgroundImage4,
    this.backgroundImage5,
    this.backgroundImage6,
    this.backgroundImage7,
    this.backgroundImage8,
    this.backgroundImage9,
    this.backgroundImage10,
    required this.startPosition,
    required this.midTarget,
    required this.endTarget,
    required this.pathPoints,
  });
}
