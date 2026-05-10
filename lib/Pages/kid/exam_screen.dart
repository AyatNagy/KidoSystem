import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kido/Models/exams/chioce_question.dart';
import 'package:kido/Models/exams/draw_question.dart';
import 'package:kido/Models/exams/draganddrop_question.dart';
import 'package:kido/Models/exams/speak_question.dart';
import 'package:kido/Widgets/Questions/chioce_question_widget.dart';
import 'package:kido/Widgets/Questions/draw_question_widget.dart';
import 'package:kido/Widgets/Questions/draganddrop_question_widget.dart';
import 'package:kido/Widgets/Questions/speak_question_widget.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import 'package:kido/Widgets/Buttons/custom_app_button.dart';
import '../../Models/exams/exam_model.dart';
import '../../config/progress.dart';
import '../../constants.dart';
import '../../data/exam/choice_question_data.dart';
import '../../data/exam/draganddrop_question_data.dart';
import '../../data/exam/draw_question_data.dart';
import '../../data/exam/speak_question_data.dart';
import '../../enum/question_type.dart';
import '../../services/audio_service.dart';

class ExamSkeletonScreen extends StatefulWidget {
  final String examId;
  final String childName;

  const ExamSkeletonScreen({
    super.key,
    required this.examId,
    required this.childName,
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
  Map<String, String?> dragAnswers = {};
  String currentSpokenResult = "";
  Timer? _autoRepeatTimer;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _playQuestionAudio();
    });
  }

  @override
  void dispose() {
    _autoRepeatTimer?.cancel();
    AudioService.stop();
    super.dispose();
  }

  void _loadQuestions() {
    examQuestions = [
      ...allChoiceQuestions
          .where((q) => q.examId!.contains(widget.examId))
          .map((q) => ExamQuestion(type: QuestionType.choice, data: q)),
      ...allDrawingQuestions
          .where((q) => q.examId!.contains(widget.examId))
          .map((q) => ExamQuestion(type: QuestionType.drawing, data: q)),
      ...allDragDropQuestions
          .where((q) => q.examId!.contains(widget.examId))
          .map((q) => ExamQuestion(type: QuestionType.dragDrop, data: q)),
      ...allSpaekQuestions
          .where((q) => q.examId!.contains(widget.examId))
          .map((q) => ExamQuestion(type: QuestionType.speak, data: q)),
    ];
  }

  void _playQuestionAudio() {
    _autoRepeatTimer?.cancel();
    final examQuestion = examQuestions[currentIndex];
    String fileName = "";

    if (examQuestion.type == QuestionType.choice) {
      fileName = (examQuestion.data as ChoiceQuestion).questionAudio;
    } else if (examQuestion.type == QuestionType.drawing) {
      fileName = (examQuestion.data as DrawingQuestion).questionAudio;
    } else if (examQuestion.type == QuestionType.dragDrop) {
      fileName = (examQuestion.data as DragDropQuestion).questionAudio;
    } else if (examQuestion.type == QuestionType.speak) {
      fileName = (examQuestion.data as SpeakQuestion).questionAudio;
    }

    if (fileName.isNotEmpty) {
      AudioService.play(fileName: fileName);
      _autoRepeatTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
        AudioService.play(fileName: fileName);
      });
    }
  }

  void handleNext() {
    final examQuestion = examQuestions[currentIndex];
    if (examQuestion.type == QuestionType.choice) {
      final q = examQuestion.data as ChoiceQuestion;
      if (selectedChoiceIndex == null) {
        _showSnack("Please choose an answer first");
        return;
      }
      if (selectedChoiceIndex == q.correctIndex) score++;
    } else if (examQuestion.type == QuestionType.drawing) {
      if (!drawingAnswered) {
        _showSnack("Please draw your answer first");
        return;
      }
      if (checkDrawingSoft(examQuestion.data.targetShape, drawnPoints)) score++;
    } else if (examQuestion.type == QuestionType.dragDrop) {
      final q = examQuestion.data as DragDropQuestion;
      bool allTargetsFilled = q.targets.every((t) => dragAnswers.containsValue(t.id));
      if (!allTargetsFilled) {
        _showSnack("من فضلك ضع الإجابة في مكانها أولاً");
        return;
      }
      bool isAllCorrect = true;
      for (var target in q.targets) {
        String? itemId = dragAnswers.entries.where((e) => e.value == target.id).map((e) => e.key).firstOrNull;
        if (itemId == null || !target.acceptedItemIds.contains(itemId)) {
          isAllCorrect = false;
          break;
        }
      }
      if (isAllCorrect) score++;
    } else if (examQuestion.type == QuestionType.speak) {
      final q = examQuestion.data as SpeakQuestion;
      if (currentSpokenResult.isEmpty) {
        _showSnack("من فضلك قل الإجابة أولاً");
        return;
      }
      bool isCorrect = q.acceptedAnswers.any((ans) => currentSpokenResult.contains(ans));
      if (isCorrect) score++;
    }

    if (currentIndex < examQuestions.length - 1) {
      setState(() {
        currentIndex++;
        selectedChoiceIndex = null;
        drawnPoints.clear();
        drawingAnswered = false;
        dragAnswers.clear();
        currentSpokenResult = "";
      });
      _playQuestionAudio();
    } else {
      _autoRepeatTimer?.cancel();
      AudioService.stop();
      _finishExam();
    }
  }

  void _finishExam() async {
    double percentage = score / examQuestions.length;
    bool passed = percentage >= 0.50;
    int nextLevelToUnlock = 1;
    String unlockMessageText = "Keep practicing to unlock new levels!";

    if (widget.examId == "exam2" && !passed) {
      unlockMessageText = "Let's review Exam 1 to get stronger!";
      nextLevelToUnlock = -1;
    } else if (passed) {
      if (widget.examId == "exam1") {
        nextLevelToUnlock = 2;
        unlockMessageText = "Level 1 & 2 are now UNLOCKED!";
        await ProgressManager.unlockUpTo(2);
      } else if (widget.examId == "exam2") {
        nextLevelToUnlock = 3;
        unlockMessageText = "Level 1, 2, & 3 are now UNLOCKED!";
        await ProgressManager.unlockUpTo(3);
      }
    }

    int stars = percentage >= 0.85 ? 3 : (percentage >= 0.70 ? 2 : (percentage >= 0.50 ? 1 : 0));

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              passed ? 'assets/gif/finish.gif' : 'assets/gif/not-finish.gif',
              height: 180,
              fit: BoxFit.contain,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  if (passed)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) => Icon(
                        Icons.star_rounded,
                        size: 45,
                        color: index < stars ? Colors.orange : Colors.grey.shade300,
                      )),
                    ),
                  const SizedBox(height: 15),
                  Text(passed ? "AMAZING JOB!" : "NICE TRY!", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text("You got $score / ${examQuestions.length}", style: const TextStyle(fontSize: 18, color: Colors.grey)),
                  const SizedBox(height: 20),
                  Text(unlockMessageText, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.kidoGreen)),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context, nextLevelToUnlock);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.kidoPink, minimumSize: const Size(double.infinity, 50)),
                    child: const Text("DONE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnack(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  bool checkDrawingSoft(String target, List<Offset> points) {
    if (points.length < 10) return false;
    return target == "Circle" ? _isCircleSoft(points) : _isVSoft(points);
  }

  bool _isCircleSoft(List<Offset> points) {
    double avgX = points.map((p) => p.dx).reduce((a, b) => a + b) / points.length;
    double avgY = points.map((p) => p.dy).reduce((a, b) => a + b) / points.length;
    Offset center = Offset(avgX, avgY);
    List<double> distances = points.map((p) => (p - center).distance).toList();
    double avgR = distances.reduce((a, b) => a + b) / distances.length;
    double dev = distances.map((d) => (d - avgR).abs()).reduce((a, b) => a + b) / distances.length;
    return avgR > 20 && (dev / avgR) < 0.35;
  }

  bool _isVSoft(List<Offset> points) {
    if (points.length < 20) return false;
    int mid = points.length ~/ 2;
    double a1 = (points[mid] - points.first).direction;
    double a2 = (points.last - points[mid]).direction;
    double diff = (a1 - a2).abs() * 180 / 3.14159;
    return diff > 20 && diff < 160;
  }

  void handleChoiceSelected(int index) => setState(() => selectedChoiceIndex = index);
  void handleDrawingUpdate(List<Offset> points) => setState(() { drawnPoints = points; drawingAnswered = points.isNotEmpty; });
  void clearDrawing() => setState(() { drawnPoints.clear(); drawingAnswered = false; });

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);
    final examQuestion = examQuestions[currentIndex];

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: Padding(
          padding: config.pagePadding,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Question ${currentIndex + 1}", style: TextStyle(fontSize: config.body, color: AppColors.textGray)),
                  IconButton(
                    onPressed: _playQuestionAudio,
                    icon: const Icon(Icons.replay_circle_filled_rounded, color: AppColors.kidoPink, size: 40),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: _buildQuestionWidget(examQuestion),
              ),
              CustomGradientButton(
                title: "Next",
                onPressed: handleNext,
                width: double.infinity,
                borderRadius: 30,
                fontSize: config.title,
                colors: [AppColors.kidoPink, AppColors.kidoOrange],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionWidget(ExamQuestion examQuestion) {
    switch (examQuestion.type) {
      case QuestionType.choice:
        return ChoiceQuestionWidget(key: ValueKey(currentIndex), question: examQuestion.data, onSelected: handleChoiceSelected);
      case QuestionType.drawing:
        return DrawingQuestionWidget(key: ValueKey(currentIndex), question: examQuestion.data, onDrawingUpdate: handleDrawingUpdate, onClear: clearDrawing);
      case QuestionType.dragDrop:
        return DragDropQuestionWidget(key: ValueKey(currentIndex), question: examQuestion.data, isExamMode: true, onAnswered: (ans) => setState(() => dragAnswers = ans));
      case QuestionType.speak:
        return SpeakQuestionWidget(key: ValueKey(currentIndex), question: examQuestion.data, onAnswered: (txt) => setState(() => currentSpokenResult = txt));
    }
  }
}