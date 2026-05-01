import 'package:kido/data/level3/fruits/fruits_pixel.dart';
import '../../../Models/level3/letters/letter_map.dart';
import 'fruits_discovery.dart';

final List<LetterJourney> journeyFruits = [
  LetterJourney(
    image: "assets/images/apple.png",
    isLocked: false,
    letterData: fruitsDiscovery[0],
    dragData: fruits[0]
  ),

  LetterJourney(
      image: "assets/images/fruits/watermelon.png",
      isLocked: true,
      letterData: fruitsDiscovery[5],
      dragData: fruits[5]
  ),

  LetterJourney(
    image: "assets/images/fruits/banana.png",
    isLocked: true,
    letterData: fruitsDiscovery[2],
    dragData: fruits[2]
  ),

  LetterJourney(
    image: "assets/images/fruits/grapes.png",
    isLocked: true,
    letterData: fruitsDiscovery[3],
    dragData: fruits[3]
  ),

  LetterJourney(
    image: "assets/images/fruits/orange.png",
    isLocked: true,
    letterData: fruitsDiscovery[1],
    dragData: fruits[1]
  ),

  LetterJourney(
    image: "assets/images/fruits/strawbery.png",
    isLocked: true,
    letterData: fruitsDiscovery[4],
    dragData: fruits[4]
  ),
] ;