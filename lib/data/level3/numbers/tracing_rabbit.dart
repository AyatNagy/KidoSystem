import 'package:flutter/material.dart';
import'package:kido/Models/level3/numbers/tracing_numbers.dart';

 final tracingNumberTwoArab = TracingQuestion(
  id: 'arabic_two',
  audioPath: 'audio/numeric_ar/kid-2.mp3',
  characterImage: 'assets/images/rabbit_tracing.png',
  backgroundImage1: 'assets/images/arabicNumbers/seed_curved_two.png', // Start (Soil & Seed)
  backgroundImage2: 'assets/images/arabicNumbers/seed_two.png',        // Mid (Sprouting)
  backgroundImage3: 'assets/images/arabicNumbers/half_blooming_two.png', // Half Bloom
  backgroundImage4: 'assets/images/arabicNumbers/full_blooming_two.png', // Full Garden
  
  // Starting point: Top-Right corner of the "٢"
  startPosition: const Offset(0.72, 0.22), 
  
  // Mid Target: The "bend" where the rabbit turns downward
  midTarget: const Offset(0.32, 0.25),
  
  // End Target: The bottom where the carrot is buried
  endTarget: const Offset(0.52, 0.82),
  
  // Detailed path for smooth movement
  pathPoints: [
    const Offset(0.72, 0.22), // Start at top right
    const Offset(0.55, 0.30), // Move left across the top
    const Offset(0.32, 0.25), // The sharp corner (Mid point)
    const Offset(0.48, 0.45), // Slanting down
    const Offset(0.65, 0.65), // Following the curve
    const Offset(0.52, 0.82), // Reaching the carrot (End point)
  ],
);

final tracingNumberThreeArab = TracingQuestion(
  id: 'arabic_three',
  audioPath: 'audio/numeric_ar/kid-3.mp3',
   characterImage: 'assets/images/rabbit_tracing.png',
  backgroundImage1: 'assets/images/arabicNumbers/seed_curved_three.png',   // Initial state
  backgroundImage2: 'assets/images/arabicNumbers/seed_three.png',          // Sprouting stage
  backgroundImage3: 'assets/images/arabicNumbers/half_blooming_three.png', // Half Bloom
  backgroundImage4: 'assets/images/arabicNumbers/full_blooming_three.png', // Full Garden
  
  // Starting point: Far right "tooth" of the ٣
  startPosition: const Offset(0.78, 0.22), 
  
  // Mid Target: The middle "tooth" to ensure they complete the top strokes
  midTarget: const Offset(0.50, 0.22),
  
  // End Target: The bottom where the carrot is buried
  endTarget: const Offset(0.62, 0.85),
  
  // Detailed path following the three peaks and the tail
  pathPoints: [
    const Offset(0.78, 0.22), // Start at Right peak
    const Offset(0.68, 0.35), // Dip down from first peak
    const Offset(0.50, 0.22), // Middle peak (MidTarget)
    const Offset(0.40, 0.35), // Dip down from second peak
    const Offset(0.38, 0.25), // Left peak
    const Offset(0.55, 0.45), // Turning into the vertical tail
    const Offset(0.58, 0.65), // Sliding down
    const Offset(0.62, 0.85), // Reaching the carrot (EndTarget)
  ],
);

final tracingNumberFourArab = TracingQuestion(
  id: 'arabic_four',
  audioPath: 'audio/numeric_ar/kid-4.mp3',
  characterImage: 'assets/images/rabbit_tracing.png',
  backgroundImage1: 'assets/images/arabicNumbers/seed_curved_four.png',   // Initial state
  backgroundImage2: 'assets/images/arabicNumbers/seed_four.png',          // Sprouting stage
  backgroundImage3: 'assets/images/arabicNumbers/half_blooming_four.png', // Half Bloom
  backgroundImage4: 'assets/images/arabicNumbers/full_blooming_four.png', // Full Garden
  
  // Starting point: Top-right tip of the first curve
  startPosition: const Offset(0.68, 0.10), 
  
  // Mid Target: The middle "point" where the two curves meet
  midTarget: const Offset(0.68, 0.45),
  
  // End Target: The bottom-right where the carrot is buried
  endTarget: const Offset(0.75, 0.82),
  
  // Detailed path for a smooth zig-zag movement
  pathPoints: [
    const Offset(0.68, 0.10), // Start at top right
    const Offset(0.40, 0.20), // First curve: far left peak
    const Offset(0.35, 0.35), // Rounding the first bend
    const Offset(0.68, 0.45), // Middle junction (MidTarget)
    const Offset(0.68, 0.45), // Second curve: far left peak
    const Offset(0.38, 0.75), // Rounding the final bend
    const Offset(0.55, 0.78), // Moving towards the carrot
    const Offset(0.75, 0.82), // Reaching the carrot (EndTarget)
  ],
);


final tracingNumberFiveArab = TracingQuestion(
  id: 'arabic_five',
  audioPath: 'audio/numeric_ar/kid-5.mp3',
  characterImage: 'assets/images/rabbit_tracing.png',
  backgroundImage1: 'assets/images/arabicNumbers/seed_curved_five.png',   // Initial state
  backgroundImage2: 'assets/images/arabicNumbers/seed_five.png',          // Sprouting stage
  backgroundImage3: 'assets/images/arabicNumbers/half_blooming_five.png', // Half Bloom
  backgroundImage4: 'assets/images/arabicNumbers/full_blooming_five.png', // Full Garden
 // Start exactly where the blue line begins
  startPosition: const Offset(0.22, 0.50), 
  
  // Mid Target: The Top Carrot
  midTarget: const Offset(0.90, 0.35),

  // End Target: The Bottom Carrot
  endTarget: const Offset(0.30, 0.82),
  
  pathPoints: [
    const Offset(0.22, 0.50), // START (Left Center)
    const Offset(0.22, 0.40), // ANCHOR 1: Force movement UP immediately
    const Offset(0.25, 0.25), // ANCHOR 2: Climbing the top-left shoulder
    const Offset(0.55, 0.10), // ANCHOR 3: Rounding toward the top
    const Offset(0.90, 0.35), // MID TARGET (Top Carrot)
    const Offset(0.90,0.40),
    const Offset(0.90,0.45),
    const Offset(0.90, 0.22), // Top-right shoulder
    const Offset(0.90, 0.50), // Right center
    const Offset(0.75, 0.80), // Bottom-right curve
    const Offset(0.30, 0.82), // BOTTOM Carrot (EndTarget)
  ],
);






