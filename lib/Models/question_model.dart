import '../enum/question_type.dart';

class Question {
  final int id;
  final QuestionType type;
  final String title;
  final Map<String, dynamic> data;

  Question({
    required this.id,
    required this.type,
    required this.title,
    required this.data,
  });
}
