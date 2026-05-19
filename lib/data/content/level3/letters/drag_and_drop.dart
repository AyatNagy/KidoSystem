import 'dart:ui';
import '../../../../Models/dragable_item.dart';
import '../../../../Models/exams/draganddrop_question.dart';
import '../../../../Models/targets_item.dart';

final List<DragDropQuestion> arLetter = [
  DragDropQuestion(
    questionAudio: 'ألف',
    items: [
      DragItem(
        id: "ا",
        image: "assets/images/arabic_letters/vline.png",
        startPosition: const Offset(0.45, 0.7),
        size: const Size(0.2, 0.2),
      ),
      DragItem(
        id: "ء",
        image: "assets/images/arabic_letters/hamza.png",
        startPosition: const Offset(0.15, 0.75),
        size: const Size(0.2, 0.2),
      ),
    ],
    targets: [
      DragTargetZone(
        id: "partا",
        acceptedItemIds: ["ا"],
        position: const Offset(0.4, 0.3),
        size: const Size(0.3, 0.3),
        image: "assets/images/arabic_letters/vline.png",
      ),
      DragTargetZone(
        id: "partء",
        acceptedItemIds: ["ء"],
        position: const Offset(0.4, 0.15),
        size: const Size(0.2, 0.2),
        image: "assets/images/arabic_letters/hamza.png",
      ),
    ],
  ),

  DragDropQuestion(
    questionAudio: 'ب',
    items: [
      DragItem(
        id: "ب",
        image: "assets/images/arabic_letters/upperب.png",
        startPosition: const Offset(0.45, 0.75),
        size: const Size(0.50, 0.50),
      ),
      DragItem(
        id: "نقطة",
        image: "assets/images/arabic_letters/lowerب.png",
        startPosition: const Offset(0.15, 0.8),
        size: const Size(0.30, 0.30),
      ),
    ],
    targets: [
      DragTargetZone(
        id: "partب",
        acceptedItemIds: ["ب"],
        position: const Offset(0.1, 0.2),
        size: const Size(0.8, 0.8),
        image: "assets/images/arabic_letters/upperب.png",
      ),
      DragTargetZone(
        id: "partنقطة",
        acceptedItemIds: ["نقطة"],
        position: const Offset(0.4, 0.4),
        size: const Size(0.3, 0.4),
        image: "assets/images/arabic_letters/lowerب.png",
      ),
    ],
  ),

  DragDropQuestion(
    questionAudio: 'ت',
    items: [
      DragItem(
        id: "ت",
        image: "assets/images/arabic_letters/upperب.png",
        startPosition: const Offset(0.45, 0.75),
        size: const Size(0.50, 0.50),
      ),
      DragItem(
        id: "نقطة",
        image: "assets/images/arabic_letters/lowerب.png",
        startPosition: const Offset(0.15, 0.8),
        size: const Size(0.30, 0.30),
      ),
    ],
    targets: [
      DragTargetZone(
        id: "partب",
        acceptedItemIds: ["ب"],
        position: const Offset(0.1, 0.2),
        size: const Size(0.8, 0.8),
        image: "assets/images/arabic_letters/upperب.png",
      ),
      DragTargetZone(
        id: "partنقطة",
        acceptedItemIds: ["نقطة"],
        position: const Offset(0.4, 0.4),
        size: const Size(0.3, 0.4),
        image: "assets/images/arabic_letters/lowerب.png",
      ),
    ],
  ),

  DragDropQuestion(
    questionAudio: 'ث',
    items: [
      DragItem(
        id: "ث",
        image: "assets/images/arabic_letters/upperب.png",
        startPosition: const Offset(0.45, 0.75),
        size: const Size(0.50, 0.50),
      ),
      DragItem(
        id: "نقطة",
        image: "assets/images/arabic_letters/lowerب.png",
        startPosition: const Offset(0.15, 0.8),
        size: const Size(0.30, 0.30),
      ),
    ],
    targets: [
      DragTargetZone(
        id: "partب",
        acceptedItemIds: ["ب"],
        position: const Offset(0.1, 0.2),
        size: const Size(0.8, 0.8),
        image: "assets/images/arabic_letters/upperب.png",
      ),
      DragTargetZone(
        id: "partنقطة",
        acceptedItemIds: ["نقطة"],
        position: const Offset(0.4, 0.4),
        size: const Size(0.3, 0.4),
        image: "assets/images/arabic_letters/lowerب.png",
      ),
    ],
  ),

  DragDropQuestion(
    questionAudio: 'ج',
    items: [
      DragItem(
        id: "ج",
        image: "assets/images/arabic_letters/upperب.png",
        startPosition: const Offset(0.45, 0.75),
        size: const Size(0.50, 0.50),
      ),
      DragItem(
        id: "نقطة",
        image: "assets/images/arabic_letters/lowerب.png",
        startPosition: const Offset(0.15, 0.8),
        size: const Size(0.30, 0.30),
      ),
    ],
    targets: [
      DragTargetZone(
        id: "partب",
        acceptedItemIds: ["ب"],
        position: const Offset(0.1, 0.2),
        size: const Size(0.8, 0.8),
        image: "assets/images/arabic_letters/upperب.png",
      ),
      DragTargetZone(
        id: "partنقطة",
        acceptedItemIds: ["نقطة"],
        position: const Offset(0.4, 0.4),
        size: const Size(0.3, 0.4),
        image: "assets/images/arabic_letters/lowerب.png",
      ),
    ],
  ),
];

