import 'package:flutter/material.dart';

abstract class DiscoveryItem {
  String get mainImage;
  String? get extraImage;
  String get soundPath;
  Color get primaryColor;
  Color get background;
}
