// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:kido/constants.dart';
import 'package:kido/services/audio_service.dart';
import 'package:lottie/lottie.dart';
import '../../../Widgets/content/draganddrop.dart';
import '../../../data/level1/bunny_feed.dart';

class BunnyFeedingGame extends StatefulWidget {
  const BunnyFeedingGame({super.key});

  @override
  State<BunnyFeedingGame> createState() => _BunnyFeedingGameState();
}

class _BunnyFeedingGameState extends State<BunnyFeedingGame> {
  bool isGameWon = false;
  int carrotsPlaced = 0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/level1/carrot-bg.png',
              fit: BoxFit.cover,
            ),
          ),
          DragDropWidget(
            question: bunnyQuestion,
            onDragStart: () => AudioService.play(fileName: 'drag.mp3'),
            onWrongDrop: () {
              AudioService.play(fileName: 'wrong.mp3');
            },
            onAnswered: (answers) {
              if (answers.length > carrotsPlaced) {
                AudioService.play(fileName: 'pop.mp3');
                setState(() => carrotsPlaced = answers.length);
              }
              if (answers.length == bunnyQuestion.items.length) {
                setState(() => isGameWon = true);
                AudioService.play(fileName: 'yaay.mp3');
              }
            },
          ),
          if (isGameWon)
            Positioned.fill(
              child: Lottie.asset(
                'assets/lottie/confetti.json',
                fit: BoxFit.cover
              ),
            ),
        ],
      ),
    );
  }
}