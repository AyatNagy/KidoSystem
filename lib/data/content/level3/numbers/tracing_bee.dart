import 'package:flutter/material.dart';
import 'package:kido/Models/level3/numbers/tracing_numbers.dart';

final tracingNumberOne = TracingQuestion(
  id: "number_1",
  numberValue: 1,
  audioPath:"numeric_en/kid-1.mp3",
  characterImage: 'assets/images/bee.png',
  backgroundImage1: "assets/images/englishNumbers/seed_curved_one.png",
  backgroundImage2: "assets/images/englishNumbers/seed_one.png",
  backgroundImage3: "assets/images/englishNumbers/half_blooming_one.png",
  backgroundImage4: "assets/images/englishNumbers/full_blooming_one.png",
  startPosition: const Offset(0.25, 0.40), 
  midTarget: const Offset(0.50, 0.28),      
  endTarget: const Offset(0.50, 0.75),      
  pathPoints: [
    const Offset(0.28, 0.40), 
    const Offset(0.50, 0.28), 
    const Offset(0.50, 0.52), 
    const Offset(0.50, 0.75), 
  ],
);

final tracingNumberTwo = TracingQuestion(
  id: "number_2",
  numberValue: 2,
  audioPath:"numeric_en/kid-2.mp3",
   characterImage: 'assets/images/bee.png',
  backgroundImage1: "assets/images/englishNumbers/seed_curved_two.png",
  backgroundImage2: "assets/images/englishNumbers/seed_two.png",
  backgroundImage3: "assets/images/englishNumbers/half_blooming_two.png",
  backgroundImage4: "assets/images/englishNumbers/full_blooming_two.png",
  startPosition: const Offset(0.28, 0.32), 
  midTarget: const Offset(0.68, 0.42),      
  endTarget: const Offset(0.70, 0.78),      

  pathPoints: [
    const Offset(0.28, 0.32), 
    const Offset(0.40, 0.20), 
    const Offset(0.60, 0.22), 
    const Offset(0.68, 0.42),
    const Offset(0.45, 0.65), 
    const Offset(0.30, 0.78), 
    const Offset(0.50, 0.78), 
    const Offset(0.70, 0.78), 
  ],
);

  final tracingNumberThree = TracingQuestion(
  id: "number_3",
  numberValue: 3,
  audioPath:"numeric_en/kid-3.mp3",
  characterImage: 'assets/images/bee.png',
  backgroundImage1: "assets/images/englishNumbers/seed_curved_three.png",
  backgroundImage2: "assets/images/englishNumbers/seed_three.png",
  backgroundImage3: "assets/images/englishNumbers/half_blooming_three.png",
  backgroundImage4: "assets/images/englishNumbers/full_blooming_three.png",
  
  
  startPosition: const Offset(0.25, 0.28), 
  midTarget: const Offset(0.48, 0.48),      
  endTarget: const Offset(0.25, 0.72),      

  pathPoints: [
    // --- TOP CURVE ---
    const Offset(0.30, 0.28), 
    const Offset(0.40, 0.15), 
    const Offset(0.55, 0.10), 
    const Offset(0.72, 0.25), 
    const Offset(0.48, 0.48), 

    // --- BOTTOM CURVE ---
    const Offset(0.75, 0.58), 
    const Offset(0.55, 0.82), 
    const Offset(0.38, 0.82), 
    const Offset(0.25, 0.72), 
  ],

);

final tracingNumberFour = TracingQuestion(
  id: "number_4",
  numberValue: 4,
  audioPath:"numeric_en/kid-4.mp3",
  characterImage: 'assets/images/bee.png',
  backgroundImage1: "assets/images/englishNumbers/seed_curved_four.png",
  backgroundImage2: "assets/images/englishNumbers/seed_four.png",
  backgroundImage3: "assets/images/englishNumbers/half_blooming_four.png",
  backgroundImage4: "assets/images/englishNumbers/full_blooming_four.png",
  startPosition: const Offset(0.25, 0.02), 
  midTarget: const Offset(0.75, 0.60),      
  endTarget: const Offset(0.75, 0.90),      
  pathPoints: [
   const Offset(0.25, 0.02), 
    const Offset(0.25, 0.60), 
    const Offset(0.75, 0.60), 
    const Offset(0.75, 0.00), 
    const Offset(0.75, 0.40), 
    const Offset(0.75, 0.60), 
    const Offset(0.75, 0.90), 
  ],
  
);

final tracingNumberFive = TracingQuestion(
  id: "number_5",
  numberValue: 5,
  audioPath:"numeric_en/kid-5.mp3",
  characterImage: 'assets/images/bee.png',
  backgroundImage1:"assets/images/englishNumbers/seed_curved_five.png",
  backgroundImage2:"assets/images/englishNumbers/seed_five.png",
  backgroundImage3:"assets/images/englishNumbers/half_blooming_five.png",
  backgroundImage4:"assets/images/englishNumbers/full_blooming_five.png",
  startPosition:const Offset(0.70, 0.10), 
  midTarget:const Offset(0.30, 0.45),      
  endTarget:const Offset(0.30, 0.85),      
  pathPoints:[
   const Offset(0.70, 0.10), 
  const Offset(0.30, 0.10), 
  const Offset(0.30, 0.45), 
  const Offset(0.55, 0.45),
  const Offset(0.75, 0.60), 
  const Offset(0.65, 0.85), 
  const Offset(0.30, 0.85), 
  ],
  
);

