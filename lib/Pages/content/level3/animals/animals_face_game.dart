// ignore_for_file: deprecated_member_use
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kido/Widgets/content/draganddrop.dart';
import 'package:kido/Widgets/content/success_overlay_widget.dart';
import 'package:kido/services/audio_service.dart';
import '../../../../data/content/level3/animals/animals_data.dart';
import '../../../../data/content/level3/animals/animals_faces_game_data.dart';

class AnimalFaceGamePage extends StatefulWidget {
  final int intialIndex;
  final VoidCallback onGameComplete;
  const AnimalFaceGamePage({
    super.key,
    required this.intialIndex,
    required this.onGameComplete,
  });

  @override
  State<AnimalFaceGamePage> createState() => _AnimalFaceGamePageState();
}

class _AnimalFaceGamePageState extends State<AnimalFaceGamePage> {
  late int currentIndex;
  bool showSuccess = false;
  Timer? hintTimer;
  String get animalNameAudio => animalsDiscovery[currentIndex].audioName;
  void playQuestionAudio() {
    AudioService.playSequence("animals/complete_face.mp3", animalNameAudio);
  }

  void startHintTimer() {
    hintTimer?.cancel();
    hintTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!showSuccess && mounted) {
        playQuestionAudio();
      } else {
        timer.cancel();
      }
    });
  }

  void handleSuccess(Map<String, String?> answers) {
    if (showSuccess) return;
    if (answers.isNotEmpty) {
      hintTimer?.cancel();
      setState(() => showSuccess = true);

      AudioService.playSequence("yaay.mp3", animalNameAudio);

      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) {
          widget.onGameComplete();
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    currentIndex = widget.intialIndex;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      playQuestionAudio();
      startHintTimer();
    });
  }

  @override
  void dispose() {
    hintTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //if (currentIndex >= AnimalsGameData.animalsQuestions.length) return const SizedBox();
    final currentQuestion = AnimalsGameData.animalsQuestions[currentIndex];
    final animalMedia = animalsDiscovery[currentIndex];
    final Color primaryColor = animalMedia.activeBorder;

    return Scaffold(
      body: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 800),
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(-0.3, -0.4),
                radius: 1.4,
                colors: [
                  primaryColor.withValues(alpha: 0.4),
                  primaryColor.withValues(alpha: 0.2),
                  Colors.white.withValues(alpha: 0.8),
                  const Color(0xFFF8F9FE),
                ],
                stops: const [0.0, 0.3, 0.6, 1.0],
              ),
            ),
          ),
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child:
                  !showSuccess
                      ? DragDropWidget(
                        key: ValueKey('game_$currentIndex'),
                        question: currentQuestion,
                        onAnswered: handleSuccess,
                        onWrongDrop:
                            () => AudioService.play(fileName: "wrong.mp3"),
                      )
                      : SuccessOverlay(
                        key: ValueKey('success_$currentIndex'),
                        image: animalMedia.animalPath,
                        title: '',
                        transform: Matrix4.identity()..scale(1.5),
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
