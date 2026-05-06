import 'dart:ui';
import 'package:kido/Models/draganddrop_question.dart';
import 'package:kido/Models/dragable_item.dart';
import 'package:kido/Models/targets_item.dart';

class PuzzleData {
  final DragDropQuestion question;
  final String? fullImage;

  PuzzleData({required this.question, this.fullImage});
}

// 🟢 Level 1 (قطعة واحدة)
final puzzleLevel1 = PuzzleData(
  fullImage: "assets/images/puzzle/apple_full.png",
  question: DragDropQuestion(
    questionText: "",
    backgroundImage: "assets/images/puzzle/apple_1_missing.png",
    items: [
      DragItem(
        id: "p1",
        image: "assets/images/puzzle/apple_p1.png",
        startPosition: const Offset(0.4, 0.8),
        size: const Size(0.25, 0.2),
      ),
    ],
    targets: [
      DragTargetZone(
        id: "t1",
        acceptedItemIds: ["p1"],
        position: const Offset(0.5, 0.5),
        size: const Size(0.25, 0.2),
        image: "assets/images/puzzle/apple_p1.png",
      ),
    ],
  ),
);

// 🟡 Level2
final puzzleLevel2 = PuzzleData(
  fullImage: "assets/images/puzzle/apple_full.png",
  question: DragDropQuestion(
    questionText: "",
    backgroundImage: "assets/images/puzzle/apple_2_missing.png",
    items: [
      DragItem(
        id: "p1",
        image: "assets/images/puzzle/apple_p1.png",
        startPosition: const Offset(0.3, 0.8),
        size: const Size(0.22, 0.2),
      ),
      DragItem(
        id: "p2",
        image: "assets/images/puzzle/apple_p2.png",
        startPosition: const Offset(0.6, 0.8),
        size: const Size(0.22, 0.2),
      ),
    ],
    targets: [
      DragTargetZone(
        id: "t1",
        acceptedItemIds: ["p1"],
        position: const Offset(0.35, 0.45),
        size: const Size(0.22, 0.2),
        image: "assets/images/puzzle/apple_p1.png",
      ),
      DragTargetZone(
        id: "t2",
        acceptedItemIds: ["p2"],
        position: const Offset(0.65, 0.45),
        size: const Size(0.22, 0.2),
        image: "assets/images/puzzle/apple_p2.png",
      ),
    ],
  ),
);

// 🔴 Level 3 (5 قطع)
final puzzleLevel3 = PuzzleData(
  fullImage: "assets/images/puzzle/apple_full.png",
  question: DragDropQuestion(
    questionText: "",
    backgroundImage: "assets/images/puzzle/apple_3_missing.png",
    items: [
      DragItem(
        id: "p1",
        image: "assets/images/puzzle/apple_piece1.png",
        startPosition: const Offset(0.2, 0.8),
        size: const Size(0.2, 0.2),
      ),
      DragItem(
        id: "p2",
        image: "assets/images/puzzle/apple_piece2.png",
        startPosition: const Offset(0.5, 0.8),
        size: const Size(0.2, 0.2),
      ),
      DragItem(
        id: "p3",
        image: "assets/images/puzzle/apple_piece3.png",
        startPosition: const Offset(0.75, 0.8),
        size: const Size(0.2, 0.2),
      ),
    ],
    targets: [
      DragTargetZone(
        id: "t1",
        acceptedItemIds: ["p1"],
        position: const Offset(0.3, 0.4),
        size: const Size(0.2, 0.2),
        image: "assets/images/puzzle/apple_p1.png",
      ),
      DragTargetZone(
        id: "t2",
        acceptedItemIds: ["p2"],
        position: const Offset(0.6, 0.4),
        size: const Size(0.2, 0.2),
        image: "assets/images/puzzle/apple_p2.png",
      ),
      DragTargetZone(
        id: "t3",
        acceptedItemIds: ["p3"],
        position: const Offset(0.45, 0.65),
        size: const Size(0.2, 0.2),
        image: "assets/images/puzzle/apple_p3.png",
      ),
    ],
  ),
);
final puzzleLevels = [puzzleLevel1, puzzleLevel2, puzzleLevel3];
