import 'package:kido/Models/level3/letters/letter_map.dart';
import 'package:kido/data/level3/numbers/number_lesson_arabic_data.dart';
import 'package:kido/data/level3/numbers/number_lesson_english_data.dart';
import 'package:kido/data/level3/numbers/tracing_bee.dart';
import 'package:kido/data/level3/numbers/tracing_rabbit.dart';
     
final List<LetterJourney> journeyNumArab = [
  LetterJourney(
    image: 'assets/images/arabicNumbers/num1_map.png',
    charName: '١',
    isLocked: false,
    letterData: NumbersArabicLessonRepo.numbersArablessons[0],
    tracingData: tracingNumberOneArab,
  ),
  LetterJourney(
    image: 'assets/images/arabicNumbers/num2_map.png',
    charName: '٢',
    isLocked: true,
    letterData: NumbersArabicLessonRepo.numbersArablessons[1],
    tracingData: tracingNumberTwoArab,
  ),
  LetterJourney(
    image: 'assets/images/arabicNumbers/num3_map.png',
    charName: '٣',
    isLocked: true,
    letterData: NumbersArabicLessonRepo.numbersArablessons[2],
    tracingData: tracingNumberThreeArab,
  ),
  LetterJourney(
    image: 'assets/images/arabicNumbers/num4_map.png',
    charName: '٤',
    isLocked: true,
    letterData: NumbersArabicLessonRepo.numbersArablessons[3],
    tracingData: tracingNumberFourArab,
  ),
  LetterJourney(
    image: 'assets/images/arabicNumbers/num5_map.png',
    charName: '٥',
    isLocked: false,
    letterData: NumbersArabicLessonRepo.numbersArablessons[4],
    tracingData: tracingNumberFiveArab,
  ),
  LetterJourney(
    image: 'assets/images/train_engine.png',
    charName: 'train_phase1',
    isLocked: true,
  ),
  LetterJourney(
    image: 'assets/images/arabicNumbers/num1_map.png',
    charName: '٦',
    isLocked: true,
    letterData: NumbersArabicLessonRepo.numbersArablessons[5],
  ),
  LetterJourney(
    image: 'assets/images/arabicNumbers/num1_map.png',
    charName: '٧',
    isLocked: true,
    letterData: NumbersArabicLessonRepo.numbersArablessons[6],
  ),
  LetterJourney(
    image: 'assets/images/arabicNumbers/num1_map.png',
    charName: '٨',
    isLocked: true,
    letterData: NumbersArabicLessonRepo.numbersArablessons[7],
  ),
  LetterJourney(
    image: 'assets/images/arabicNumbers/num1_map.png',
    charName: '٩',
    isLocked: true,
    letterData: NumbersArabicLessonRepo.numbersArablessons[8],
  ),
  LetterJourney(
    image: 'assets/images/common/train_engine.png',
    charName: 'train_phase2',
    isLocked: true,
  ),

];

final List<LetterJourney> journeyNumEng = [
  LetterJourney(
      image: NumbersEnglishLessonRepo.numbersEnglessons[0].numberImagePath,
      charName: '1',
      isLocked: false,
      letterData: NumbersEnglishLessonRepo.numbersEnglessons[0],
      tracingData: tracingNumberOne
      ),
       LetterJourney(
      image: NumbersEnglishLessonRepo.numbersEnglessons[1].numberImagePath,
      charName: '2',
      isLocked: true,
      letterData: NumbersEnglishLessonRepo.numbersEnglessons[1],
      tracingData:tracingNumberTwo,
      ),
      LetterJourney(
      image: NumbersEnglishLessonRepo.numbersEnglessons[2].numberImagePath,
      charName: '3',
      isLocked: true,
      letterData: NumbersEnglishLessonRepo.numbersEnglessons[2],
      tracingData: tracingNumberThree,
      ),
      LetterJourney(
      image: NumbersEnglishLessonRepo.numbersEnglessons[3].numberImagePath,
      charName: '4',
      isLocked: true,
      letterData: NumbersEnglishLessonRepo.numbersEnglessons[3],
      tracingData: tracingNumberFour,
      ),
      LetterJourney(
      image: NumbersEnglishLessonRepo.numbersEnglessons[4].numberImagePath,
      charName: '5',
      isLocked: true,
      letterData: NumbersEnglishLessonRepo.numbersEnglessons[4],
      tracingData: tracingNumberFive,
      ),
      LetterJourney(
      image:'assets/images/common/train_engine.png',
      charName: 'train_phase1',
      isLocked: true,
      ),
      LetterJourney(
      image: NumbersEnglishLessonRepo.numbersEnglessons[5].numberImagePath,
      charName: '6',
      isLocked: true,
      letterData: NumbersEnglishLessonRepo.numbersEnglessons[5],
      tracingData: tracingNumberSix,
      ),
      LetterJourney(
      image: NumbersEnglishLessonRepo.numbersEnglessons[6].numberImagePath,
      charName: '7',
      isLocked: true,
      letterData: NumbersEnglishLessonRepo.numbersEnglessons[6],
      tracingData:tracingNumberSeven,
      ),
      LetterJourney(
      image: NumbersEnglishLessonRepo.numbersEnglessons[7].numberImagePath,
      charName: '8',
      isLocked: true,
      letterData: NumbersEnglishLessonRepo.numbersEnglessons[7],
      tracingData: tracingNumberEight,
      ),
      LetterJourney(
      image: NumbersEnglishLessonRepo.numbersEnglessons[8].numberImagePath,
      charName: '9',
      isLocked: true,
      letterData: NumbersEnglishLessonRepo.numbersEnglessons[8],
      tracingData:tracingNumberNine
      ),
      LetterJourney(
      image:'assets/images/common/train_engine.png',
      charName: 'train_phase2',
      isLocked: true,
      ),
];

