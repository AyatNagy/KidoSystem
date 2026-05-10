import '../../enum/question_type.dart';

class ExamQuestion {
  final QuestionType type;
  final dynamic data;

  ExamQuestion({required this.type, required this.data});
}