import 'package:kido/Models/exams/chioce_question.dart';
import '../../data/exam/choice_question_data.dart';

class Exam {
  final String id;
  final String title;
  final List<ChoiceQuestion> questions;

  Exam({
    required this.id,
    required this.title,
    required List<ChoiceQuestion> allQuestions,
  }) : questions =
           allQuestions.where((q) {
             return q.examId?.contains(id) ?? false;
           }).toList();
}

final exams = [
  Exam(id: 'exam2', title: '6 year Exam', allQuestions: allChoiceQuestions),
  Exam(id: 'exam1', title: '3 year Exam', allQuestions: allChoiceQuestions),
];
