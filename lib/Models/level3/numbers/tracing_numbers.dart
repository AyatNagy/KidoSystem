import 'package:flutter/material.dart';

class TracingQuestion{

   final String id;
   final int numberValue;
  final String audioPath;
  final String characterImage;
  final String backgroundImage1; 
  final String backgroundImage2; 
  final String backgroundImage3; 
  final String backgroundImage4; 
  final Offset startPosition;    
  final Offset midTarget;        
  final Offset endTarget;        
  final List <Offset> pathPoints;

  TracingQuestion({

    required this.id,
    required this.numberValue,
    required this.audioPath,
    required this.characterImage,
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