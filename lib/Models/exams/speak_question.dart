import 'package:kido/Models/exams/question_model.dart';

class SpeakQuestion extends Question {
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
    examId: ['exam1'],
    questionText: "اسم الشكل",
    image: "assets/images/circle-shape.png",
    acceptedAnswers: ["دايره", "دايرة", "دائرة"],
  ),

  SpeakQuestion(
    examId: ['exam2'],
    questionText: "اسم الحيوان",
    image: "assets/images/cat2.png",
    acceptedAnswers: ["قطة", "قطه", "قط"],
  ),
];
