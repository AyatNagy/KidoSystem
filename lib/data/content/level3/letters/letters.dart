import 'package:kido/Models/level3/letters/first_lesson.dart';
import 'package:kido/constants.dart';

final List<LetterModel> arletters = [
  LetterModel(
    letterPath: 'assets/images/arabic_letters/letterأ.png',
    animalPath: 'assets/images/arabic_letters/rabbit.png',
    audioName: 'audio/alphabet_ar/ا.mp3',
    activeBorder: AppColors.kidoRed,
    bgColor: AppColors.kidoColors[6],
  ),

  LetterModel(
    letterPath: 'assets/images/arabic_letters/letterب.png',
    animalPath: 'assets/images/arabic_letters/duck.png',
    audioName: 'audio/alphabet_ar/ب.mp3',
  ),

  LetterModel(
    letterPath: 'assets/images/arabic_letters/letterت.png',
    animalPath: 'assets/images/arabic_letters/crocodile.png',
    audioName: 'audio/alphabet_ar/ت.mp3',
  ),

  LetterModel(
    letterPath: 'assets/images/arabic_letters/letterث.png',
    animalPath: 'assets/images/arabic_letters/fox.png',
    audioName: 'audio/alphabet_ar/ث.mp3',
  ),

  LetterModel(
    letterPath: 'assets/images/arabic_letters/letterج.png',
    animalPath: 'assets/images/arabic_letters/bell.png',
    audioName: 'audio/alphabet_ar/ج.mp3',
  ),
];

final List<LetterModel> enletters = [
  LetterModel(
    letterPath: 'assets/images/Letters/aa.png',
    animalPath: 'assets/images/apple.png',
    audioName: 'audio/alphabet_en/kid-a.mp3',
    bgColor: AppColors.kidoPink,
    activeBorder: AppColors.kidoColors[3],
  ),

  LetterModel(
    letterPath: 'assets/images/Letters/bb.png',
    animalPath: 'assets/images/ball.png',
    audioName: 'audio/alphabet_en/kid-b.mp3',
    bgColor: AppColors.kidoBlue,
    activeBorder: AppColors.kidoColors[1],
  ),

  LetterModel(
    letterPath: 'assets/images/Letters/cc.png',
    animalPath: 'assets/images/cat2.png',
    audioName: 'audio/alphabet_en/kid-c.mp3',
    bgColor: AppColors.kidoGreen,
    activeBorder: AppColors.kidoColors[4],
  ),

  LetterModel(
    letterPath: 'assets/images/Letters/dd.png',
    animalPath: 'assets/images/dog2.png',
    audioName: 'audio/alphabet_en/kid-d.mp3',
    bgColor: AppColors.purpleMain,
    activeBorder: AppColors.kidoColors[2],
  ),
];
