import 'package:flutter/material.dart';

abstract class PixelItem {
  String get title;
  String get mainImage;
  String get soundPath;
  Color get primaryColor;
  int get grid;
  List<int> get shapeIndices;
}