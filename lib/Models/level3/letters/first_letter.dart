import 'package:flutter/material.dart';

class LetterModel {
  final String letterPath;
  final String animalPath;
  final String audioName;
  final Color bgColor;
  final Color circleColor;
  final Color activeBorder;

  LetterModel({
    required this.letterPath,
    required this.animalPath,
    required this.audioName,
    this.bgColor = const Color(0xFFFDFCF0),
    this.circleColor = const Color(0x1A000000),
    this.activeBorder = Colors.orangeAccent,
  });
}