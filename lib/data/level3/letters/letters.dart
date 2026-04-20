import 'package:kido/Models/level3/letters/first_lesson.dart';
import 'package:kido/constants.dart';

final List<LetterModel> Arletters = [

  LetterModel(
      letterPath: 'assets/images/arabicLetters/letterأ.png',
      animalPath: 'assets/images/arabicLetters/rabbit.png',
      audioName: 'audio/alphabet_ar/ا.mp3',
  ),

  LetterModel(
      letterPath: 'assets/images/arabicLetters/letterب.png',
      animalPath: 'assets/images/arabicLetters/duck.png',
      audioName: 'audio/alphabet_ar/ب.mp3',
  ),

  LetterModel(
    letterPath: 'assets/images/arabicLetters/letterت.png',
    animalPath: 'assets/images/apple.png',
    audioName: 'audio/alphabet_ar/ت.mp3',
  ),
];

final List<LetterModel> Enletters = [

  LetterModel(
    letterPath: 'assets/images/Letters/Aa.png',
    animalPath: 'assets/images/apple.png',
    audioName: 'audio/alphabet_en/kid-a.mp3',
    bgColor: AppColors.kidoPink,
    activeBorder: AppColors.kidoColors[3]
  ),

  LetterModel(
    letterPath: 'assets/images/Letters/Bb.png',
    animalPath: 'assets/images/ball.png',
    audioName: 'audio/alphabet_en/kid-b.mp3',
    bgColor: AppColors.kidoBlue,
    activeBorder: AppColors.kidoColors[1]
  ),

  LetterModel(
    letterPath: 'assets/images/Letters/Cc.png',
    animalPath: 'assets/images/cat.png',
    audioName: 'audio/alphabet_en/kid-c.mp3',
    bgColor: AppColors.kidoGreen,
    activeBorder: AppColors.kidoColors[4]
  ),
];