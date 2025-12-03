import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:kido/Models/chioce_question.dart';
import 'package:kido/Widgets/Questiont/chioce_question_widget.dart';
import 'package:kido/Widgets/ResponsiveProvider.dart';
import 'package:kido/Widgets/custom_app_button.dart';

class ExamSkeletonScreen extends StatefulWidget {
  final String examId;

  const ExamSkeletonScreen({super.key, required this.examId});

  @override
  State<ExamSkeletonScreen> createState() => _ExamSkeletonScreenState();
}

class _ExamSkeletonScreenState extends State<ExamSkeletonScreen> {
  late List<ChoiceQuestion> questions;
  int currentIndex = 0;
  int score = 0;
  int? selectedChoiceIndex;

  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();

    questions =
        allChoiceQuestions.where((q) => q.examId == widget.examId).toList();

    selectedChoiceIndex = null;
  }

  Future<void> speakQuestion() async {
    await flutterTts.stop();
    flutterTts.setLanguage("en-US");
    flutterTts.setSpeechRate(0.6);
    flutterTts.setVolume(1.0);
    flutterTts.setPitch(1.0);
    flutterTts.awaitSpeakCompletion(false);
    await Future.delayed(const Duration(milliseconds: 100));
    flutterTts.speak(questions[currentIndex].questionText);
  }

  void handleChoiceSelected(int index) {
    setState(() {
      selectedChoiceIndex = index;
    });
  }

  void handleNext() {
    // 1) لو مفيش إجابة مختارة → امنعي الانتقال
    if (selectedChoiceIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please choose an answer first"),
          duration: Duration(seconds: 1),
        ),
      );
      return; // خروج من الدالة، ميتنقلش للسؤال اللي بعده
    }

    final currentQuestion = questions[currentIndex];

    // 2) حساب النتيجة
    if (selectedChoiceIndex == currentQuestion.correctIndex) {
      score++;
    }

    // 3) الانتقال للسؤال التالي
    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
        selectedChoiceIndex = null;
      });
    } else {
      // 4) لو الامتحان خلص
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text("Exam Finished"),
              content: Text("Your score is $score / ${questions.length}"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                ),
              ],
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);
    final currentQuestion = questions[currentIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: config.pagePadding,
          child: Column(
            children: [
              SizedBox(height: config.localHeight * 0.02),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Question ${currentIndex + 1}",
                  style: TextStyle(
                    fontSize: config.body,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              SizedBox(height: config.localHeight * 0.01),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      currentQuestion.questionText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: config.headline,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.volume_up, color: Colors.deepPurpleAccent),
                    onPressed: speakQuestion,
                  ),
                ],
              ),
              SizedBox(height: config.localHeight * 0.03),

              // ********** أهم تعديل هنا: مفتاح لكل سؤال **********
              Expanded(
                child: ChoiceQuestionWidget(
                  key: ValueKey(currentIndex), // ← reset تلقائي
                  question: currentQuestion,
                  onSelected: handleChoiceSelected,
                ),
              ),

              SizedBox(height: config.localHeight * 0.02),
              CustomGradientButton(
                title: "Next",
                onPressed: handleNext,
                width: double.infinity,
                borderRadius: 30,
                fontSize: config.title,
                colors: const [Color(0xfff06292), Color(0xffff8a65)],
              ),
              SizedBox(height: config.localHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}
