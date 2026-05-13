import 'package:kido/data/exam/speak_question_data.dart';
import 'package:kido/data/exam/trace_question.dart';
import '../../Models/exams/exam_model.dart';
import '../../enum/question_type.dart';
import 'choice_question_data.dart';
import 'draganddrop_question_data.dart';
import 'draw_question_data.dart';

class ExamProvider {
  static List<ExamQuestion> loadQuestions(String examId) {
    return [
      ...allChoiceQuestions.where((q) => q.examId!.contains(examId))
          .map((q) => ExamQuestion(type: QuestionType.choice, data: q)),
      ...allDrawingQuestions.where((q) => q.examId!.contains(examId))
          .map((q) => ExamQuestion(type: QuestionType.drawing, data: q)),
      ...allDragDropQuestions.where((q) => q.examId!.contains(examId))
          .map((q) => ExamQuestion(type: QuestionType.dragDrop, data: q)),
      ...allSpaekQuestions.where((q) => q.examId!.contains(examId))
          .map((q) => ExamQuestion(type: QuestionType.speak, data: q)),
      ...allTraceQuestions.where((q) => q.examId!.contains(examId))
          .map((q) => ExamQuestion(type: QuestionType.trace, data: q)),
    ];
  }
}