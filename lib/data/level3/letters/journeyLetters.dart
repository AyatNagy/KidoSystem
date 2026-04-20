import '../../../Models/level3/letters/letterMap.dart';
import 'dragAnddrop.dart';
import 'letters.dart';

final List<LetterJourney> journeyEn = [
  LetterJourney(
    image: "assets/images/letters/logo-A.png",
    isLocked: false,
    charName: 'A',
    letterData: Enletters[0],
    dragData: EnLetter[0],
  ),

  LetterJourney(
    image: "assets/images/letters/logo-B.png",
    isLocked: true,
    charName: 'B',
    letterData: Enletters[1],
    dragData: EnLetter[1],
  ),

  LetterJourney(
    image: "assets/images/letters/logo-C.png",
    isLocked: true,
    charName: 'C',
    letterData: Enletters[2],
    dragData: EnLetter[2],
  ),
];