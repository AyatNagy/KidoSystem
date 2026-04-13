import 'package:flutter/material.dart';
import '../../../Models/level3/fruits/discoveryFruits.dart';

final List<FruitsModel> fruits_discovery = [

  FruitsModel(
      fruitPath: "assets/images/apple.png",
      audioName: "assets/audio/fruits/تفاحة.mp3",
      activeBorder: Colors.redAccent,
  ),

  FruitsModel(
      fruitPath: "assets/images/fruits/orange.png",
      audioName: "assets/audio/fruits/برتقال.mp3",
      activeBorder: Colors.orange,
  ),

  FruitsModel(
      fruitPath: 'assets/images/fruits/banana.png',
      audioName: 'assets/audio/fruits/موز.mp3',
      activeBorder: const Color(0xFFFFD600),
  ),

  FruitsModel(
      fruitPath: 'assets/images/fruits/grapes.png',
      audioName: 'assets/audio/fruits/عنب.mp3',
      activeBorder: const Color(0xFF9C27B0),
  ),

  FruitsModel(
      fruitPath: 'assets/images/fruits/strawbery.png',
      audioName: 'assets/audio/fruits/فراولة.mp3',
      activeBorder: const Color(0xFFFF1744),
  ),
];