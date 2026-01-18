import 'package:flutter/material.dart';
import 'package:kido/Models/questionModel.dart';

class ChoiceQuestion extends Question {
  final List<String>? choices;
  final List<Color>? colors;
  final int correctIndex;
  final String? colorImage;
  final String? sound;

  ChoiceQuestion({
    required super.examId,
    required super.questionText,
    this.choices,
    this.colors,
    required this.correctIndex,
    this.colorImage,
    this.sound
  });
}

final List<ChoiceQuestion> allChoiceQuestions = [
  ChoiceQuestion(
    examId: ['exam1'],
    questionText: "اختار البنت",
    choices: ["assets/images/boy.png", "assets/images/girl.png"],
    correctIndex: 1,
  ),

  ChoiceQuestion(
    examId: ['exam1'],
    questionText: "اختار الحاجة التقيلة",
    choices: ["assets/images/elephant.png", "assets/images/feather.png"],
    correctIndex: 0,
  ),

  ChoiceQuestion(
    examId: ['exam1', 'exam2'],
    questionText: " مين الكبير",
    choices: ["assets/images/whale.png", "assets/images/small.png"],
    correctIndex: 0,
  ),

  ChoiceQuestion(
    examId: ['exam2'],
    questionText: "كتاب العربيات فين",
    choices: ["assets/images/animals-book.png", "assets/images/cars-book.png"],
    correctIndex: 1,
  ),

  ChoiceQuestion(
    examId: ['exam2'],
    questionText: "مين حزين",
    choices: ["assets/images/sad.png", "assets/images/happy.png"],
    correctIndex: 0,
  ),

  ChoiceQuestion(
    examId: ['exam1'],
    questionText:" لون الشمس",
    colorImage: "assets/images/gray-sun.png",
    colors: [Colors.red, Colors.blue, Colors.yellow, Colors.green],
    correctIndex: 2,
  ),

  ChoiceQuestion(
      examId: ['exam2'],
      questionText: "صوت مين ده",
      choices: [
        "assets/images/elephant2.png",
        "assets/images/dog2.png"
      ],
      correctIndex: 1,
      sound: "assets/audio/dog.mp3"
  )
];
