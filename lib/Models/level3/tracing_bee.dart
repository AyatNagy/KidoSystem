import 'package:flutter/material.dart';

class TracingQuestion {
  final String id;
  final String audioPath;
  final String backgroundImage1; //seed
  final String backgroundImage2; //seed2 
  final String backgroundImage3; //halfBloom
  final String backgroundImage4; //fullBloom
  final Offset startPosition;    //Percent (0.0 - 1.0)
  final Offset midTarget;        //The "Hole" percent
  final Offset endTarget;        //The "Finish" percent
  final List <Offset> pathPoints; 

  TracingQuestion({
    required this.id,
    required this.audioPath,
    required this.backgroundImage1,
    required this.backgroundImage2,
    required this.backgroundImage3,
    required this.backgroundImage4,
    required this.startPosition,
    required this.midTarget,
    required this.endTarget,
    required this.pathPoints,
  });
}

// Example Data for Number 1
final tracingNumberOne = TracingQuestion(
  id: "number_1",
  audioPath:"audio/numeric_en/kid-1.mp3",
  backgroundImage1: "assets/images/seed_curved_one.png",
  backgroundImage2: "assets/images/seed_one.png",
  backgroundImage3: "assets/images/half_blooming_one.png",
  backgroundImage4: "assets/images/full_blooming_one.png",
  startPosition: const Offset(0.25, 0.40), 
  midTarget: const Offset(0.50, 0.28),      
  endTarget: const Offset(0.50, 0.75),      
  pathPoints: [
    const Offset(0.28, 0.40), // Dash start
    const Offset(0.50, 0.28), // Top Hole (The Peak)
    const Offset(0.50, 0.52), // Mid vertical
    const Offset(0.50, 0.75), // Bottom Hole
  ],
);

final tracingNumberTwo = TracingQuestion(
  id: "number_2",
  audioPath:"audio/numeric_en/kid-2.mp3",
  backgroundImage1: "assets/images/seed_curved_two.png",
  backgroundImage2: "assets/images/seed_two.png",
  backgroundImage3: "assets/images/half_blooming_two.png",
  backgroundImage4: "assets/images/full_blooming_two.png",
  startPosition: const Offset(0.28, 0.32), 
  midTarget: const Offset(0.68, 0.42),      
  endTarget: const Offset(0.70, 0.78),      

  pathPoints: [
    const Offset(0.28, 0.32), // Start hook
    const Offset(0.40, 0.20), // Peak (Lifted from 0.24 to 0.20)
    const Offset(0.60, 0.22), // Right shoulder (Lifted from 0.28 to 0.22)
    const Offset(0.68, 0.42), // Mid target hole
    const Offset(0.45, 0.65), // Diagonal slide
    const Offset(0.30, 0.78), // Bottom-left corner
    const Offset(0.50, 0.78), // Middle of base
    const Offset(0.70, 0.78), // Final hole
  ],
);

  final tracingNumberThree = TracingQuestion(
  id: "number_3",
  audioPath:"audio/numeric_en/kid-3.mp3",
  backgroundImage1: "assets/images/seed_curved_three.png",
  backgroundImage2: "assets/images/seed_three.png",
  backgroundImage3: "assets/images/half_blooming_three.png",
  backgroundImage4: "assets/images/full_blooming_three.png",
  
  // Starting at the top-left hook of the first curve
  startPosition: const Offset(0.25, 0.28), 
  
  // MidTarget is the hole in the center "neck" of the 3
  midTarget: const Offset(0.48, 0.48),      
  
  // EndTarget is the hole at the bottom-left finish
  endTarget: const Offset(0.25, 0.72),      

  pathPoints: [
    // --- TOP CURVE ---
    const Offset(0.30, 0.28), // Start hook
    const Offset(0.40, 0.15), // Lifted top-left shoulder
    const Offset(0.55, 0.10), // Lifted top peak (decreased Y)
    const Offset(0.72, 0.25), // Adjusted right outer edge
    const Offset(0.48, 0.48), // MID HOLE (Center)

    // --- BOTTOM CURVE ---
    const Offset(0.75, 0.58), // Adjusted right outer edge (bottom)
    const Offset(0.55, 0.82), // Bottom peak (lowered Y slightly to match dirt)
    const Offset(0.38, 0.82), // Bottom-left corner
    const Offset(0.25, 0.72), // END HOLE
  ],

);

