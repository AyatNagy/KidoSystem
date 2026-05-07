import 'package:kido/Models/exams/draganddrop_question.dart';
import 'package:kido/services/asset_service.dart';

enum TrainMode{presenting,testing,finished}

class TrainQuestion{
  final DragDropQuestion question;
  final int phase;
  final TrainLessonLanguage language;
  final int gapIndex;
  final double stopPosition;
  const TrainQuestion({
    required this.question,
    required this.phase,
    required this.language,
    required this.gapIndex,
    required this.stopPosition,
});

int carNumberFromPath(String acceptedItemId){
  final item=question.items.firstWhere((i)=>i.id==acceptedItemId);
  return int.tryParse(item.image.split('_').last.replaceAll('.png',''),)??1;
}
}