import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:kido/Models/chioce_question.dart';
import 'package:kido/Models/draw_question.dart';
import 'package:kido/Models/draganddrop_question.dart';
import 'package:kido/Pages/parent_home_page.dart';
import 'package:kido/Widgets/Questions/chioce_question_widget.dart';
import 'package:kido/Widgets/Questions/draw_question_widget.dart';
import 'package:kido/Widgets/Questions/draganddrop_question_widget.dart';
import 'package:kido/Widgets/ResponsiveProvider.dart';
import 'package:kido/Widgets/custom_app_button.dart';

enum QuestionType {
  choice,
  drawing,
  dragDrop
}

class ExamQuestion {
  final QuestionType type;
  final dynamic data;

  ExamQuestion({required this.type, required this.data});
}

class ExamSkeletonScreen extends StatefulWidget {
  final String examId;

  const ExamSkeletonScreen({super.key, required this.examId});

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
  Map<String, String?> dragAnswers = {};

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
      ...allDragDropQuestions
          .where((q) => q.examId.contains(widget.examId))
          .map((q) => ExamQuestion(type: QuestionType.dragDrop, data: q)),
    ];
  }

  Future<void> speakQuestion(String text) async {
    await flutterTts.stop();
    flutterTts.setLanguage("ar-EG");
    flutterTts.setSpeechRate(0.4);
    flutterTts.setVolume(1.0);
    flutterTts.setPitch(1.1);
    await Future.delayed(const Duration(milliseconds: 100));
    flutterTts.speak(text);
  }

  bool checkDrawingSoft(String targetShape, List<Offset> points) {
    if (points.length < 15) return false;
    if (targetShape == "Circle") return _isCircleSoft(points);
    if (targetShape == "V-shape") return _isVSoft(points);
    return false;
  }

  bool _isCircleSoft(List<Offset> points) {
    double avgX =
        points.map((p) => p.dx).reduce((a, b) => a + b) / points.length;
    double avgY =
        points.map((p) => p.dy).reduce((a, b) => a + b) / points.length;
    Offset center = Offset(avgX, avgY);

    List<double> distances = points.map((p) => (p - center).distance).toList();
    double avgDist = distances.reduce((a, b) => a + b) / distances.length;
    double deviation =
        distances.map((d) => (d - avgDist).abs()).reduce((a, b) => a + b) /
        distances.length;
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

  double _lineAngle(Offset a, Offset b) => (b - a).direction * 180 / 3.14159;

  void handleChoiceSelected(int index) {
    setState(() {
      selectedChoiceIndex = index;
    });
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

    // Choice Question
    if (examQuestion.type == QuestionType.choice) {
      final q = examQuestion.data as ChoiceQuestion;
      if (selectedChoiceIndex == null) {
        _showSnack("Please choose an answer first");
        return;
      }
      if (q.correctIndex != null && selectedChoiceIndex == q.correctIndex)
        score++;
    }

    // Drawing Question
    if (examQuestion.type == QuestionType.drawing) {
      if (!drawingAnswered) {
        _showSnack("Please draw your answer first");
        return;
      }
      if (checkDrawingSoft(examQuestion.data.targetShape, drawnPoints)) score++;
    }

    // Drag & Drop Question
    if (examQuestion.type == QuestionType.dragDrop) {
      final q = examQuestion.data as DragDropQuestion;
      bool allCorrect = q.items.every((item) {
        final correctTargets =
            q.targets
                .where((t) => t.acceptedItemIds.contains(item.id))
                .map((t) => t.id)
                .toList();
        return correctTargets.contains(dragAnswers[item.id]);
      });
      if (allCorrect) score++;
    }

    if (currentIndex < examQuestions.length - 1) {
      setState(() {
        currentIndex++;
        selectedChoiceIndex = null;
        drawnPoints.clear();
        drawingAnswered = false;
        dragAnswers.clear();
      });
    } else {
      _finishExam();
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _finishExam() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Exam Finished"),
            content: Text("Your score is $score / ${examQuestions.length}"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    CupertinoPageRoute(builder: (context) => const ParentHomePage()),
                        (route) => false,
                  );
                },
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
    final questionText =
        examQuestion.type == QuestionType.choice
            ? (examQuestion.data as ChoiceQuestion).questionText
            : examQuestion.type == QuestionType.drawing
            ? (examQuestion.data as DrawingQuestion).questionText
            : (examQuestion.data as DragDropQuestion).questionText;

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
                    icon: const Icon(
                      Icons.volume_up,
                      color: Colors.deepPurpleAccent,
                    ),
                    onPressed: () => speakQuestion(questionText),
                  ),
                ],
              ),
              SizedBox(height: config.localHeight * 0.03),
              Expanded(
                child:
                    examQuestion.type == QuestionType.choice
                        ? ChoiceQuestionWidget(
                          key: ValueKey("choice_$currentIndex"),
                          question: examQuestion.data,
                          onSelected: handleChoiceSelected,
                        )
                        : examQuestion.type == QuestionType.drawing
                        ? DrawingQuestionWidget(
                          key: ValueKey("drawing_$currentIndex"),
                          question: examQuestion.data,
                          onDrawingUpdate: handleDrawingUpdate,
                          onClear: clearDrawing,
                        )
                        : DragDropQuestionWidget(
                          key: ValueKey("dragDrop_$currentIndex"),
                          question: examQuestion.data,
                          onAnswered: (answers) {
                            setState(() => dragAnswers = answers);
                          },
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
