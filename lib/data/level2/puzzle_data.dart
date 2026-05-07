import 'dart:ui';
import 'package:kido/Models/dragable_item.dart';
import 'package:kido/Models/exams/draganddrop_question.dart';
import 'package:kido/Models/targets_item.dart';

class PuzzleData {
  final DragDropQuestion question;
  final String? fullImage;

  PuzzleData({required this.question, this.fullImage});
}

// 🟢 Level 1 (قطعة واحدة في النص)
final puzzleLevel1 = PuzzleData(
  fullImage: "assets/images/puzzle/apple_full.png",
  question: DragDropQuestion(
    questionText: "",
    backgroundImage: "assets/images/puzzle/apple_1_missing.png",
    items: [
      DragItem(
        id: "p1",
        image: "assets/images/puzzle/apple_p1.png",
        startPosition: const Offset(0.38, 0.75), // تحت في النص شوية
        size: const Size(0.30, 0.30),
      ),
    ],
    targets: [
      DragTargetZone(
        id: "t1",
        acceptedItemIds: ["p1"],
        position: const Offset(0.46, 0.44),
        size: const Size(0.30, 0.30),
        image: "assets/images/puzzle/apple_p1.png",
      ),
    ],
  ),
);

// 🟡 Level 2 (قطعتين يمين وشمال)
final puzzleLevel2 = PuzzleData(
  fullImage: "assets/images/puzzle/apple_full.png",
  question: DragDropQuestion(
    questionText: "",
    backgroundImage: "assets/images/puzzle/apple_2_missing.png",
    items: [
      DragItem(
        id: "p1",
        image: "assets/images/puzzle/apple_p1.png",
        startPosition: const Offset(0.38, 0.75), // تحت في النص شوية
        size: const Size(0.31, 0.31),
      ),
      DragItem(
        id: "p2",
        image: "assets/images/puzzle/apple_p2.png",
        startPosition: const Offset(0.55, 0.75),
        size: const Size(0.32, 0.32),
      ),
    ],
    targets: [
      DragTargetZone(
        id: "t1",
        acceptedItemIds: ["p1"],
        position: const Offset(0.46, 0.42),
        size: const Size(0.31, 0.31),
        image: "assets/images/puzzle/apple_p1.png",
      ),
      DragTargetZone(
        id: "t2",
        acceptedItemIds: ["p2"],
        position: const Offset(0.20, 0.50),
        size: const Size(0.30, 0.30),
        image: "assets/images/puzzle/apple_p2.png",
      ),
    ],
  ),
);

// 🔴 Level 3 (3 قطع: اتنين فوق وواحدة تحت)
final puzzleLevel3 = PuzzleData(
  fullImage: "assets/images/puzzle/apple_full.png",
  question: DragDropQuestion(
    questionText: "",
    backgroundImage: "assets/images/puzzle/apple_3_missing.png",
    items: [
      DragItem(
        id: "p1",
        image: "assets/images/puzzle/apple_p1.png",
        startPosition: const Offset(0.38, 0.75),
        size: const Size(0.31, 0.31),
      ),
      DragItem(
        id: "p2",
        image: "assets/images/puzzle/apple_p2.png",
        startPosition: const Offset(0.55, 0.75),
        size: const Size(0.32, 0.32),
      ),
      DragItem(
        id: "p3",
        image: "assets/images/puzzle/apple_p3.png",
        startPosition: const Offset(0.65, 0.78),
        size: const Size(0.33, 0.33),
      ),
    ],
    targets: [
      DragTargetZone(
        id: "t1",
        acceptedItemIds: ["p1"],
        position: const Offset(0.46, 0.42),
        size: const Size(0.29, 0.29),
        image: "assets/images/puzzle/apple_p1.png",
      ),
      DragTargetZone(
        id: "t2",
        acceptedItemIds: ["p2"],
        position: const Offset(0.20, 0.50),
        size: const Size(0.30, 0.30),
        image: "assets/images/puzzle/apple_p2.png",
      ),
      DragTargetZone(
        id: "t3",
        acceptedItemIds: ["p3"],
        position: const Offset(0.43, 0.53), // القطعة اللي تحت في النص
        size: const Size(0.36, 0.36),
        image: "assets/images/puzzle/apple_p3.png",
      ),
    ],
  ),
);
final puzzleLevels = [puzzleLevel1, puzzleLevel2, puzzleLevel3];
