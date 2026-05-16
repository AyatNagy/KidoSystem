import 'dart:ui';
import 'package:kido/Models/dragable_item.dart';
import 'package:kido/Models/exams/draganddrop_question.dart';
import 'package:kido/Models/targets_item.dart';

class PuzzleData {
  final DragDropQuestion question;
  final String? fullImage;

  PuzzleData({required this.question, this.fullImage});
}

final List<PuzzleData> appleLevels = [
  PuzzleData(
    fullImage: "assets/images/puzzle/apple_full.png",
    question: DragDropQuestion(
      questionAudio: "",
      backgroundImage: "assets/images/puzzle/apple_1_missing.png",
      items: [
        DragItem(
          id: "p1",
          image: "assets/images/puzzle/apple_p1.png",
          startPosition: const Offset(0.38, 0.75),
          size: const Size(0.30, 0.30),
        ),
      ],
      targets: [
        DragTargetZone(
          id: "t1",
          acceptedItemIds: ["p1"],
          position: const Offset(0.46, 0.43),
          size: const Size(0.30, 0.30),
          image: "assets/images/puzzle/apple_p1.png",
        ),
      ],
    ),
  ),

  PuzzleData(
    fullImage: "assets/images/puzzle/apple_full.png",
    question: DragDropQuestion(
      questionAudio: "",
      backgroundImage: "assets/images/puzzle/apple_2_missing.png",
      items: [
        DragItem(
          id: "p1",
          image: "assets/images/puzzle/apple_p1.png",
          startPosition: const Offset(0.55, 0.75),
          size: const Size(0.32, 0.32),
        ),
        DragItem(
          id: "p2",
          image: "assets/images/puzzle/apple_p2.png",
          startPosition: const Offset(0.15, 0.75),
          size: const Size(0.32, 0.32),
        ),
      ],
      targets: [
        DragTargetZone(
          id: "t1",
          acceptedItemIds: ["p1"],
          position: const Offset(0.47, 0.42),
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
  ),

  PuzzleData(
    fullImage: "assets/images/puzzle/apple_full.png",
    question: DragDropQuestion(
      questionAudio: "",
      backgroundImage: "assets/images/puzzle/apple_3_missing.png",
      items: [
        DragItem(
          id: "p1",
          image: "assets/images/puzzle/apple_p1.png",
          startPosition: const Offset(0.05, 0.75),
          size: const Size(0.31, 0.31),
        ),
        DragItem(
          id: "p2",
          image: "assets/images/puzzle/apple_p2.png",
          startPosition: const Offset(0.35, 0.75),
          size: const Size(0.32, 0.32),
        ),
        DragItem(
          id: "p3",
          image: "assets/images/puzzle/apple_p3.png",
          startPosition: const Offset(0.65, 0.75),
          size: const Size(0.33, 0.33),
        ),
      ],
      targets: [
        DragTargetZone(
          id: "t1",
          acceptedItemIds: ["p1"],
          position: const Offset(0.47, 0.42),
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
          position: const Offset(0.42, 0.52),
          size: const Size(0.36, 0.36),
          image: "assets/images/puzzle/apple_p3.png",
        ),
      ],
    ),
  ),
];

final List<PuzzleData> cowLevels = [
  PuzzleData(
    fullImage: "assets/images/puzzle/cow_full.png",
    question: DragDropQuestion(
      questionAudio: "",
      backgroundImage: "assets/images/puzzle/cow_1_missing.png",
      items: [
        DragItem(
          id: "p1",
          image: "assets/images/puzzle/cow_p1.png",
          startPosition: const Offset(0.35, 0.75),
          size: const Size(0.40, 0.40),
        ),
      ],
      targets: [
        DragTargetZone(
          id: "t1",
          acceptedItemIds: ["p1"],
          position: const Offset(0.12, 0.36),
          size: const Size(0.46, 0.45),
          image: "assets/images/puzzle/cow_p1.png",
        ),
      ],
    ),
  ),

  PuzzleData(
    fullImage: "assets/images/puzzle/cow_full.png",
    question: DragDropQuestion(
      questionAudio: "",
      backgroundImage: "assets/images/puzzle/cow_2_missing.png",
      items: [
        DragItem(
          id: "p1",
          image: "assets/images/puzzle/cow_p1.png",
          startPosition: const Offset(0.65, 0.75),
          size: const Size(0.40, 0.40),
        ),
        DragItem(
          id: "p2",
          image: "assets/images/puzzle/cow_p2.png",
          startPosition: const Offset(0.30, 0.75),

          size: const Size(0.32, 0.32),
        ),
      ],
      targets: [
        DragTargetZone(
          id: "t1",
          acceptedItemIds: ["p1"],
          position: const Offset(0.11, 0.36),
          size: const Size(0.46, 0.45),
          image: "assets/images/puzzle/cow_p1.png",
        ),
        DragTargetZone(
          id: "t2",
          acceptedItemIds: ["p2"],
          position: const Offset(0.43, 0.52),
          size: const Size(0.32, 0.32),
          image: "assets/images/puzzle/cow_p2.png",
        ),
      ],
    ),
  ),

  PuzzleData(
    fullImage: "assets/images/puzzle/cow_full.png",
    question: DragDropQuestion(
      questionAudio: "",
      backgroundImage: "assets/images/puzzle/cow_3_missing.png",
      items: [
        DragItem(
          id: "p1",
          image: "assets/images/puzzle/cow_p1.png",
          startPosition: const Offset(0.35, 0.75),
          size: const Size(0.40, 0.40),
        ),
        DragItem(
          id: "p2",
          image: "assets/images/puzzle/cow_p2.png",
          startPosition: const Offset(0.55, 0.75),
          size: const Size(0.32, 0.32),
        ),
        DragItem(
          id: "p3",
          image: "assets/images/puzzle/cow_p3.png",
          startPosition: const Offset(0.55, 0.75),
          size: const Size(0.32, 0.32),
        ),
      ],
      targets: [
        DragTargetZone(
          id: "t1",
          acceptedItemIds: ["p1"],
          position: const Offset(0.11, 0.36),
          size: const Size(0.46, 0.45),
          image: "assets/images/puzzle/cow_p1.png",
        ),
        DragTargetZone(
          id: "t2",
          acceptedItemIds: ["p2"],
          position: const Offset(0.43, 0.51),
          size: const Size(0.34, 0.32),
          image: "assets/images/puzzle/cow_p2.png",
        ),
        DragTargetZone(
          id: "t3",
          acceptedItemIds: ["p3"],
          position: const Offset(0.22, 0.48),
          size: const Size(0.29, 0.30),
          image: "assets/images/puzzle/cow_p3.png",
        ),
      ],
    ),
  ),
];
final List<PuzzleData> allPuzzleLevels = [...cowLevels, ...appleLevels];
