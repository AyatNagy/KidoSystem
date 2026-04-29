import 'package:kido/data/level3/letters/drag_and_drop.dart';
import '../../../Models/level3/letters/letter_map.dart';
import 'letters.dart';

final List<LetterJourney> journeyEn = [
  LetterJourney(
    image: "assets/images/letters/logo-A.png",
    isLocked: false,
    charName: 'A',
    letterData: enletters[0],
    dragData: enLetter[0],
  ),

  LetterJourney(
    image: "assets/images/letters/logo-B.png",
    isLocked: true,
    charName: 'B',
    letterData: enletters[1],
    dragData: enLetter[1],
  ),

  LetterJourney(
    image: "assets/images/letters/logo-C.png",
    isLocked: true,
    charName: 'C',
    letterData: enletters[2],
    dragData: enLetter[2],
  ),

  LetterJourney(
    image: "assets/images/letters/logo-D.png",
    isLocked: true,
    charName: 'D',
    letterData: enletters[3],
    dragData: enLetter[3],
  ),
];

final List<LetterJourney> journeyAr = [
  LetterJourney(
    image: "assets/images/arabicletters/logoأ.png",
    isLocked: false,
    charName: 'أ',
    letterData: arletters[0],
    dragData: arLetter[0],
  ),

  LetterJourney(
    image: "assets/images/arabicletters/logoب.png",
    isLocked: true,
    charName: 'ب',
    letterData: arletters[1],
    dragData: arLetter[1],
  ),

  LetterJourney(
    image: "assets/images/arabicletters/logoت.png",
    isLocked: true,
    charName: 'ت',
    letterData: arletters[2],
    dragData: arLetter[2],
  ),

  LetterJourney(
    image: "assets/images/arabicletters/logoث.png",
    isLocked: true,
    charName: 'ث',
    letterData: arletters[3],
    dragData: arLetter[3],
  ),

  LetterJourney(
    image: "assets/images/arabicletters/logoج.png",
    isLocked: true,
    charName: 'ج',
    letterData: arletters[4],
    dragData: arLetter[4],
  ),
];