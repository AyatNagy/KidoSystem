import 'dart:ui';

import 'package:flutter/material.dart' show Colors;
import '../../../constants.dart';
import '../discovery.dart';

class LetterModel implements DiscoveryItem {
  final String letterPath;
  final String animalPath;
  final String audioName;
  final Color bgColor;
  final Color activeBorder;

  LetterModel({
    required this.letterPath,
    required this.animalPath,
    required this.audioName,
    Color? bgColor,
    this.activeBorder = Colors.orangeAccent,
  }) : this.bgColor = bgColor ?? AppColors.kidoColors[5];

  @override String get mainImage => letterPath;
  @override String? get extraImage => animalPath;
  @override String get soundPath => audioName;
  @override Color get primaryColor => activeBorder;
  @override Color get background => bgColor;
}