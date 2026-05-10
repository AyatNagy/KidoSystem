import 'package:kido/Models/dragable_item.dart';
import 'package:kido/Models/targets_item.dart';
import 'package:kido/Models/exams/question_model.dart';

class DragDropQuestion extends Question {
  final String? backgroundImage;
  final String? extraImage;
  final List<DragItem> items;
  final List<DragTargetZone> targets;

  DragDropQuestion({
    super.examId,
    required super.questionAudio,
    this.backgroundImage,
    this.extraImage,
    required this.items,
    required this.targets,
  });
}