final tracingNumberFour = TracingQuestion(
  id: "number_4",
  audioPath:"audio/numeric_en/kid-4.mp3",
  backgroundImage1: "assets/images/seed_curved_four.png",
  backgroundImage2: "assets/images/seed_four.png",
  backgroundImage3: "assets/images/half_blooming_four.png",
  backgroundImage4: "assets/images/full_blooming_four.png",
  startPosition: const Offset(0.25, 0.02), 
  midTarget: const Offset(0.75, 0.60),      
  endTarget: const Offset(0.75, 0.90),      
  pathPoints: [
   const Offset(0.25, 0.02), // Start at the top left
    const Offset(0.25, 0.60), // Corner
    const Offset(0.75, 0.60), // End of horizontal (Intersection)

    // --- STROKE 2: The Long Vertical ---
    const Offset(0.75, 0.00), // "Lift" bee to the top of the vertical line
    const Offset(0.75, 0.40), 
    const Offset(0.75, 0.60), // Pass the intersection
    const Offset(0.75, 0.90), // END HOLE (Finish)
  ],
  
);

final tracingNumberFive = TracingQuestion(
  id: "number_5",
  audioPath:"audio/numeric_en/kid-5.mp3",
  backgroundImage1:"assets/images/seed_curved_five.png",
  backgroundImage2:"assets/images/seed_five.png",
  backgroundImage3:"assets/images/half_blooming_five.png",
  backgroundImage4:"assets/images/full_blooming_five.png",
  startPosition:const Offset(0.70, 0.10), 
  midTarget:const Offset(0.30, 0.40),      
  endTarget:const Offset(0.30, 0.85),      
  pathPoints:[
   const Offset(0.70, 0.10), // Start (Top Right)
  const Offset(0.30, 0.10), // Top Left Corner
  const Offset(0.30, 0.45), // Junction (MidTarget)
  const Offset(0.55, 0.45), // Top of the belly
  const Offset(0.75, 0.60), // Right outer edge
  const Offset(0.65, 0.85), // Bottom peak
  const Offset(0.30, 0.85), // END HOLE
  ],
  
);

final tracingNumberSix= TracingQuestion(
  id: "number_6",
  audioPath:"audio/numeric_en/kid-6.mp3",
  backgroundImage1:"assets/images/seed_curved_six.png",
  backgroundImage2:"assets/images/seed_six.png",
  backgroundImage3:"assets/images/half_blooming_six.png",
  backgroundImage4:"assets/images/full_blooming_six.png",
  startPosition:const Offset(0.75, 0.15), 
  midTarget:const Offset(0.28, 0.60),      
  endTarget:const Offset(0.50, 0.60),      
  pathPoints:[
   const Offset(0.70, 0.15), // Start tip
   const Offset(0.55, 0.00), // Top Peak
   const Offset(0.35, 0.10), // Mid-neck slide
    
    const Offset(0.28, 0.50), // MidTarget (Blue)
    const Offset(0.35, 0.85), // Bottom Curve
    const Offset(0.65, 0.85), // Bottom Right
    const Offset(0.78, 0.55), // Far Right Edge
    const Offset(0.68, 0.50), // Closing the top of the circle
    
    // --- THE FINISH ---
    const Offset(0.50, 0.50), // EndTarget (Hole)
  ],
  
);

