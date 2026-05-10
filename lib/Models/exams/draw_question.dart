import 'package:kido/Models/exams/question_model.dart';

class DrawingQuestion extends Question {
  final String targetShape;
  final String image;

  DrawingQuestion({
    required super.examId,
    required super.questionAudio,
    required this.targetShape,
    required this.image,
  });
}
