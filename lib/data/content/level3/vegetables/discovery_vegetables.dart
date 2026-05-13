import 'package:flutter/material.dart';
import 'package:kido/constants.dart';
import '../../../../Models/level3/fruits/discovery_fruits.dart';

final List<FruitsModel> vegetablesDiscovery = [
  FruitsModel(
    fruitPath: "assets/gif/broccli.gif",
    audioName: "assets/audio/fruits/brokoli.mp3",
    activeBorder: AppColors.kidoGreen,
  ),

  FruitsModel(
    fruitPath: "assets/gif/carrot.gif",
    audioName: "assets/audio/fruits/carrot.mp3",
    activeBorder: AppColors.kidoOrange,
  ),

  FruitsModel(
    fruitPath: 'assets/gif/chili_pepper.gif',
    audioName: 'assets/audio/fruits/papper.mp3',
    activeBorder: AppColors.kidoRed,
  ),

  FruitsModel(
    fruitPath: 'assets/gif/onion.gif',
    audioName: 'assets/audio/fruits/onion.mp3',
    activeBorder: AppColors.purpleMain,
  ),

  FruitsModel(
    fruitPath: 'assets/gif/tomato.gif',
    audioName: 'assets/audio/fruits/tomato.mp3',
    activeBorder: const Color(0xFFFF1744),
  ),
];
