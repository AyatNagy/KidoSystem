import 'dart:ui';
import 'package:kido/Models/dragable_item.dart';
import 'package:kido/Models/targets_item.dart';
import 'package:kido/Models/questionModel.dart';

class DragDropQuestion extends Question {
  final String? backgroundImage;
  final String? extraImage;
  final List<DragItem> items;
  final List<DragTargetZone> targets;

  DragDropQuestion({
    required super.examId,
    required super.questionText,
    this.backgroundImage,
    this.extraImage,
    required this.items,
    required this.targets,
  });
}

final List<DragDropQuestion> allDragDropQuestions = [
  DragDropQuestion(
    examId: ['exam1'],
    questionText: "Put the correct food on each animal",
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
    examId: ['exam1'],
    questionText: "Room OR Kitchen?",
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
    examId: ['exam1'],
    questionText: "Tall OR Short?",
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
    examId: ['exam1'],
    questionText: "Complete The Car!",
    backgroundImage: "assets/images/targethalfcar.png",
    items: [
      DragItem(
        id: "right_half",
        image: "assets/images/halfcar.png",
        startPosition: const Offset(0.55, 0.65),
        size: const Size(0.2, 0.2),
      ),
    ],
    targets: [
      DragTargetZone(
        id: "car_target",
        acceptedItemIds: ["right_half"],
        position: const Offset(0.49, 0.43),
        size: const Size(0.15, 0.15),
        image: "",
      ),
    ],
  ),

  DragDropQuestion(
    examId: ['exam1'],
    questionText: "Complete The Duck!",
    backgroundImage: "assets/images/puzzle_duck.png",
    items: [
      DragItem(
        id: "tail",
        image: "assets/images/duck_tail.png",
        startPosition: const Offset(0.65, 0.65),
        size: const Size(0.4, 0.3),
      ),
    ],
    targets: [
      DragTargetZone(
        id: "duck_target",
        acceptedItemIds: ["tail"],
        position: const Offset(0.43, 0.43),
        size: const Size(0.4, 0.3),
        image: "",
      ),
    ],
  ),

  DragDropQuestion(
    examId: ['exam2'],
    questionText: "Find Red",
    items: [
      DragItem(
        id: "red",
        image: "assets/images/apple.png",
        startPosition: const Offset(0.36, 0.6),
        size: const Size(0.45, 0.55),
      ),
      DragItem(
        id: "yellow",
        image: "assets/images/yelow-car.png",
        startPosition: const Offset(0.062, 0.6),
        size: const Size(0.45, 0.55),
      ),
      DragItem(
        id: "blue",
        image: "assets/images/blue-duck.png",
        startPosition: const Offset(0.65, 0.6),
        size: const Size(0.4, 0.3),
      ),
    ],
    targets: [
      DragTargetZone(
        id: "red_target",
        acceptedItemIds: ["red"],
        position: const Offset(0.35, 0.05),
        size: const Size(0.5, 0.5),
        image: "assets/images/red-box.png",
      ),
    ],
  ),

  DragDropQuestion(
    examId: ['exam2'],
    questionText: "Put The Clothes In The Right Box!",
    items: [
      DragItem(
        id: "cotton",
        image: "assets/images/cotton_Tshirt.png",
        startPosition: const Offset(0.10, 0.60),
        size: const Size(0.45, 0.45),
      ),
      DragItem(
        id: "wool",
        image: "assets/images/wool-Tshirt.png",
        startPosition: const Offset(0.55, 0.65),
        size: const Size(0.45, 0.45),
      ),
    ],
    targets: [
      DragTargetZone(
        id: "cotton_target",
        acceptedItemIds: ["cotton"],
        position: const Offset(0.05, 0.05),
        size: const Size(0.45, 0.45),
        image: "assets/images/cotton.png",
      ),
      DragTargetZone(
        id: "wool_target",
        acceptedItemIds: ["wool"],
        position: const Offset(0.52, 0.05),
        size: const Size(0.45, 0.45),
        image: "assets/images/wool.png",
      ),
    ],
  ),
];
