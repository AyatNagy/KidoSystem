import 'package:kido/Models/questionModel.dart';

class ChoiceQuestion extends Question{
  final List<String> choices;
  final int correctIndex;

  ChoiceQuestion({
    required super.examId,
    required super.questionText,
    required this.choices,
    required this.correctIndex,
  });
}

final List<ChoiceQuestion> allChoiceQuestions = [
  ChoiceQuestion(
    examId: 'exam1',
    questionText: "which one is a girl ?",
    choices: ["assets/images/boy.png", "assets/images/girl.png"],
    correctIndex: 1,
  ),
  ChoiceQuestion(
    examId: 'exam1',
    questionText: "Which one is Heavy ?",
    choices: [
      "assets/images/elephant.png",
      "assets/images/feather.png",
    ],
    correctIndex: 0,
  ),

  ChoiceQuestion(
    examId: 'exam1',
    questionText: "Which one is big ?",
    choices: [
      "assets/images/whale.png",
      "assets/images/small.png",
    ],
    correctIndex: 0,
  ),

  ChoiceQuestion(
    examId: 'exam2',
    questionText: "Where is the dog ?",
    choices: [
      "assets/images/elephant.png",
      "assets/images/god.png",
      "assets/images/duck.png",
      "assets/images/duck.png",
    ],
    correctIndex: 0,
  ),
];
