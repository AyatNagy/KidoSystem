import 'dart:ui';
import 'package:kido/Models/dragable_item.dart';
import 'package:kido/Models/targets_item.dart';

class DragDropQuestion {
  final String examId;
  final String questionText;
  final String? backgroundImage;
  final String? extraImage;
  final List<DragItem> items;
  final List<DragTargetZone> targets;

  DragDropQuestion({
    required this.examId,
    required this.questionText,
    this.backgroundImage,
    this.extraImage,
    required this.items,
    required this.targets,
  });
}

final List<DragDropQuestion> allDragDropQuestions = [
  DragDropQuestion(
    examId: 'exam1',
    questionText: "Putt the correct food on each animal",
    items: [
      DragItem(
        id: "bone",
        image: "assets/images/dogfood.png",
        startPosition: const Offset(0.35, 0.6),
        size: const Size(0.30, 0.30),
      ),
      DragItem(
        id: "cat_food",
        image: "assets/images/catfood.png",
        startPosition: const Offset(0.05, 0.6),
        size: const Size(0.30, 0.30),
      ),
      DragItem(
        id: "bird_food",
        image: "assets/images/birdfood.png",
        startPosition: const Offset(0.65, 0.6),
        size: const Size(0.30, 0.30),
      ),
    ],
    targets: [
      DragTargetZone(
        id: "dog_target",
        acceptedItemIds: ["bone"],
        position: const Offset(0.05, 0.05),
        size: const Size(0.3, 0.3),
        image: "assets/images/dog.png",
      ),
      DragTargetZone(
        id: "cat_target",
        acceptedItemIds: ["cat_food"],
        position: const Offset(0.35, 0.05),
        size: const Size(0.3, 0.3),
        image: "assets/images/cat.png",
      ),
      DragTargetZone(
        id: "bird_target",
        acceptedItemIds: ["bird_food"],
        position: const Offset(0.65, 0.05),
        size: const Size(0.3, 0.3),
        image: "assets/images/bird.png",
      ),
    ],
  ),

  DragDropQuestion(
    examId: 'exam1',
    questionText: "Put the correct food on each animal",
    items: [
      DragItem(
        id: "bed",
        image: "assets/images/bed.png",
        startPosition: const Offset(0.05, 0.65),
        size: const Size(0.30, 0.30),
      ),
      DragItem(
        id: "pot",
        image: "assets/images/pot.png",
        startPosition: const Offset(0.50, 0.65),
        size: const Size(0.30, 0.30),
      ),
    ],
    targets: [
      DragTargetZone(
        id: "kitchen_target",
        acceptedItemIds: ["pot"],
        position: const Offset(0.05, 0.05),
        size: const Size(0.45, 0.55),
        image: "assets/images/kitchen.png",
      ),
      DragTargetZone(
        id: "bedroom_target",
        acceptedItemIds: ["bed"],
        position: const Offset(0.55, 0.05),
        size: const Size(0.45, 0.55),
        image: "assets/images/room.png",
      ),
    ],
  ),
  DragDropQuestion(
    examId: 'exam1',
    questionText: "Put the giraffe in the box",
    items: [
      DragItem(
        id: "tall",
        image: "assets/images/giraffe.png",
        startPosition: const Offset(0.10, 0.60),
        size: const Size(0.45, 0.45),
      ),
      DragItem(
        id: "short",
        image: "assets/images/mushroom.png",
        startPosition: const Offset(0.55, 0.65),
        size: const Size(0.45, 0.45),
      ),
    ],
    targets: [
      DragTargetZone(
        id: "tall_target",
        acceptedItemIds: ["tall"],
        position: const Offset(0.05, 0.05),
        size: const Size(0.45, 0.50),
        image: "assets/images/tallbox.png",
      ),
      DragTargetZone(
        id: "short_target",
        acceptedItemIds: ["short"],
        position: const Offset(0.52, 0.05),
        size: const Size(0.45, 0.50),
        image: "assets/images/shortbox.png",
      ),
    ],
  ),

  DragDropQuestion(
    examId: 'exam1',
    questionText: "complete the car",
    items: [
      DragItem(
        id: "wrong_car",
        image: "assets/images/wrongcar.png",
        startPosition: const Offset(0.10, 0.60),
        size: const Size(0.45, 0.45),
      ),
      DragItem(
        id: "half_car",
        image: "assets/images/halfcar.png",
        startPosition: const Offset(0.55, 0.65),
        size: const Size(0.45, 0.40),
      ),
    ],
    targets: [
      DragTargetZone(
        id: "car_target",
        acceptedItemIds: ["half_car"],
        position: const Offset(0.0, 0.05),
        size: const Size(1.0, 0.80),
        image: "assets/images/targethalfcar.png",
      ),
    ],
  ),
];
