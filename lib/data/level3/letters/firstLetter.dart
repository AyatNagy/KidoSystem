 import 'dart:ui';

import '../../../Models/dragable_item.dart';
import '../../../Models/draganddrop_question.dart';
import '../../../Models/targets_item.dart';

 final List<DragDropQuestion> firstLetter = [
  DragDropQuestion(
   questionText: 'الف',
   items: [
    DragItem(
     id: "ا",
     image: "assets/images/arabicLetters/ا.png",
     startPosition: const Offset(0.45, 0.6),
     size: const Size(0.50, 0.50),
    ),
    DragItem(
     id: "ء",
     image: "assets/images/arabicLetters/ء.png",
     startPosition: const Offset(0.15, 0.7),
     size: const Size(0.30, 0.30),
    ),
   ],
   targets: [
    DragTargetZone(
     id: "partا",
     acceptedItemIds: ["ا"],
     position: const Offset(0.1, 0.07),
     size: const Size(0.8, 0.8),
     image: "assets/images/arabicLetters/shadowا.png",
    ),
    DragTargetZone(
     id: "partء",
     acceptedItemIds: ["ء"],
     position: const Offset(0.3, 0.07),
     size: const Size(0.3, 0.4),
     image: "assets/images/arabicLetters/shadowء.png",
    ),
   ],
  ),
 ];