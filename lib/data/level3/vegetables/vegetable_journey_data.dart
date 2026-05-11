import 'package:kido/Models/level3/letters/letter_map.dart';

const _broccoli = "assets/gif/broccli.gif";
const _carrot = "assets/gif/carrot.gif";
const _chili = "assets/gif/chili_pepper.gif";
const _onion = "assets/gif/onion.gif";
const _tomato = "assets/gif/tomato.gif";

List<LetterJourney> buildVegetableJourney() => [
  LetterJourney(
      image: _broccoli,
      isLocked: true,
      charName: 'Broccoli\nبروكلي'
  ),
  LetterJourney(image: _carrot, isLocked: true, charName: 'Carrot\nجزر'),
  LetterJourney(
    image: _chili,
    isLocked: true,
    charName: 'Chili Pepper\nفلفل حار',
  ),
  LetterJourney(image: _onion, isLocked: true, charName: ''),
  LetterJourney(image: _tomato, isLocked: true, charName: ''),
  LetterJourney(image: _broccoli, isLocked: true, charName: ''),
  LetterJourney(image: _carrot, isLocked: true, charName: ''),
];
