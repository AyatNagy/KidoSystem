import 'package:flutter/material.dart';
import 'package:kido/Models/dragable_item.dart';
import 'package:kido/Models/exams/draganddrop_question.dart';
import 'package:kido/Models/targets_item.dart';

class AnimalsGameData {
  static List<DragDropQuestion> animalsQuestions = [
    DragDropQuestion(
      examId: ['Animals_faces__game'],
      questionAudio: 'ركب وجه القطة',
      backgroundImage: 'assets/images/animals/cat_body.png',
      items: [
        DragItem(
          id: 'cat_face',
          image: 'assets/images/animals/cat_head.png',
          startPosition: const Offset(0.2, 0.75),
          size: const Size(0.52, 0.52),
        ),
      ],
      targets: [
        DragTargetZone(
          id: 'cat_face_shadow',
          acceptedItemIds: ['cat_face'],
          position: const Offset(0.06, 0.20),
          size: const Size(0.52, 0.52),
          image: 'assets/images/animals/cat_head.png',
        ),
      ],
    ),

    DragDropQuestion(
      examId: ['Animals_faces__game'],
      questionAudio: 'ركب وجه الكلب',
      backgroundImage: 'assets/images/animals/dog_body.png',
      items: [
        DragItem(
          id: 'dog_face',
          image: 'assets/images/animals/dog_head.png',
          startPosition: const Offset(0.01, 0.75),
          size: const Size(0.88, 0.88),
        ),
        DragItem(
          id: 'cat_face',
          image: 'assets/images/animals/cat_head.png',
          startPosition: const Offset(0.01, 0.75),
          size: const Size(0.88, 0.88),
        ),
      ],
      targets: [
        DragTargetZone(
          id: 'dog_face_shadow',
          acceptedItemIds: ['dog_face'],
          position: const Offset(0.08, 0.19),
          size: const Size(0.88, 0.88),
          image: 'assets/images/animals/dog_head.png',
        ),
      ],
    ),
    DragDropQuestion(
      examId: ['Animals_faces__game'],
      questionAudio: 'ركب وجه البطة',
      backgroundImage: 'assets/images/animals/duck_body.png',
      items: [
        DragItem(
          id: 'duck_face',
          image: 'assets/images/animals/duck_head.png',
          startPosition: const Offset(0.3, 0.75),
          size: const Size(0.55, 0.55),
        ),
      ],
      targets: [
        DragTargetZone(
          id: 'duck_face_shadow',
          acceptedItemIds: ['duck_face'],
          position: const Offset(0.40, 0.16),
          size: const Size(0.55, 0.55),
          image: 'assets/images/animals/duck_head.png',
        ),
      ],
    ),

    DragDropQuestion(
      examId: ['Animals_faces__game'],
      questionAudio: 'ركب وجه الحصان',
      backgroundImage: 'assets/images/animals/horse_body.png',
      items: [
        DragItem(
          id: 'horse_face',
          image: 'assets/images/animals/horse_head.png',
          startPosition: const Offset(0.3, 0.65),
          size: const Size(0.55, 0.55),
        ),
      ],
      targets: [
        DragTargetZone(
          id: 'horse_face_shadow',
          acceptedItemIds: ['horse_face'],
          position: const Offset(0.40, 0.08),
          size: const Size(0.60, 0.60),
          image: 'assets/images/animals/horse_head.png',
        ),
      ],
    ),
    DragDropQuestion(
      examId: ['Animals_faces__game'],
      questionAudio: 'ركب وجه الاسد',
      backgroundImage: 'assets/images/animals/lion_body.png',
      items: [
        DragItem(
          id: 'lion_face',
          image: 'assets/images/animals/lion_head.png',
          startPosition: const Offset(0.3, 0.75),
          size: const Size(0.55, 0.55),
        ),
      ],
      targets: [
        DragTargetZone(
          id: 'lion_face_shadow',
          acceptedItemIds: ['lion_face'],
          position: const Offset(0.10, 0.03),
          size: const Size(0.86, 0.86),
          image: 'assets/images/animals/lion_head.png',
        ),
      ],
    ),
    DragDropQuestion(
      examId: ['Animals_faces__game'],
      questionAudio: 'ركب وجه الارنب',
      backgroundImage: 'assets/images/animals/rabbit_body.png',
      items: [
        DragItem(
          id: 'rabbit_face',
          image: 'assets/images/animals/rabbit_head.png',
          startPosition: const Offset(0.3, 0.75),
          size: const Size(0.55, 0.55),
        ),
      ],
      targets: [
        DragTargetZone(
          id: 'rabbit_face_shadow',
          acceptedItemIds: ['rabbit_face'],
          position: const Offset(0.1, 0.00),
          size: const Size(0.80, 0.80),
          image: 'assets/images/animals/rabbit_head.png',
        ),
      ],
    ),
  ];
}
