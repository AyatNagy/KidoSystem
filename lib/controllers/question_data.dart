import '../Models/question_model.dart';
import '../enum/question_type.dart';

final List<Question> questions = [
  Question(
    id: 1,
    type: QuestionType.choosing,
    title: 'Which one is HEAVY?',
    data: {
      'options': [
        {
          'id': 'elephant',
          'imageUrl': 'assets/images/elephant.png',
          'isCorrect': true
        },
        {
          'id': 'feather',
          'imageUrl': 'assets/images/feather.png',
          'isCorrect': false
        },
      ],
      'correctKey': 'elephant',
    },
  ),
  Question(
    id: 2,
    type: QuestionType.choosing,
    title: 'Which one is BIG?',
    data: {
      'options': [
        {
          'id': 'big',
          'imageUrl': 'assets/images/whale.png',
          'isCorrect': true
        },
        {
          'id': 'small',
          'imageUrl': 'assets/images/small.png',
          'isCorrect': false
        },
      ],
      'correctKey': 'big',
    },
  ),
  Question(
    id: 3,
    type: QuestionType.choosing,
    title: 'Which one is a GIRL?',
    data: {
      'options': [
        {
          'id': 'boy',
          'imageUrl': 'assets/images/boy.png',
          'isCorrect': false
        },
        {
          'id': 'girl',
          'imageUrl': 'assets/images/girl.png',
          'isCorrect': true
        },
      ],
      'correctKey': 'girl',
    },
  ),
  Question(
      id: 4,
      type: QuestionType.sorting,
      title: 'KITCHEN or ROOM?',
      data: {
        'targets' : [
          'assets/images/kitchen.png',
          'assets/images/room.png'
        ],
        'items' : {
          'assets/images/spoon.png' : 'assets/images/kitchen.png',
          'assets/images/pot2.png' : 'assets/images/kitchen.png',
          'assets/images/duck.png' : 'assets/images/room.png',
          'assets/images/car.png' : 'assets/images/room.png',
        },
      }
  ),
  Question(
      id: 5,
      type: QuestionType.sorting,
      title: 'TALL or SHORT?',
      data: {
        'targets' : [
          'assets/images/tallbox.png',
          'assets/images/shortbox.png'
        ],
        'items' : {
          'assets/images/turtle.png' : 'assets/images/shortbox.png',
          'assets/images/tree.png' : 'assets/images/tallbox.png',
          'assets/images/giraffe.png' : 'assets/images/tallbox.png',
          'assets/images/mushroom.png' : 'assets/images/shortbox.png',
        },
      }
  ),
  Question(
      id: 6,
      type: QuestionType.sorting,
      title: 'BUILD THE BRIDGE!',
      data: {
        'targets' : [
          'assets/images/bridge_gap.png',
        ],
        'items' : {
          'assets/images/birdge_box.png' : 'assets/images/bridge_gap.png',
          'assets/images/birdge_box.png' : 'assets/images/bridge_gap.png',
          'assets/images/birdge_box.png' : 'assets/images/bridge_gap.png',
        },
      }
  ),
];