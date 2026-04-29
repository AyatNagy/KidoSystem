import 'package:kido/Models/level3/letters/letter_map.dart';
import 'Family_model.dart';

const String familySongIcon = 'assets/images/family/song_icon.png';
const String familyTreeIcon = 'assets/images/family/tree_icon.png';

List<LetterJourney> buildFamilyJourney() => [
  // تم حذف My Family لتبدأ الرحلة من الجد مباشرة
  LetterJourney(
    image: familyGrandfather,
    isLocked: false,
    charName: 'Grandfather\nجد',
  ),
  LetterJourney(
    image: familyGrandmother,
    isLocked: false,
    charName: 'Grandmother\nجدة',
  ),
  LetterJourney(image: familyFather, isLocked: false, charName: 'Father\nأب'),
  LetterJourney(image: familyMother, isLocked: false, charName: 'Mother\nأم'),
  LetterJourney(image: familyBrother, isLocked: false, charName: 'Brother\nأخ'),
  LetterJourney(image: familySister, isLocked: false, charName: 'Sister\nأخت'),

  LetterJourney(
    image: familySongIcon,
    isLocked: false,
    charName: 'Listen & Guess 🎵\nاستمع وخمّن',
  ),

  LetterJourney(
    image: familyTreeIcon,
    isLocked: false,
    charName: 'Family Tree 🌳\nشجرة العائلة',
  ),
];
