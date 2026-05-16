// ignore_for_file: deprecated_member_use
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kido/Models/level1/matching_model.dart';
import 'package:kido/Widgets/content/choise_item_widget.dart';
import 'package:kido/services/audio_service.dart';
import 'package:lottie/lottie.dart';
import '../../../data/content/level1/matching_data.dart';

class MatchingPracticePage extends StatefulWidget {
  const MatchingPracticePage({super.key});

  @override
  State<MatchingPracticePage> createState() => _MatchingPracticePageState();
}

class _MatchingPracticePageState extends State<MatchingPracticePage>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  bool isCelebrating = false;
  bool isLocked = false;
  bool canAnimate = false;
  List<String> wrongSelections = [];

  Timer? hintTimer;
  late AnimationController hintController;
  late MatchingLessonData currentData;

  @override
  void initState() {
    super.initState();
    hintController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _loadLevel();
  }

  void _loadLevel() {
    setState(() {
      currentData = MatchingRepository.levels[currentIndex];
      wrongSelections.clear();
      isLocked = false;
      isCelebrating = false;
      canAnimate = false;
    });

    _playLevelFlow();
  }

  void _playLevelFlow() {
    AudioService.play(fileName: currentData.questionAudio);
    Timer(const Duration(seconds: 5), () {
      if (mounted && !isCelebrating) {
        setState(() => canAnimate = true);
        hintController.repeat(reverse: true);
      }
    });

    hintTimer?.cancel();
    hintTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!isCelebrating && !isLocked) {
        AudioService.play(fileName: currentData.questionAudio);
      } else {
        timer.cancel();
      }
    });
  }

  void handleAnswer(bool isCorrect) async {
    if (isLocked) return;

    if (isCorrect) {
      setState(() {
        isLocked = true;
        isCelebrating = true;
      });

      hintTimer?.cancel();
      AudioService.stop();
      AudioService.play(fileName: "yaay.mp3");

      await Future.delayed(const Duration(seconds: 3));

      if (currentIndex < MatchingRepository.levels.length - 1) {
        currentIndex++;
        _loadLevel();
      } else {
        if (mounted) Navigator.pop(context);
      }
    } else {
      setState(() {
        if (!wrongSelections.contains("wrong")) {
          wrongSelections.add("wrong");
        }
      });
    }
  }

  @override
  void dispose() {
    hintTimer?.cancel();
    hintController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child:
                currentData.backgroundImage != null
                    ? Image.asset(
                      currentData.backgroundImage!,
                      fit: BoxFit.cover,
                    )
                    : Container(color: Colors.white),
          ),
          Column(
            children: [
              const SizedBox(height: 60),

              Expanded(
                flex: 6,
                child: Center(
                  child: Image.asset(
                    currentData.targetGif,
                    height: 350,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ChoiceItem(
                      image: currentData.wrongImage,
                      isWrong: wrongSelections.contains("wrong"),
                      canAnimate: false,
                      animation: hintController,
                      onTap: () => handleAnswer(false),
                      transform: Matrix4.identity(),
                      height: 120,
                    ),

                    ChoiceItem(
                      image: currentData.correctImage,
                      isWrong: false,
                      canAnimate: canAnimate,
                      animation: hintController,
                      onTap: () => handleAnswer(true),
                      transform:
                          Matrix4.identity()
                            ..scale(1.0 + (0.1 * hintController.value)),
                      height: 120,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
          if (isCelebrating)
            IgnorePointer(
              child: Lottie.asset(
                'assets/lottie/confetti.json',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
        ],
      ),
    );
  }
}