final tracingNumberSix= TracingQuestion(
  id: "number_6",
  numberValue: 6,
  audioPath:"numeric_en/kid-6.mp3",
  characterImage: 'assets/images/bee.png',
  backgroundImage1:"assets/images/englishNumbers/seed_curved_six.png",
  backgroundImage2:"assets/images/englishNumbers/seed_six.png",
  backgroundImage3:"assets/images/englishNumbers/half_blooming_six.png",
  backgroundImage4:"assets/images/englishNumbers/full_blooming_six.png",
  startPosition:const Offset(0.75, 0.15), 
  midTarget:const Offset(0.28, 0.70),      
  endTarget:const Offset(0.50, 0.60),      
  pathPoints:[
   const Offset(0.70, 0.15),
   const Offset(0.55, 0.00), 
   const Offset(0.35, 0.10),
    
    const Offset(0.28, 0.70),
    const Offset(0.35, 0.85), 
    const Offset(0.65, 0.85), 
    const Offset(0.78, 0.55), 
    const Offset(0.68, 0.50), 
    
    // --- THE FINISH ---
    const Offset(0.50, 0.50), // EndTarget (Hole)
  ],
  
);

final tracingNumberSeven= TracingQuestion(
  id: "number_7",
  numberValue: 7,
  audioPath:"numeric_en/kid-7.mp3",
  characterImage: 'assets/images/bee.png',
  backgroundImage1:"assets/images/englishNumbers/seed_curved_seven.png",
  backgroundImage2:"assets/images/englishNumbers/seed_seven.png",
  backgroundImage3:"assets/images/englishNumbers/half_blooming_seven.png",
  backgroundImage4:"assets/images/englishNumbers/full_blooming_seven.png",
  startPosition: const Offset(0.28, 0.15), 
  midTarget: const Offset(0.80, 0.15),      
  endTarget: const Offset(0.45, 0.85),  
  pathPoints:[
   const Offset(0.28, 0.15), 
    const Offset(0.55, 0.15), 
    const Offset(0.80, 0.15), 
    const Offset(0.60, 0.50), 
    const Offset(0.50, 0.70), 
    const Offset(0.45, 0.85), 
  ],
  
);

final tracingNumberEight= TracingQuestion(
  id: "number_8",
  numberValue: 8,
  audioPath:"numeric_en/kid-8.mp3",
  characterImage: 'assets/images/bee.png',
  backgroundImage1:"assets/images/englishNumbers/seed_curved_eight.png",
  backgroundImage2:"assets/images/englishNumbers/seed_eight.png",
  backgroundImage3:"assets/images/englishNumbers/half_blooming_eight.png",
  backgroundImage4:"assets/images/englishNumbers/full_blooming_eight.png",
  startPosition: const Offset(0.50, 0.10), 
  midTarget: const Offset(0.30, 0.75),      
  endTarget: const Offset(0.38, 0.12),   
  pathPoints:[
       
    const Offset(0.50, 0.10),
    const Offset(0.68, 0.20), 
    const Offset(0.72, 0.35), 
    const Offset(0.50, 0.48),
    const Offset(0.35, 0.48), 
    const Offset(0.30, 0.75),
    const Offset(0.30, 0.60), 
    const Offset(0.28, 0.72), 
    const Offset(0.45, 0.85), 
    const Offset(0.68, 0.78), 
    const Offset(0.78, 0.72), 
    const Offset(0.70, 0.58),
    const Offset(0.50, 0.48), 
    const Offset(0.30, 0.32),
    const Offset(0.38, 0.12)
  ],
  
);

final tracingNumberNine= TracingQuestion(
  id: "number_9",
  numberValue: 9,
  audioPath:"numeric_en/kid-9.mp3",
  characterImage: 'assets/images/bee.png',
  backgroundImage1:"assets/images/englishNumbers/seed_curved_nine.png",
  backgroundImage2:"assets/images/englishNumbers/seed_nine.png",
  backgroundImage3:"assets/images/englishNumbers/half_blooming_nine.png",
  backgroundImage4:"assets/images/englishNumbers/full_blooming_nine.png",
  startPosition: const Offset(0.45, 0.45), 
  midTarget: const Offset(0.68, 0.42),      
  endTarget: const Offset(0.35, 0.85),   
  pathPoints:[
       
  
    const Offset(0.45, 0.45), 
    const Offset(0.32, 0.30),
    const Offset(0.32, 0.15),
    const Offset(0.55, 0.05),
    const Offset(0.70, 0.25), 
    const Offset(0.70, 0.38),
    const Offset(0.68, 0.42), 

   
    const Offset(0.75, 0.62),  
    const Offset(0.68, 0.78),  
    const Offset(0.58, 0.85),  
    const Offset(0.35, 0.85),  
  ],
  
);