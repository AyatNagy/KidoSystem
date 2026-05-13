// ignore_for_file: deprecated_member_use
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kido/Models/exams/chioce_question.dart';
import 'package:kido/Models/exams/draw_question.dart';
import 'package:kido/Models/exams/draganddrop_question.dart';
import 'package:kido/Models/exams/speak_question.dart';
import 'package:kido/Widgets/Layout/snackbar.dart';
import 'package:kido/Widgets/Questions/chioce_question_widget.dart';
import 'package:kido/Widgets/Questions/draw_question_widget.dart';
import 'package:kido/Widgets/Questions/draganddrop_question_widget.dart';
import 'package:kido/Widgets/Questions/speak_question_widget.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import 'package:kido/Widgets/Buttons/custom_app_button.dart';
import '../../Models/exams/exam_model.dart';
import '../../Models/exams/trace_question.dart';
import '../../Widgets/Dialogs/dialog_result.dart';
import '../../constants.dart';
import '../../enum/question_type.dart';
import '../../services/audio_service.dart';
import '../content/level3/letters/letter_trace_page.dart';
import '../../data/exam/exam_provider.dart';

class ExamSkeletonScreen extends StatefulWidget {
  final String examId;
  final String childName;
  final bool onboardingPlacement;

  const ExamSkeletonScreen({
    super.key,
    required this.examId,
    required this.childName,
    this.onboardingPlacement = false,
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
    examQuestions = ExamProvider.loadQuestions(widget.examId);
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

  void _playQuestionAudio() {
    _autoRepeatTimer?.cancel();
    if (examQuestions.isEmpty) return;
    final examQuestion = examQuestions[currentIndex];
    String fileName = "";
    final data = examQuestion.data;
    if (data is ChoiceQuestion) {
      fileName = data.questionAudio;
    } else if (data is DrawingQuestion) {
      fileName = data.questionAudio;
    } else if (data is DragDropQuestion) {
      fileName = data.questionAudio;
    } else if (data is SpeakQuestion) {
      fileName = data.questionAudio;
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
    bool isAnswered = false;
    bool isCorrect = false;
    if (examQuestion.type == QuestionType.choice) {
      final q = examQuestion.data as ChoiceQuestion;
      if (selectedChoiceIndex != null) {
        isAnswered = true;
        if (selectedChoiceIndex == q.correctIndex) isCorrect = true;
      }
    } else if (examQuestion.type == QuestionType.drawing) {
      if (drawingAnswered) {
        isAnswered = true;
        if (checkDrawingSoft(examQuestion.data.targetShape, drawnPoints)) isCorrect = true;
      }
    } else if (examQuestion.type == QuestionType.dragDrop) {
      final q = examQuestion.data as DragDropQuestion;
      if (q.targets.every((t) => dragAnswers.containsValue(t.id))) {
        isAnswered = true;
        isCorrect = q.targets.every((target) {
          String? itemId = dragAnswers.entries
              .where((e) => e.value == target.id)
              .map((e) => e.key).firstOrNull;
          return itemId != null && target.acceptedItemIds.contains(itemId);
        });
      }
    } else if (examQuestion.type == QuestionType.speak) {
      final q = examQuestion.data as SpeakQuestion;
      if (currentSpokenResult.isNotEmpty) {
        isAnswered = true;
        if (q.acceptedAnswers.any((ans) => currentSpokenResult.toLowerCase().contains(ans.toLowerCase()))) isCorrect = true;
      }
    }

    if (!isAnswered && examQuestion.type != QuestionType.trace) {
      showKidoSnack(context, "Please complete the mission!");
      return;
    }

    if (isCorrect) score++;

    if (currentIndex < examQuestions.length - 1) {
      setState(() {
        currentIndex++;
        _resetInputs();
      });
      _playQuestionAudio();
    } else {
      _autoRepeatTimer?.cancel();
      AudioService.stop();
      _finishExam();
    }
  }

  void _resetInputs() {
    selectedChoiceIndex = null;
    drawnPoints.clear();
    drawingAnswered = false;
    dragAnswers.clear();
    currentSpokenResult = "";
  }

  void _finishExam() {
    ExamResultDialog.show(
      context,
      score: score,
      total: examQuestions.length,
      examId: widget.examId,
      onboardingPlacement: widget.onboardingPlacement,
    );
  }
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
    final double progressPercent = (currentIndex + 1) / examQuestions.length;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF0F9FF), Colors.white],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 20, 25, 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Mission ${currentIndex + 1}",
                          style: TextStyle(
                              fontSize: config.title,
                              fontWeight: FontWeight.w900,
                              color: AppColors.kidoPink
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Container(
                          height: 14,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          height: 14,
                          width: config.localWidth * 0.85 * progressPercent,
                          decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [AppColors.kidoOrange, Colors.orangeAccent]),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(color: AppColors.kidoOrange.withOpacity(0.3), blurRadius: 5, offset: const Offset(0, 3))
                              ]
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(begin: const Offset(0.1, 0), end: Offset.zero).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: Container(
                      key: ValueKey(currentIndex),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(35),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.08),
                            blurRadius: 30,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                      child: _buildQuestionWidget(examQuestion),
                    ),
                  ),
                ),
              ),
              if (examQuestion.type != QuestionType.trace)
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 10, 30, 25),
                  child: CustomGradientButton(
                    title: currentIndex == examQuestions.length - 1 ? "FINISH!" : "NEXT QUEST",
                    onPressed: handleNext,
                    width: double.infinity,
                    borderRadius: 25,
                    fontSize: config.title,
                    colors: const [AppColors.kidoPink, AppColors.kidoOrange],
                  ),
                ),
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
      case QuestionType.trace:
        final traceData = examQuestion.data as TraceQuestion;
        return LetterTracePage(
          key: ValueKey(currentIndex),
          letter: traceData.letter,
          isExam: true,
          onComplete: () {
            setState(() { score++; });
            handleNext();
          },
        );
    }
  }
}