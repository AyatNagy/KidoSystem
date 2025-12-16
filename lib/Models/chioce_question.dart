import 'package:flutter/material.dart';
import 'package:kido/Models/questionModel.dart';

class ChoiceQuestion extends Question{
  final List<String>? choices;
  final List<Color>? colors;
  final int correctIndex;
  final String? colorImage;

  ChoiceQuestion({
    required super.examId,
    required super.questionText,
    this.choices,
    this.colors,
    required this.correctIndex,
    this.colorImage,
  });
}

final List<ChoiceQuestion> allChoiceQuestions = [
  ChoiceQuestion(
    examId: ['exam1'],
    questionText: "which one is a girl ?",
    choices: [
      "assets/images/boy.png",
      "assets/images/girl.png"
    ],
    correctIndex: 1,
  ),

  ChoiceQuestion(
    examId: ['exam1'],
    questionText: "Which one is Heavy ?",
    choices: [
      "assets/images/elephant.png",
      "assets/images/feather.png",
    ],
    correctIndex: 0,
  ),

  ChoiceQuestion(
    examId: ['exam1','exam2'],
    questionText: "Which one is big ?",
    choices: [
      "assets/images/whale.png",
      "assets/images/small.png",
    ],
    correctIndex: 0,
  ),

  ChoiceQuestion(
    examId: ['exam2'],
    questionText: "Where is the dog ?",
    choices: [
      "assets/images/elephant.png",
      "assets/images/god.png",
      "assets/images/duck.png",
      "assets/images/duck.png",
    ],
    correctIndex: 0,
  ),

  ChoiceQuestion(
    examId: ['exam2'],
    questionText: "Which Book is for Cars ?",
    choices: [
      "assets/images/animals-book.png",
      "assets/images/cars-book.png",
    ],
    correctIndex: 1,
  ),

  ChoiceQuestion(
    examId: ['exam2'],
    questionText: "Which One is Sad ?",
    choices: [
      "assets/images/sad.png",
      "assets/images/happy.png",
    ],
    correctIndex: 0,
  ),

  ChoiceQuestion(
      examId: ['exam1'],
      questionText: "Color The Sun",
      colorImage: "assets/images/gray-sun.png",
      colors: [
        Colors.red,
        Colors.blue,
        Colors.yellow,
        Colors.green,
      ],
      correctIndex: 2
  )

];