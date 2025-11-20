import 'package:flutter/material.dart';

class QuestionGroup {
  final String id;
  final String title;
  final Color color;
  final String imagePath;
  final double width; // حجم البوكس
  final double height; // حجم البوكس

  const QuestionGroup({
    required this.id,
    required this.title,
    required this.color,
    required this.imagePath,
    this.width = 150,
    this.height = 200,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestionGroup &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
