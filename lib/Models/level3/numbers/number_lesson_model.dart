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
    this.primaryColor= const Color.fromARGB(255, 2, 56, 122),

  });

}