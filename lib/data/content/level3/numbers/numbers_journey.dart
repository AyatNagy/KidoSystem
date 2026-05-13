import 'package:kido/Models/level3/letters/letter_map.dart';
import 'package:kido/data/content/level3/numbers/tracing_bee.dart';
import 'package:kido/data/content/level3/numbers/tracing_rabbit.dart';
import 'number_lesson_arabic_data.dart';
import 'number_lesson_english_data.dart';

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
    isLocked: false,
    letterData: NumbersArabicLessonRepo.numbersArablessons[1],
    tracingData: tracingNumberTwoArab,
  ),
  LetterJourney(
    image: 'assets/images/arabicNumbers/num3_map.png',
    charName: '٣',
    isLocked: false,
    letterData: NumbersArabicLessonRepo.numbersArablessons[2],
    tracingData: tracingNumberThreeArab,
  ),
  LetterJourney(
    image: 'assets/images/arabicNumbers/num4_map.png',
    charName: '٤',
    isLocked: false,
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
    image: 'assets/images/common/train_engine.png',
    charName: 'train_phase1',
    isLocked: false,
  ),
  LetterJourney(
    image: 'assets/images/arabicNumbers/num6_map.png',
    charName: '٦',
    isLocked: true,
    letterData: NumbersArabicLessonRepo.numbersArablessons[5],
  ),
  LetterJourney(
    image: 'assets/images/arabicNumbers/num7_map.png',
    charName: '٧',
    isLocked: true,
    letterData: NumbersArabicLessonRepo.numbersArablessons[6],
  ),
  LetterJourney(
    image: 'assets/images/arabicNumbers/num8_map.png',
    charName: '٨',
    isLocked: true,
    letterData: NumbersArabicLessonRepo.numbersArablessons[7],
  ),
  LetterJourney(
    image: 'assets/images/arabicNumbers/num9_map.png',
    charName: '٩',
    isLocked: true,
    letterData: NumbersArabicLessonRepo.numbersArablessons[8],
  ),
  LetterJourney(
    image: 'assets/images/common/train_engine.png',
    charName: 'train_phase2',
    isLocked: false,
  ),
];

final List<LetterJourney> journeyNumEng = [
  LetterJourney(
    image: 'assets/images/englishNumbers/num1_map.png',
    charName: '1',
    isLocked: false,
    letterData: NumbersEnglishLessonRepo.numbersEnglessons[0],
    tracingData: tracingNumberOne,
  ),
  LetterJourney(
    image: 'assets/images/englishNumbers/num2_map.png',
    charName: '2',
    isLocked: true,
    letterData: NumbersEnglishLessonRepo.numbersEnglessons[1],
    tracingData: tracingNumberTwo,
  ),
  LetterJourney(
    image: 'assets/images/englishNumbers/num3_map.png',
    charName: '3',
    isLocked: true,
    letterData: NumbersEnglishLessonRepo.numbersEnglessons[2],
    tracingData: tracingNumberThree,
  ),
  LetterJourney(
    image: 'assets/images/englishNumbers/num4_map.png',
    charName: '4',
    isLocked: true,
    letterData: NumbersEnglishLessonRepo.numbersEnglessons[3],
    tracingData: tracingNumberFour,
  ),
  LetterJourney(
    image: 'assets/images/englishNumbers/num5_map.png',
    charName: '5',
    isLocked: true,
    letterData: NumbersEnglishLessonRepo.numbersEnglessons[4],
    tracingData: tracingNumberFive,
  ),
  LetterJourney(
    image: 'assets/images/common/train_engine.png',
    charName: 'train_phase1',
    isLocked: true,
  ),
  LetterJourney(
    image: 'assets/images/englishNumbers/num6_map.png',
    charName: '6',
    isLocked: true,
    letterData: NumbersEnglishLessonRepo.numbersEnglessons[5],
    tracingData: tracingNumberSix,
  ),
  LetterJourney(
    image: 'assets/images/englishNumbers/num7_map.png',
    charName: '7',
    isLocked: true,
    letterData: NumbersEnglishLessonRepo.numbersEnglessons[6],
    tracingData: tracingNumberSeven,
  ),
  LetterJourney(
    image: 'assets/images/englishNumbers/num8_map.png',
    charName: '8',
    isLocked: true,
    letterData: NumbersEnglishLessonRepo.numbersEnglessons[7],
    tracingData: tracingNumberEight,
  ),
  LetterJourney(
    image: 'assets/images/englishNumbers/num9_map.png',
    charName: '9',
    isLocked: true,
    letterData: NumbersEnglishLessonRepo.numbersEnglessons[8],
    tracingData: tracingNumberNine,
  ),
  LetterJourney(
    image: 'assets/images/common/train_engine.png',
    charName: 'train_phase2',
    isLocked: true,
  ),
];
