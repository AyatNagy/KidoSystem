import'package:flutter/material.dart';
class NumberLessonData{

  final int number;
  final String numberImagePath;
  final String audioPath;
  final String? characterImagePath;
  final Color primaryColor;

  const NumberLessonData({
    required this.number,
    required this.numberImagePath,
    required this.audioPath,
    this.characterImagePath,
    this.primaryColor= const Color(0xFF6A4BB1),

  });

}