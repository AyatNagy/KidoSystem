import 'package:flutter/material.dart';
import '../../../Models/level3/fruits/pixel_fruits.dart';

final List<PixelFruitModel> fruits = [

  PixelFruitModel(
    name: "Apple",
    image: "assets/images/apple.png",
    sound: "assets/audio/fruits/تفاحة.mp3",
    fruitColor: Colors.redAccent,
    gridSize: 8,
    fruitShapeIndices: [19, 20, 26, 27, 28, 29, 34, 35, 36, 37, 43, 44],
  ),

  PixelFruitModel(
    name: "Orange",
    image: "assets/images/fruits/orange.png",
    sound: "assets/audio/fruits/برتقال.mp3",
    fruitColor: Colors.orange,
    gridSize: 8,
    fruitShapeIndices: [19, 20, 26, 27, 28, 29, 34, 35, 36, 37, 43, 44],
  ),

  PixelFruitModel(
    name: "Banana",
    image: "assets/images/fruits/banana.png",
    sound: "assets/audio/fruits/موز.mp3",
    fruitColor: const Color(0xFFFFD600),
    gridSize: 8,
    fruitShapeIndices: [13, 20, 21, 27, 28, 35, 36, 43, 44, 51, 58],
  ),

  PixelFruitModel(
    name: "Grapes",
    image: "assets/images/fruits/grapes.png",
    sound: "assets/audio/fruits/عنب.mp3",
    fruitColor: const Color(0xFF9C27B0),
    gridSize: 8,
    fruitShapeIndices: [11, 19, 20, 26, 27, 28, 34, 35, 36, 37, 43, 44, 52],
  ),

  PixelFruitModel(
    name: "Strawberry",
    image: "assets/images/fruits/strawbery.png",
    sound: "assets/audio/fruits/فراولة.mp3",
    fruitColor: const Color(0xFFFF1744),
    gridSize: 8,
    fruitShapeIndices: [11, 12, 18, 19, 20, 21, 26, 27, 28, 29, 35, 36, 44],
  ),

  PixelFruitModel(
    name: "Watermelon",
    image: "assets/images/fruits/watermelon.png",
    sound: "assets/audio/fruits/بطيخ.mp3",
    fruitColor: const Color(0xFF00C853),
    gridSize: 8,
    fruitShapeIndices: [
      17, 18, 19, 20, 21, 22,
      25, 26, 27, 28, 29, 30,
      34, 35, 36, 37,
      43, 44
    ],
  ),
];