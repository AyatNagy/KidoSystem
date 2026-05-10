import 'package:flutter/material.dart';
import 'package:kido/Models/exams/question_model.dart';

class ChoiceQuestion extends Question {
  final List<String>? choices;
  final List<Color>? colors;
  final int correctIndex;
  final String? colorImage;
  final String? sound;

  ChoiceQuestion({
    required super.examId,
    required super.questionAudio,
    this.choices,
    this.colors,
    required this.correctIndex,
    this.colorImage,
    this.sound,
  });
}
