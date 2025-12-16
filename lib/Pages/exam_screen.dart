import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:kido/Models/chioce_question.dart';
import 'package:kido/Models/draw_question.dart';
import 'package:kido/Widgets/Questiont/chioce_question_widget.dart';
import 'package:kido/Widgets/Questiont/draw_question_widget.dart';
import 'package:kido/Widgets/ResponsiveProvider.dart';
import 'package:kido/Widgets/custom_app_button.dart';

enum QuestionType { choice, drawing }

class ExamQuestion {
  final QuestionType type;
  final dynamic data;

  ExamQuestion({
    required this.type,
    required this.data,
  });
}

class ExamSkeletonScreen extends StatefulWidget {
  final String examId;

  const ExamSkeletonScreen({
    super.key,
    required this.examId,
  });

  @override
  State<ExamSkeletonScreen> createState() => _ExamSkeletonScreenState();
}

class _ExamSkeletonScreenState extends State<ExamSkeletonScreen> {
  late List<ExamQuestion> examQuestions;
  int currentIndex = 0;
  int score = 0;
  int? selectedChoiceIndex;
  List<Offset> drawnPoints = [];
  bool drawingAnswered = false;

  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();

    examQuestions = [
      ...allChoiceQuestions
          .where((q) => q.examId.contains(widget.examId))
          .map((q) => ExamQuestion(type: QuestionType.choice, data: q)),
      ...allDrawingQuestions
          .where((q) => q.examId.contains(widget.examId))
          .map((q) => ExamQuestion(type: QuestionType.drawing, data: q)),
    ];

    selectedChoiceIndex = null;
  }

  Future<void> speakQuestion(String text) async {
    await flutterTts.stop();
    flutterTts.setLanguage("en-US");
    flutterTts.setSpeechRate(0.6);
    flutterTts.setVolume(1.0);
    flutterTts.setPitch(1.0);

    await Future.delayed(const Duration(milliseconds: 150));
    flutterTts.speak(text);
  }

  bool checkDrawingSoft(String targetShape, List<Offset> points) {
    if (points.length < 15) return false;

    if (targetShape == "Circle") {
      return _isCircleSoft(points);
    }

    if (targetShape == "V-shape") {
      return _isVSoft(points);
    }

    return false;
  }

  bool _isCircleSoft(List<Offset> points) {
    double avgX = points.map((p) => p.dx).reduce((a, b) => a + b) / points.length;
    double avgY = points.map((p) => p.dy).reduce((a, b) => a + b) / points.length;
    Offset center = Offset(avgX, avgY);

    List<double> distances = points.map((p) => (p - center).distance).toList();
    double avgDist = distances.reduce((a, b) => a + b) / distances.length;

    double deviation = distances.map((d) => (d - avgDist).abs()).reduce((a, b) => a + b) / distances.length;

    return deviation < 50;
  }

  bool _isVSoft(List<Offset> points) {
    if (points.length < 20) return false;

    int mid = points.length ~/ 2;
    final left = points.sublist(0, mid);
    final right = points.sublist(mid);

    double angleLeft = _lineAngle(left.first, left.last);
    double angleRight = _lineAngle(right.first, right.last);

    double angleDiff = (angleLeft - angleRight).abs();

    return angleDiff > 20 && angleDiff < 160;
  }

  double _lineAngle(Offset a, Offset b) {
    return (b - a).direction * 180 / 3.14159;
  }

  void handleChoiceSelected(int index) {
    final examQuestion = examQuestions[currentIndex];
    final q = examQuestion.data as ChoiceQuestion;

    setState(() {
      selectedChoiceIndex = index;
    });

    if (q.colors != null && q.correctIndex != null && index == q.correctIndex) {
      score++;
    }
  }

  void handleDrawingUpdate(List<Offset> points) {
    setState(() {
      drawnPoints = points;
      drawingAnswered = points.isNotEmpty;
    });
  }

  void clearDrawing() {
    setState(() {
      drawnPoints.clear();
      drawingAnswered = false;
    });
  }

  void handleNext() {
    final examQuestion = examQuestions[currentIndex];

    if (examQuestion.type == QuestionType.choice) {
      final q = examQuestion.data as ChoiceQuestion;

      if (selectedChoiceIndex == null) {
        _showSnack("Please choose an answer first");
        return;
      }

      if (q.choices != null && q.correctIndex != null && selectedChoiceIndex == q.correctIndex) {
        score++;
      }
    }

    if (examQuestion.type == QuestionType.drawing) {
      if (!drawingAnswered) {
        _showSnack("Please draw your answer first");
        return;
      }

      bool correct = checkDrawingSoft(examQuestion.data.targetShape, drawnPoints);
      if (correct) score++;
    }

    if (currentIndex < examQuestions.length - 1) {
      setState(() {
        currentIndex++;
        selectedChoiceIndex = null;
        drawnPoints.clear();
        drawingAnswered = false;
      });
    } else {
      _finishExam();
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _finishExam() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Exam Finished"),
        content: Text("Your score is $score / ${examQuestions.length}"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);
    final examQuestion = examQuestions[currentIndex];
    final questionText = examQuestion.type == QuestionType.choice
        ? (examQuestion.data as ChoiceQuestion).questionText
        : (examQuestion.data as DrawingQuestion).questionText;

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
                      questionText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: config.headline,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.volume_up, color: Colors.deepPurpleAccent),
                    onPressed: () => speakQuestion(questionText),
                  ),
                ],
              ),
              SizedBox(height: config.localHeight * 0.03),
              Expanded(
                child: examQuestion.type == QuestionType.choice
                    ? ChoiceQuestionWidget(
                  key: ValueKey("choice_$currentIndex"),
                  question: examQuestion.data,
                  onSelected: handleChoiceSelected,
                )
                    : DrawingQuestionWidget(
                  key: ValueKey("drawing_$currentIndex"),
                  question: examQuestion.data,
                  onDrawingUpdate: handleDrawingUpdate,
                  onClear: clearDrawing,
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
