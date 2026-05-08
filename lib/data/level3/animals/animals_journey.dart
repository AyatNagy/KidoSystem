import 'package:kido/data/level3/animals/animals_data.dart';
import '../../../Models/level3/letters/letter_map.dart';


final List<LetterJourney> animalsJourney = [
  LetterJourney(
    image:"assets/images/animals/cat.png",
    isLocked: false,
    letterData: animalsDiscovery[0],
    charName:'cat'
    
  ),

  LetterJourney(
      image: "assets/images/animals/dog.png",
      isLocked: true,
      letterData: animalsDiscovery[1],
      charName:'dog'
     
  ),

  LetterJourney(
    image: "assets/images/animals/duck.png",
    isLocked: true,
    letterData: animalsDiscovery[2],
    charName:'duck'
   
  ),

  LetterJourney(
    image: "assets/images/animals/horse.png",
    isLocked: true,
    letterData: animalsDiscovery[3],
    charName:'horse'
    
  ),

  LetterJourney(
    image:"assets/images/animals/lion.png",
    isLocked: true,
    letterData: animalsDiscovery[4],
    charName:'lion'
    
  ),

  LetterJourney(
    image: "assets/images/animals/rabbit.png",
    isLocked: true,
    letterData: animalsDiscovery[5],
    charName:'rabbit'
    
  ),
  LetterJourney(
    image: "assets/images/animals/practice_icon.png",
    isLocked: true,
    letterData: animalsDiscovery[0],
    charName:'practice_test'
    
  ),
] ;