import 'package:flutter/material.dart';
import 'package:kido/Models/level3/animals/animal_model.dart';
import 'package:kido/constants.dart';

final List<AnimalsModel> animalsDiscovery = [
  AnimalsModel(
    image: 'assets/images/animals/cat.png',
    animalPath: "assets/images/animals/cat.gif",
    audioName: "animals/cat_arabic.mp3",
    activeBorder: AppColors.kidoRed,
  ),

  AnimalsModel(
    image: 'assets/images/animals/dog.png',
    animalPath: "assets/images/animals/dog.gif",
    audioName: "animals/dog_arabic.mp3",
    activeBorder: AppColors.kidoOrange,
  ),

  AnimalsModel(
    image: 'assets/images/animals/duck.png',
    animalPath: "assets/images/animals/duck.gif",
    audioName: 'animals/duck_arabic.mp3',
    activeBorder: AppColors.kidoYellow,
  ),

  AnimalsModel(
    image: 'assets/images/animals/horse.png',
    animalPath: "assets/images/animals/horse.gif",
    audioName: 'animals/horse_arabic.mp3',
    activeBorder: const Color(0xFF9C27B0),
  ),

  AnimalsModel(
    image: 'assets/images/animals/lion.png',
    animalPath: "assets/images/animals/lion.gif",
    audioName: 'animals/lion_arabic.mp3',
    activeBorder: const Color(0xFFFF1744),
  ),

  AnimalsModel(
    image: 'assets/images/animals/rabbit.png',
    animalPath: "assets/images/animals/rabbit.gif",
    audioName: 'animals/rabbit_arabic.mp3',
    activeBorder: AppColors.kidoGreen,
  ),
];