final tracingNumberSeven= TracingQuestion(
  id: "number_7",
  audioPath:"audio/numeric_en/kid-7.mp3",
  backgroundImage1:"assets/images/seed_curved_seven.png",
  backgroundImage2:"assets/images/seed_seven.png",
  backgroundImage3:"assets/images/half_blooming_seven.png",
  backgroundImage4:"assets/images/full_blooming_seven.png",
  startPosition: const Offset(0.28, 0.15), 
  midTarget: const Offset(0.80, 0.15),      
  endTarget: const Offset(0.45, 0.85),  
  pathPoints:[
   const Offset(0.28, 0.15), // Start (Top Left)
    const Offset(0.55, 0.15), // Middle of horizontal bar
    const Offset(0.80, 0.15), // Top Right Corner (midTarget)
    const Offset(0.60, 0.50), // Middle of diagonal
    const Offset(0.50, 0.70), // Lower diagonal
    const Offset(0.45, 0.85), // Bottom (endTarget)
  ],
  
);

final tracingNumberEight= TracingQuestion(
  id: "number_8",
  audioPath:"audio/numeric_en/kid-8.mp3",
  backgroundImage1:"assets/images/seed_curved_eight.png",
  backgroundImage2:"assets/images/seed_eight.png",
  backgroundImage3:"assets/images/half_blooming_eight.png",
  backgroundImage4:"assets/images/full_blooming_eight.png",
  startPosition: const Offset(0.50, 0.10), 
  midTarget: const Offset(0.32, 0.75),      
  endTarget: const Offset(0.38, 0.12),   
  pathPoints:[
       
    const Offset(0.50, 0.10), // Start (Top Center)
    const Offset(0.68, 0.20), // Top-Right curve
    const Offset(0.72, 0.35), // Right edge of top circle
    const Offset(0.50, 0.48), // Intersection (Crossing the middle)
    const Offset(0.30, 0.60), // Top-Left curve of bottom circle
    const Offset(0.28, 0.72), // MID TARGET (The Left Hole)

    // --- STAGE 2: BOTTOM LOOP & RETURN ---
    const Offset(0.45, 0.85), // Bottom center-left
    const Offset(0.68, 0.78), // Bottom Right peak
    const Offset(0.78, 0.72), // Far Right edge of bottom circle
    const Offset(0.70, 0.58), // Top-Right curve of bottom circle
    const Offset(0.50, 0.48), // Crossing the intersection again
    const Offset(0.30, 0.32), // Upper-Left curve
    const Offset(0.38, 0.12), // END TARGET (Final Top-Left Hole)
  ],
  
);

final tracingNumberNine= TracingQuestion(
  id: "number_9",
  audioPath:"audio/numeric_en/kid-9.mp3",
  backgroundImage1:"assets/images/seed_curved_nine.png",
  backgroundImage2:"assets/images/seed_nine.png",
  backgroundImage3:"assets/images/half_blooming_nine.png",
  backgroundImage4:"assets/images/full_blooming_nine.png",
  startPosition: const Offset(0.45, 0.45), 
  midTarget: const Offset(0.68, 0.42),      
  endTarget: const Offset(0.35, 0.85),   
  pathPoints:[
       
   // --- STAGE 1: THE CIRCULAR HEAD (CLOCKWISE) ---
    const Offset(0.45, 0.45), // Start (Left side)
    const Offset(0.32, 0.30), // Stay on the left line while moving up
    const Offset(0.32, 0.15), // Top-Left curve
    const Offset(0.55, 0.05), // TOP PEAK
    const Offset(0.70, 0.25), // Right-side curve
    const Offset(0.70, 0.38), // Moving down the right side
    const Offset(0.68, 0.42), // MID TARGET (The junction hole)

    // --- STAGE 2: THE CURVED TAIL ---
    const Offset(0.75, 0.62), // Centered on the vertical stem
    const Offset(0.68, 0.78), // Beginning the curve
    const Offset(0.58, 0.85), // Bottom center
    const Offset(0.35, 0.85), // END TARGET (Finish hole)
  ],
  
);