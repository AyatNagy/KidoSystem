import'package:flutter/material.dart';
import 'package:kido/Models/dragable_item.dart';
import'package:kido/Models/draganddrop_question.dart';
import 'package:kido/Models/level3/numbers/numbers_train_model.dart';
import 'package:kido/Models/targets_item.dart';
import 'package:kido/services/asset_service.dart';


final List<TrainQuestion> trainTestQuestions=[
  TrainQuestion(
    phase:1,
    language: TrainLessonLanguage.english,
    gapIndex: 2,
    stopPosition: 0.57,
    question:DragDropQuestion(
    examId:['train_test'],
    questionText:"ركب العربة الناقصة في القطار",
    items:[
      DragItem(
        id:"car3",
        image:'assets/images/englishNumbers/train_car_3.png',
        startPosition: const Offset(0.09, 0.7),
        size: const Size(0.5, 0.2),
      ),
      DragItem(
        id:"car5",
        image:'assets/images/englishNumbers/train_car_5.png',
        startPosition: const Offset(0.3, 0.7),
        size: const Size(0.5, 0.2),
      ),
    ],
    targets:[
      DragTargetZone(
        id:"train_gap",
        image: 'assets/images/englishNumbers/train_car_3.png',
        acceptedItemIds:["car3"],
        position: const Offset(0.2, 0.03), 
        size: const Size(0.9, 0.35),
      ),
    ]
  ),
  ),

  TrainQuestion(
    phase:2,
    language: TrainLessonLanguage.english,
    gapIndex: 6,
    stopPosition: 0.77,
    question:DragDropQuestion(
    examId:['train_test'],
    questionText:"ركب العربة الناقصة في القطار",
    items:[
      DragItem(
        id:"car7",
        image:'assets/images/englishNumbers/train_car_7.png',
        startPosition: const Offset(0.55, 0.7),
        size: const Size(0.5, 0.2),
      ),
      DragItem(
        id:"car9",
        image:'assets/images/englishNumbers/train_car_9.png',
        startPosition: const Offset(0.75, 0.7),
        size: const Size(0.5, 0.2),
      ),
    ],
    targets:[
      DragTargetZone(
        id:"train_gap",
        image: 'assets/images/englishNumbers/train_car_7.png',
        acceptedItemIds:["car7"],
        position: const Offset(0.65, 0.03), 
        size: const Size(0.9, 0.35),
      ),
    ]
  ),
  ),
  TrainQuestion(
    phase:1,
    language: TrainLessonLanguage.arabic,
    gapIndex: 1,
    stopPosition: 0.41,
    question:DragDropQuestion(
    examId:['train_test'],
    questionText:"ركب العربة الناقصة في القطار",
    items:[
      DragItem(
        id:"car2",
        image:'assets/images/arabicNumbers/train_car_2.png',
        startPosition: const Offset(-0.03, 0.7),
        size: const Size(0.5, 0.2),
      ),
      DragItem(
        id:"car4",
        image:'assets/images/arabicNumbers/train_car_4.png',
        startPosition: const Offset(0.15, 0.7),
        size: const Size(0.5, 0.2),
      ),
    ],
    targets:[
      DragTargetZone(
        id:"train_gap",
        image: 'assets/images/arabicNumbers/train_car_2.png',
        acceptedItemIds:["car2"],
        position: const Offset(0.08, 0.03), 
        size: const Size(0.9, 0.35),
      ),
    ]
  ),
  ),
  TrainQuestion(
    phase:2,
    language: TrainLessonLanguage.arabic,
    gapIndex: 5,
    stopPosition: 0.67,
    question:DragDropQuestion(
    examId:['train_test'],
    questionText:"ركب العربة الناقصة في القطار",
    items:[
      DragItem(
        id:"car6",
        image:'assets/images/arabicNumbers/train_car_6.png',
        startPosition: const Offset(0.44, 0.7),
        size: const Size(0.5, 0.2),
      ),
      DragItem(
        id:"car8",
        image:'assets/images/arabicNumbers/train_car_8.png',
        startPosition: const Offset(0.65, 0.7),
        size: const Size(0.5, 0.2),
      ),
    ],
    targets:[
      DragTargetZone(
        id:"train_gap",
        image: 'assets/images/arabicNumbers/train_car_6.png',
        acceptedItemIds:["car6"],
        position: const Offset(0.55, 0.03), 
        size: const Size(0.9, 0.35),
      ),
    ]
  ),
  ),
];


