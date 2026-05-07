// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../Models/exams/speak_question.dart';
import '../responsive_provider.dart';

class SpeakQuestionWidget extends StatefulWidget {
  final SpeakQuestion question;
  final Function(String) onAnswered;

  const SpeakQuestionWidget({
    super.key,
    required this.question,
    required this.onAnswered,
  });

  @override
  State<SpeakQuestionWidget> createState() => _SpeakQuestionWidgetState();
}

class _SpeakQuestionWidgetState extends State<SpeakQuestionWidget> {
  late stt.SpeechToText _speech;
  String spokenText = "";
  bool isListening = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() {
        isListening = true;
        spokenText = "";
      });
      _speech.listen(
        localeId: 'ar-EG',
        onResult: (result) {
          setState(() {
            spokenText = result.recognizedWords;
            widget.onAnswered(spokenText);
          });
        },
      );
    }
  }

  void stopListening() {
    _speech.stop();
    setState(() => isListening = false);
  }

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: config.imageHeight(0.3),
            width: config.localWidth * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset(widget.question.image, fit: BoxFit.contain),
            ),
          ),

          SizedBox(height: config.localHeight * 0.04),

          GestureDetector(
            onTap: isListening ? stopListening : startListening,
            child: Container(
              width: config.localWidth * 0.25,
              height: config.localWidth * 0.25,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors:
                      isListening
                          ? [Colors.redAccent, Colors.red]
                          : [
                            const Color(0xffffB74D),
                            const Color(0xffff8A65),
                            const Color(0xfff06292),
                          ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isListening ? Colors.red : const Color(0xfff06292))
                        .withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(
                isListening ? Icons.stop_rounded : Icons.mic_rounded,
                color: Colors.white,
                size: config.localWidth * 0.12,
              ),
            ),
          ),

          SizedBox(height: config.localHeight * 0.03),

          if (spokenText.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xfffce4ec),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xfff06292).withOpacity(0.2),
                ),
              ),
              child: Text(
                spokenText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: config.title,
                  color: const Color(0xfff06292),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          SizedBox(height: config.localHeight * 0.02),
        ],
      ),
    );
  }
}
