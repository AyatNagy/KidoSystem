import 'package:kido/data/level3/fruits/fruits_pixel.dart';
import '../../../Models/level3/letters/letterMap.dart';
import 'fruits_discovery.dart';

final List<LetterJourney> journeyFruits = [
  LetterJourney(
    image: "assets/images/apple.png",
    isLocked: false,
    letterData: fruits_discovery[0],
    dragData: fruits[0]
  ),

  LetterJourney(
    image: "assets/images/fruits/banana.png",
    isLocked: true,
    letterData: fruits_discovery[2],
    dragData: fruits[2]
  ),

  LetterJourney(
    image: "assets/images/fruits/grapes.png",
    isLocked: true,
    letterData: fruits_discovery[3],
    dragData: fruits[3]
  ),

  LetterJourney(
    image: "assets/images/fruits/orange.png",
    isLocked: true,
    letterData: fruits_discovery[1],
    dragData: fruits[1]
  ),

  LetterJourney(
    image: "assets/images/fruits/strawbery.png",
    isLocked: true,
    letterData: fruits_discovery[4],
    dragData: fruits[4]
  ),
] ;