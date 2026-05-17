import 'package:flutter/material.dart';
import '../../Models/exams/chioce_question.dart';

final List<ChoiceQuestion> allChoiceQuestions = [
  ChoiceQuestion(
    examId: ['exam2'],
    questionAudio: "exams/where_girl.mp3",
    choices: ["assets/images/boy.png", "assets/images/girl.png"],
    correctIndex: 1,
  ),

  ChoiceQuestion(
    examId: ['exam2'],
    questionAudio: "exams/where_heavy.mp3",
    choices: ["assets/images/elephant.png", "assets/images/feather.png"],
    correctIndex: 0,
  ),

  ChoiceQuestion(
    examId: ['exam1', 'exam2'],
    questionAudio: "sizes/where_big.mp3",
    choices: ["assets/images/whale.png", "assets/images/small.png"],
    correctIndex: 0,
  ),

  ChoiceQuestion(
    examId: ['exam1'],
    questionAudio: "exams/where_animal_book.mp3",
    choices: ["assets/images/animals-book.png", "assets/images/cars-book.png"],
    correctIndex: 0,
  ),

  ChoiceQuestion(
    examId: ['exam1', 'post_level1'],
    questionAudio: "exams/who_sad.mp3",
    choices: ["assets/images/sad.png", "assets/images/happy.png"],
    correctIndex: 0,
  ),

  ChoiceQuestion(
    examId: ['exam2'],
    questionAudio: "exams/color_sun.mp3",
    colorImage: "assets/images/gray-sun.png",
    colors: [Colors.red, Colors.blue, Colors.yellow, Colors.green],
    correctIndex: 2,
  ),

  ChoiceQuestion(
    examId: ['exam1'],
    questionAudio: "exams/where_dog.mp3",
    choices: ["assets/images/elephant2.png", "assets/images/dog2.png"],
    correctIndex: 1,
    sound: "assets/audio/dog.mp3",
  ),

  ChoiceQuestion(
    examId: ["post_level1"],
    questionAudio: "senses/where_is_mouth.mp3",
    choices: ["assets/images/senses/nose.png", "assets/images/senses/mouth.png"],
    correctIndex: 1,
  ),

  ChoiceQuestion(
    examId: ["post_level2"],
    questionAudio: "sizes/where_tall.mp3",
    choices: ["assets/images/tree.png", "assets/images/vegi.png"],
    correctIndex: 0,
  ),

  ChoiceQuestion(
    examId: ["post_level2"],
    questionAudio: "shapes/where_triangle.mp3",
    choices: [
      "assets/images/shapes/circle.png",
      "assets/images/drawing/triangle.gif",
    ],
    correctIndex: 1,
  ),

  ChoiceQuestion(
    examId: ["post_level2"],
    questionAudio: "sizes/where_big.mp3",
    choices: ["assets/images/sizes/bus.png", "assets/images/kido-car.png"],
    correctIndex: 0,
  ),

  ChoiceQuestion(
    examId: ["post_level3"],
    questionAudio: "exams/find_num4.mp3",
    choices: [
      "assets/images/arabicNumbers/num1.png",
      "assets/images/arabicNumbers/num4.png",
    ],
    correctIndex: 1,
  ),
  ChoiceQuestion(
    examId: ["post_level3"],
    questionAudio: "exams/find_bellPepper.mp3",
    choices: [
      "assets/images/cartoonVegetable/potato.png",
      "assets/images/cartoonVegetable/bell_pepper.png",
    ],
    correctIndex: 1,
  ),
  ChoiceQuestion(
    examId: ["post_level3"],
    questionAudio: "exams/find_two.mp3",
    choices: [
      "assets/images/englishNumbers/num2.png",
      "assets/images/englishNumbers/num5.png",
    ],
    correctIndex: 0,
  ),
  ChoiceQuestion(
    examId: ["post_level3"],
    questionAudio: "exams/where_dog.mp3",
    choices: [
      "assets/images/animals/rabbit.png",
      "assets/images/animals/dog.png",
    ],
    correctIndex: 1,
  ),
];
