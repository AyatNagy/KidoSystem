import 'package:flutter/material.dart';
import 'package:kido/Widgets/Questions/draganddrop_question_widget.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import 'package:kido/data/level3/fruits/fridge_game_data.dart';
import 'package:kido/services/audio_service.dart';
import '../../../data/level3/fruits/fruits_discovery.dart';

class FridgeGamePage extends StatefulWidget {
  const FridgeGamePage({super.key});

  @override
  State<FridgeGamePage> createState() => _FridgeGamePageState();
}

class _FridgeGamePageState extends State<FridgeGamePage> {
  int _currentScore = 0;

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveProvider.of(context);

    // توليد بيانات اللعبة
    final fruitQuestion = FridgeGameLogic.generateFruitGame(
      fruitsDiscovery,
      responsive,
    );

    return Scaffold(
      backgroundColor: Colors.white, // لضمان عدم وجود خلفية سوداء
      body: SizedBox.expand(
        // لضمان ملء الشاشة بالكامل
        child: DragDropQuestionWidget(
          question: fruitQuestion,
          isExamMode: false,
          onAnswered: (answers) {
            if (answers.length > _currentScore) {
              AudioService.play(fileName: 'yaay.mp3');
            }
            setState(() {
              _currentScore = answers.length;
            });

            if (_currentScore == fruitsDiscovery.length) {
              _showWinCelebration();
            }
          },
        ),
      ),
    );
  }

  void _showWinCelebration() {
    AudioService.play(fileName: 'yaay.mp3');
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("🥳", style: TextStyle(fontSize: 50)),
                const Text(
                  "أحسنت يا بطل!",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("استمرار"),
                ),
              ],
            ),
          ),
    );
  }
}
