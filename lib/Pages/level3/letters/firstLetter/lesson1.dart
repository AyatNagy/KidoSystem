import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';

class LetterLesson1 extends StatefulWidget {
  const LetterLesson1({super.key});

  @override
  State<LetterLesson1> createState() => _LetterLesson1State();
}

class _LetterLesson1State extends State<LetterLesson1> with SingleTickerProviderStateMixin {
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

  Future<void> _speakLetter() async {
    await _flutterTts.speak("ألف");
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  void _onLetterTap() {
    HapticFeedback.heavyImpact();
    _speakLetter();
    setState(() {
      _isTapped = !_isTapped;
      _showNextButton = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFFDFCF0),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Center(
                child: GestureDetector(
                  onTap: _onLetterTap,
                  child: AnimatedScale(
                    scale: _isTapped ? 1.05 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      height: screenHeight * 0.4,
                      width: screenWidth * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: _isTapped ? Colors.orangeAccent : Colors.amberAccent,
                          width: 12,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Image.asset(
                          'assets/images/arabicLetters/letterأ.png',
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
                  Container(
                    width: screenWidth * 0.5,
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Image.asset(
                    'assets/images/arabicLetters/rabbit.png',
                    height: screenHeight * 0.25,
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
                      onTap: _onLetterTap,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.4),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.volume_up_rounded, size: 50, color: Colors.white),
                      ),
                    ),
                    if (_showNextButton)
                      ScaleTransition(
                        scale: Tween(begin: 1.0, end: 1.2).animate(_pulseController),
                        child: IconButton(
                          icon: const Icon(Icons.play_circle_fill_rounded, size: 90, color: Colors.green),
                          onPressed: () => print("Next Lesson"),
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