import 'package:flutter/material.dart';

class LearningItem {
  final String id;
  final String title; // "Circle" / "1"
  final String imagePath;
  final String audioPath;
  final Color primaryColor;

  final String? characterImagePath;

  const LearningItem({
    required this.id,
    required this.title,
    required this.imagePath,
    required this.audioPath,
    this.primaryColor = const Color.fromARGB(255, 2, 56, 122),
    this.characterImagePath,
  });
}
