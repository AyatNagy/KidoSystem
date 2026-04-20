import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../../../Models/level3/letters/first_lesson.dart';
import '../../../puls_button.dart';

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

class _FirstLessonState extends State<FirstLesson> {
  bool _isTapped = false;
  bool _showNextButton = false;
  final FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _initTts();
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
    _flutterTts.stop();
    super.dispose();
  }

  void _handleInteraction() {
    HapticFeedback.heavyImpact();
    _speak();
    if (!_isTapped) {
      setState(() {
        _isTapped = true;
        _showNextButton = true;
      });
    }
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
                    scale: _isTapped ? 1.08 : 1.0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.elasticOut,
                    child: Container(
                      height: size.height * 0.35,
                      width: size.width * 0.75,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(
                          color: _isTapped ? model.activeBorder : Colors.white,
                          width: 8,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: model.activeBorder.withOpacity(0.2),
                            blurRadius: 25,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Image.asset(
                          model.letterPath,
                          fit: BoxFit.contain,
                        ),
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
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    width: size.width * 0.5,
                    decoration: BoxDecoration(
                      color: _isTapped
                          ? model.activeBorder.withOpacity(0.15)
                          : model.primaryColor,
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
                    GestureDetector(
                      onTap: _handleInteraction,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: model.activeBorder,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: model.activeBorder.withOpacity(0.4),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(
                            Icons.volume_up_rounded,
                            size: 50,
                            color: Colors.white
                        ),
                      ),
                    ),

                    if (_showNextButton)
                      PulseButton(
                        onPressed: widget.onNextPressed,
                        child: const Icon(
                          Icons.play_circle_fill_rounded,
                          size: 100,
                          color: Colors.green,
                        ),
                      )
                    else
                      const SizedBox(width: 100),
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