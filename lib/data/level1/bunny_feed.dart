import 'dart:ui';
import '../../Models/dragable_item.dart';
import '../../Models/draganddrop_question.dart';
import '../../Models/targets_item.dart';

final DragDropQuestion bunnyQuestion = DragDropQuestion(
  questionText: 'الأرنب',
  items: [
    DragItem(
      id: 'c1',
      image: 'assets/gif/carrot.gif',
      startPosition: const Offset(0.35, 0.15),
      size: const Size(0.12, 0.15),
    ),
    DragItem(
      id: 'c2',
      image: 'assets/gif/carrot.gif',
      startPosition: const Offset(0.40, 0.1),
      size: const Size(0.12, 0.15),
    ),
    DragItem(
      id: 'c3',
      image: 'assets/gif/carrot.gif',
      startPosition: const Offset(0.55, 0.1),
      size: const Size(0.12, 0.15),
    ),
    DragItem(
      id: 'c4',
      image: 'assets/gif/carrot.gif',
      startPosition: const Offset(0.70, 0.1),
      size: const Size(0.12, 0.15),
    ),
    DragItem(
      id: 'c5',
      image: 'assets/gif/carrot.gif',
      startPosition: const Offset(0.7, 0.15),
      size: const Size(0.12, 0.15),
    ),
    DragItem(
      id: 'c6',
      image: 'assets/gif/carrot.gif',
      startPosition: const Offset(0.5, 0.15),
      size: const Size(0.12, 0.15),
    ),
  ],
  targets: [
    DragTargetZone(
      id: 't1',
      acceptedItemIds: ['c1', 'c2', 'c3', 'c4', 'c5', 'c6'],
      image: 'assets/gif/carrot.gif',
      position: const Offset(0.1, 0.3),
      size: const Size(0.8, 0.12),
    ),
    DragTargetZone(
      id: 't2',
      acceptedItemIds: ['c1', 'c2', 'c3', 'c4', 'c5', 'c6'],
      image: 'assets/gif/carrot.gif',
      position: const Offset(0.1, 0.5),
      size: const Size(0.8, 0.12),
    ),
    DragTargetZone(
      id: 't3',
      acceptedItemIds: ['c1', 'c2', 'c3', 'c4', 'c5', 'c6'],
      image: 'assets/gif/carrot.gif',
      position: const Offset(0.8, 0.3),
      size: const Size(0.8, 0.12),
    ),
    DragTargetZone(
      id: 't4',
      acceptedItemIds: ['c1', 'c2', 'c3', 'c4', 'c5', 'c6'],
      image: 'assets/gif/carrot.gif',
      position: const Offset(0.8, 0.5),
      size: const Size(0.8, 0.12),
    ),
    DragTargetZone(
      id: 't5',
      acceptedItemIds: ['c1', 'c2', 'c3', 'c4', 'c5', 'c6'],
      image: 'assets/gif/carrot.gif',
      position: const Offset(0.1, 0.7),
      size: const Size(0.8, 0.12),
    ),
    DragTargetZone(
      id: 't6',
      acceptedItemIds: ['c1', 'c2', 'c3', 'c4', 'c5', 'c6'],
      image: 'assets/gif/carrot.gif',
      position: const Offset(0.8, 0.7),
      size: const Size(0.8, 0.12),
    ),
  ],
);