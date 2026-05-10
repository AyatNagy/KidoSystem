import 'package:kido/Models/exams/question_model.dart';

class SpeakQuestion extends Question {
  final String image;
  final List<String> acceptedAnswers;

  SpeakQuestion({
    required this.image,
    required this.acceptedAnswers,
    required super.examId,
    required super.questionAudio,
  });
}
