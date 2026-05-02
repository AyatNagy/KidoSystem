import 'package:kido/Models/level3/letters/letter_map.dart';
import 'package:kido/data/level3/shapes/shape_lessons_data.dart';
import 'package:kido/data/level3/shapes/tracing_shapes_data.dart';

final List<LetterJourney> journeyShapes = [
  LetterJourney(
    image: "assets/images/shapes/circle_map.png",
    charName: "Circle",
    isLocked: false,
    letterData: ShapesLessonRepo.shapes[0],
    tracingData: tracingCircle,
  ),

  LetterJourney(
    image: "assets/images/shapes/square_map.png",
    charName: "Square",
    isLocked: true,
    letterData: ShapesLessonRepo.shapes[1],
    tracingData: tracingSquare,
  ),

  LetterJourney(
    image: "assets/images/common/train_engine.png",
    charName: "train_phase1",
    isLocked: true,
  ),
];
