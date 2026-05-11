import 'dart:ui';
import '../../../Models/dragable_item.dart';
import '../../../Models/exams/draganddrop_question.dart';
import '../../../Models/targets_item.dart';

final DragDropQuestion trashQuestionData = DragDropQuestion(
  examId: ['clean_mission'],
  questionAudio: "ارمي القمامة في السلة",
  backgroundImage: 'assets/images/clean/Trash/TrashBackground.png',
  targets: [
    DragTargetZone(
      id: 'bin',
      image: 'assets/images/clean/Trash/closedBasket.png',
      position: const Offset(0.35, 0.65),
      size: const Size(0.3, 0.3),
      acceptedItemIds: ['banana', 'bottle', 'paper'],
    ),
  ],
  items: [
    DragItem(
      id: 'banana',
      image: 'assets/images/clean/Trash/قشرة_موزة.png',
      startPosition: const Offset(0.1, 0.4),
      size: const Size(0.15, 0.1),
    ),
    DragItem(
      id: 'bottle',
      image: 'assets/images/clean/Trash/زجاجة_بلاستيك.png',
      startPosition: const Offset(0.7, 0.5),
      size: const Size(0.1, 0.18),
    ),
    DragItem(
      id: 'paper',
      image: 'assets/images/clean/Trash/ورقة_مجعدة.png',
      startPosition: const Offset(0.4, 0.3),
      size: const Size(0.12, 0.12),
    ),
  ],
);