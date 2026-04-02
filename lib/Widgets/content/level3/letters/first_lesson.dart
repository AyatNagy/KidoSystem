import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../../../Models/level3/letters/first_letter.dart';

class FirstLesson extends StatefulWidget {
  final LetterModel model;
  final VoidCallback onNextPressed;

  const FirstLesson({
    super.key,
    required this.model,
    required this.onNextPressed,
  });

  @override
  State<FirstLesson> createState() => _FirstLessonState();
}

class _FirstLessonState extends State<FirstLesson> with SingleTickerProviderStateMixin {
  bool _isTapped = false;
  bool _showNextButton = false;
  late AnimationController _pulseController;
  final FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _initTts();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage("ar-EG");
    await _flutterTts.setPitch(1.2);
    await _flutterTts.setSpeechRate(0.5);
  }

  Future<void> _speak() async {
    await _flutterTts.speak(widget.model.audioName);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  void _handleInteraction() {
    HapticFeedback.heavyImpact();
    _speak();
    setState(() {
      _isTapped = true;
      _showNextButton = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final model = widget.model;

    return Scaffold(
      backgroundColor: model.bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Center(
                child: GestureDetector(
                  onTap: _handleInteraction,
                  child: AnimatedScale(
                    scale: _isTapped ? 1.05 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      height: size.height * 0.35,
                      width: size.width * 0.75,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: _isTapped ? model.activeBorder : model.circleColor,
                          width: 10,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(35.0),
                        child: Image.asset(model.animalPath, fit: BoxFit.contain),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              flex: 3,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: size.width * 0.45,
                    decoration: BoxDecoration(
                      color: model.circleColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Image.asset(
                    model.animalPath,
                    height: size.height * 0.22,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),

            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: _handleInteraction,
                      icon: Icon(Icons.volume_up_rounded, size: 60, color: model.activeBorder),
                    ),
                    if (_showNextButton)
                      ScaleTransition(
                        scale: Tween(begin: 1.0, end: 1.1).animate(_pulseController),
                        child: IconButton(
                          icon: const Icon(Icons.play_circle_fill_rounded, size: 90, color: Colors.green),
                          onPressed: widget.onNextPressed,
                        ),
                      )
                    else
                      const SizedBox(width: 90),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}