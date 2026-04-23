import 'package:flutter/material.dart';
import '../pixel.dart';

class PixelFruitModel implements PixelItem {
  final String name;
  final String image;
  final String sound;
  final Color fruitColor;
  int gridSize;
  List<int> fruitShapeIndices;

  PixelFruitModel({
    required this.name,
    required this.image,
    required this.sound,
    required this.fruitColor,
    required this.gridSize,
    required this.fruitShapeIndices,
  });

  @override
  String get title => name;
  @override
  String get mainImage => image;
  @override
  String get soundPath => sound;
  @override
  Color get primaryColor => fruitColor;
  @override
  int get grid => gridSize;
  @override
  List<int> get shapeIndices => fruitShapeIndices;
}
