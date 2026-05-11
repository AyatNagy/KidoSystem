import 'package:kido/data/content/level1/senses/sense_data.dart';
import '../../../../Models/level3/letters/letter_map.dart';
import '../../../../enum/sense_type.dart';

final List<LetterJourney> sensesJourney = [
  LetterJourney(
    image: "assets/images/senses/eye.png",
    isLocked: false,
    letterData: SenseMapper.get(SenseType.eyes),
    charName: 'eyes',
  ),
  LetterJourney(
    image: SenseMapper.get(SenseType.nose).featureImage,
    isLocked: true,
    letterData: SenseMapper.get(SenseType.nose),
    charName: 'nose',
  ),
  LetterJourney(
    image: "assets/images/senses/mouth_map.png",
    isLocked: true,
    letterData: SenseMapper.get(SenseType.mouth),
    charName: 'mouth',
  ),
  LetterJourney(
    image: "assets/images/senses/ear.png",
    isLocked: true,
    letterData: SenseMapper.get(SenseType.ears),
    charName: 'ears',
  ),
];
