class ChoiceQuestion {
  final String examId; // الامتحان اللي السؤال تابع له
  final String questionText;
  final List<String> choices; // مسار الصور لكل اختيار
  final int correctIndex; // index الاختيار الصحيح

  ChoiceQuestion({
    required this.examId,
    required this.questionText,
    required this.choices,
    required this.correctIndex,
  });
}

final List<ChoiceQuestion> allChoiceQuestions = [
  // امتحان 1
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
      "assets/images/duck.png",
    ],
    correctIndex: 0,
  ),

  ChoiceQuestion(
    examId: 'exam1',
    questionText: "Which one is big ?",
    choices: [
      "assets/images/whale.png",
      "assets/images/small.png",
      "assets/images/duck.png",
      "assets/images/duck.png",
    ],
    correctIndex: 0,
  ),

  // امتحان 2
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