final List<DragDropQuestion> enLetter = [
  DragDropQuestion(
    questionAudio: 'A',
    items: [
      DragItem(
        id: "leftA",
        image: "assets/images/letters/lefta.png",
        startPosition: const Offset(0.2, 0.8),
        size: const Size(0.2, 0.4),
      ),
      DragItem(
        id: "rightA",
        image: "assets/images/letters/righta.png",
        startPosition: const Offset(0.5, 0.8),
        size: const Size(0.2, 0.4),
      ),
      DragItem(
        id: "horA",
        image: "assets/images/letters/horizontalline.png",
        startPosition: const Offset(0.7, 0.8),
        size: const Size(0.25, 0.05),
      ),
    ],
    targets: [
      DragTargetZone(
        id: "partLeft",
        acceptedItemIds: ["leftA"],
        position: const Offset(0.1, 0.15),
        size: const Size(0.55, 0.4),
        image: "assets/images/letters/lefta.png",
      ),
      DragTargetZone(
        id: "partRight",
        acceptedItemIds: ["rightA"],
        position: const Offset(0.5, 0.15),
        size: const Size(0.55, 0.4),
        image: "assets/images/letters/righta.png",
      ),
      DragTargetZone(
        id: "hor",
        acceptedItemIds: ["horA"],
        position: const Offset(0.4, 0.37),
        size: const Size(0.35, 0.05),
        image: "assets/images/letters/horizontalline.png",
      ),
    ],
  ),

  DragDropQuestion(
    questionAudio: 'B',
    items: [
      DragItem(
        id: "verB",
        image: "assets/images/letters/vline.png",
        startPosition: const Offset(0.1, 0.8),
        size: const Size(0.15, 0.45),
      ),
      DragItem(
        id: "upB",
        image: "assets/images/letters/upperb.png",
        startPosition: const Offset(0.35, 0.8),
        size: const Size(0.2, 0.2),
      ),
      DragItem(
        id: "downB",
        image: "assets/images/letters/upperb.png",
        startPosition: const Offset(0.65, 0.8),
        size: const Size(0.2, 0.2),
      ),
    ],
    targets: [
      DragTargetZone(
        id: "partVer",
        acceptedItemIds: ["verB"],
        position: const Offset(0.2, 0.2),
        size: const Size(0.35, 0.4),
        image: "assets/images/letters/vline.png",
      ),
      DragTargetZone(
        id: "partUp",
        acceptedItemIds: ["upB"],
        position: const Offset(0.4, 0.22),
        size: const Size(0.23, 0.2),
        image: "assets/images/letters/upperb.png",
      ),
      DragTargetZone(
        id: "partDown",
        acceptedItemIds: ["downB"],
        position: const Offset(0.39, 0.37),
        size: const Size(0.26, 0.22),
        image: "assets/images/letters/upperb.png",
      ),
    ],
  ),

  DragDropQuestion(
    questionAudio: 'C',
    items: [
      DragItem(
        id: "C",
        image: "assets/images/letters/c-puzzle.png",
        startPosition: const Offset(0.3, 0.7),
        size: const Size(0.25, 0.25),
      ),
    ],
    targets: [
      DragTargetZone(
        id: "partC",
        acceptedItemIds: ["C"],
        position: const Offset(0.2, 0.15),
        size: const Size(0.55, 0.4),
        image: "assets/images/letters/c-puzzle.png",
      ),
    ],
  ),

  DragDropQuestion(
    questionAudio: 'D',
    items: [
      DragItem(
        id: "verD",
        image: "assets/images/letters/vline.png",
        startPosition: const Offset(0.2, 0.8),
        size: const Size(0.15, 0.45),
      ),
      DragItem(
        id: "upD",
        image: "assets/images/letters/upperb.png",
        startPosition: const Offset(0.7, 0.8),
        size: const Size(0.2, 0.2),
      ),
    ],
    targets: [
      DragTargetZone(
        id: "partVer",
        acceptedItemIds: ["verD"],
        position: const Offset(0.2, 0.19),
        size: const Size(0.6, 0.34),
        image: "assets/images/letters/vline.png",
      ),
      DragTargetZone(
        id: "partUp",
        acceptedItemIds: ["upD"],
        position: const Offset(0.35, 0.2),
        size: const Size(0.4, 0.35),
        image: "assets/images/letters/upperb.png",
      ),
    ],
  ),
];
