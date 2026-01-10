import 'package:kido/Models/questionModel.dart';

class SpeakQuestion extends Question{
  final String image;
  final List<String> acceptedAnswers;

  SpeakQuestion({
    required this.image,
    required this.acceptedAnswers,
    required super.examId,
    required super.questionText,
  });
}

final List<SpeakQuestion> allSpaekQuestions = [
  SpeakQuestion(
    examId: ['exam1','exam2'],
    questionText: "اسم الشكل",
    image: "assets/images/circle-shape.png",
    acceptedAnswers: [
      "دايره",
      "دايرة",
      "دائرة",
    ],
  )
];
