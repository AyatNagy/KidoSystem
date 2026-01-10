import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../Models/speak_question.dart';

class SpeakQuestionWidget extends StatefulWidget {
  final SpeakQuestion question;

  const SpeakQuestionWidget({super.key, required this.question});

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
      setState(() => isListening = true);
      _speech.listen(
        onResult: (result) {
          setState(() {
            spokenText = result.recognizedWords.toLowerCase();
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.question.questionText,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Image.asset(widget.question.image, height: 200),
        const SizedBox(height: 30),
        GestureDetector(
          onTap: isListening ? stopListening : startListening,
          child: CircleAvatar(
            radius: 40,
            backgroundColor: isListening ? Colors.red : Colors.blue,
            child: const Icon(
                Icons.mic,
                color: Colors.white,
                size: 40
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          spokenText,
          style: const TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}
