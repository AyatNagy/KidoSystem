import 'dart:ui';
import '../../Models/level3/letter_step.dart';
import '../../Models/exams/draganddrop_question.dart';
import '../../../Models/dragable_item.dart';
import '../../../Models/targets_item.dart';

class StackingLessonsData {
  static final DragDropQuestion cubes = DragDropQuestion(
    questionText: 'Big to Small',
    items: [
      DragItem(
          id: "cube_large",
          image: "assets/images/level1/cube.png",
          startPosition: const Offset(0.1, 0.75),
          size: const Size(0.28, 0.20)
      ),
      DragItem(
          id: "cube_medium",
          image: "assets/images/level1/red-cube.png",
          startPosition: const Offset(0.70, 0.75),
          size: const Size(0.22, 0.16)
      ),
      DragItem(
          id: "cube_small",
          image: "assets/images/level1/yellow-cube.png",
          startPosition: const Offset(0.41, 0.78),
          size: const Size(0.16, 0.12)
      ),
    ],
    targets: [
      DragTargetZone(
          id: "bottom",
          acceptedItemIds: ["cube_large"],
          position: const Offset(0.35, 0.5),
          size: const Size(0.30, 0.20),
          image: "assets/images/level1/cube.png"
      ),
      DragTargetZone(
          id: "middle",
          acceptedItemIds: ["cube_medium"],
          position: const Offset(0.38, 0.35),
          size: const Size(0.24, 0.16),
          image: "assets/images/level1/red-cube.png"
      ),
      DragTargetZone(
          id: "top",
          acceptedItemIds: ["cube_small"],
          position: const Offset(0.41, 0.22),
          size: const Size(0.18, 0.12),
          image: "assets/images/level1/yellow-cube.png"
      ),
    ],
  );

  static List<LetterStep> getStackingSteps(double sw, double sh) {
    return [
      LetterStep(
        number: 0,
        startPoint: Offset(sw * 0.1, sh * 0.75),
        endPoint: Offset(sw * 0.35, sh * 0.5),
        guidePoints: [Offset(sw * 0.1, sh * 0.75), Offset(sw * 0.35, sh * 0.5)],
      ),
      LetterStep(
        number: 1,
        startPoint: Offset(sw * 0.7, sh * 0.75),
        endPoint: Offset(sw * 0.38, sh * 0.35),
        guidePoints: [Offset(sw * 0.7, sh * 0.75), Offset(sw * 0.38, sh * 0.35)],
      ),
      LetterStep(
        number: 2,
        startPoint: Offset(sw * 0.41, sh * 0.78),
        endPoint: Offset(sw * 0.41, sh * 0.22),
        guidePoints: [Offset(sw * 0.41, sh * 0.78), Offset(sw * 0.41, sh * 0.22)],
      ),
    ];
  }
}