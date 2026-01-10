import 'package:kido/Models/chioce_question.dart';

class Exam {
  final String id;
  final String title;
  final List<ChoiceQuestion> questions;

  Exam({
    required this.id,
    required this.title,
    required List<ChoiceQuestion> allQuestions,
  }) : questions = allQuestions.where((q) => q.examId == id).toList();
}

final exams = [
  Exam(id: 'exam1', title: '6 year Exam', allQuestions: allChoiceQuestions),
  Exam(id: 'exam2', title: '3 year Exam', allQuestions: allChoiceQuestions),
];
