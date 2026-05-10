import 'package:flutter/material.dart';
import '../../Models/exams/chioce_question.dart';

final List<ChoiceQuestion> allChoiceQuestions = [
  ChoiceQuestion(
    examId: ['exam2'],
    questionAudio: "angry.mp3",
    choices: ["assets/images/boy.png", "assets/images/girl.png"],
    correctIndex: 1,
  ),

  ChoiceQuestion(
    examId: ['exam2'],
    questionAudio: "اختار الحاجة التقيلة",
    choices: ["assets/images/elephant.png", "assets/images/feather.png"],
    correctIndex: 0,
  ),

  ChoiceQuestion(
    examId: ['exam1', 'exam2'],
    questionAudio: " مين الكبير",
    choices: ["assets/images/whale.png", "assets/images/small.png"],
    correctIndex: 0,
  ),

  ChoiceQuestion(
    examId: ['exam1'],
    questionAudio: "كتاب العربيات فين",
    choices: ["assets/images/animals-book.png", "assets/images/cars-book.png"],
    correctIndex: 1,
  ),

  ChoiceQuestion(
    examId: ['exam1'],
    questionAudio: "مين حزين",
    choices: ["assets/images/sad.png", "assets/images/happy.png"],
    correctIndex: 0,
  ),

  ChoiceQuestion(
    examId: ['exam2'],
    questionAudio: " لون الشمس",
    colorImage: "assets/images/gray-sun.png",
    colors: [Colors.red, Colors.blue, Colors.yellow, Colors.green],
    correctIndex: 2,
  ),

  ChoiceQuestion(
    examId: ['exam1'],
    questionAudio: "صوت مين ده",
    choices: ["assets/images/elephant2.png", "assets/images/dog2.png"],
    correctIndex: 1,
    sound: "assets/audio/dog.mp3",
  ),
];