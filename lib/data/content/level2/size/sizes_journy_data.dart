import 'package:kido/data/content/level2/size/size_data.dart';
import '../../../../Models/level3/letters/letter_map.dart';
import '../../../../enum/size_goal.dart';

final List<LetterJourney> sizesJourney = [
  LetterJourney(
    image: SizeLessonMapper.get(SizeGoal.tall).correctImage,
    isLocked: false,
    letterData: SizeLessonMapper.get(SizeGoal.tall),
    charName: 'tall',
  ),
  LetterJourney(
    image: SizeLessonMapper.get(SizeGoal.short).correctImage,
    isLocked: true,
    letterData: SizeLessonMapper.get(SizeGoal.short),
    charName: 'short',
  ),
  LetterJourney(
    image: SizeLessonMapper.get(SizeGoal.fat).correctImage,
    isLocked: true,
    letterData: SizeLessonMapper.get(SizeGoal.fat),
    charName: 'fat',
  ),
  LetterJourney(
    image: SizeLessonMapper.get(SizeGoal.thin).correctImage,
    isLocked: true,
    letterData: SizeLessonMapper.get(SizeGoal.thin),
    charName: 'thin',
  ),
  LetterJourney(
    image: SizeLessonMapper.get(SizeGoal.big).correctImage,
    isLocked: true,
    letterData: SizeLessonMapper.get(SizeGoal.big),
    charName: 'big',
  ),
  LetterJourney(
    image: SizeLessonMapper.get(SizeGoal.small).correctImage,
    isLocked: true,
    letterData: SizeLessonMapper.get(SizeGoal.small),
    charName: 'small',
  ),
];
