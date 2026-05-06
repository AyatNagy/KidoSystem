import 'package:flutter/material.dart';

class LetterStep {
  final int number;
  final Offset startPoint;
  final Offset endPoint;
  final List<Offset> guidePoints;

  const LetterStep({
    required this.number,
    required this.startPoint,
    required this.endPoint,
    required this.guidePoints,
  });
}
