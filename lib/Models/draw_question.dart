import 'package:kido/Models/questionModel.dart';

class DrawingQuestion extends Question{
  final String targetShape;
  final String image;

  DrawingQuestion({
    required super.examId,
    required super.questionText,
    required this.targetShape,
    required this.image,
  });
}

final List<DrawingQuestion> allDrawingQuestions = [
  DrawingQuestion(
      examId: 'exam1',
      questionText: "Draw letter 'V'",
      targetShape: 'V-shape',
      image: "assets/images/letterV.png"
  ),
  DrawingQuestion(
      examId: 'exam2',
      questionText: "Draw a Circle",
      targetShape: 'Circle',
      image: "assets/images/circle.png"
  ),
];