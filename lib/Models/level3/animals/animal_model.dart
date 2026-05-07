import 'package:flutter/material.dart';
import '../discovery.dart';

class AnimalsModel implements DiscoveryItem {
  final String animalPath;
  final String? image;
  final String audioName;
  final Color bgColor;
  final Color activeBorder;

  AnimalsModel({
    required this.animalPath,
    required this.audioName,
    this.image,
    this.bgColor=const Color(0xFFFDFCF0),
    this.activeBorder=Colors.orangeAccent,
  });

  @override
  String get mainImage=>animalPath;
  @override
  String get soundPath=>audioName;
  @override
  Color get primaryColor=>activeBorder;
  @override
  Color get background=>bgColor;
  @override
  String? get extraImage=>image;
}
