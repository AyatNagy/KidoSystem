import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';
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
import '../../config/progress.dart';
import '../../constants.dart';

enum QuestionType { choice, drawing, dragDrop, speak }

class ExamQuestion {
  final QuestionType type;
  final dynamic data;

  ExamQuestion({required this.type, required this.data});
}

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

  final FlutterTts flutterTts = FlutterTts();
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();

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

  @override
  void dispose() {
    flutterTts.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> speakQuestion(String text) async {
    await flutterTts.stop();
    await _audioPlayer.stop();
    flutterTts.setLanguage("ar-EG");
    flutterTts.setSpeechRate(0.4);
    flutterTts.setVolume(1.0);
    flutterTts.setPitch(1.1);
    await Future.delayed(const Duration(milliseconds: 100));
    flutterTts.speak(text);
  }

  Future<void> playAnimalSound(String assetPath) async {
    await flutterTts.stop();
    await _audioPlayer.stop();
    String path = assetPath.replaceFirst('assets/', '');
    await _audioPlayer.play(AssetSource(path));
  }

  bool checkDrawingSoft(String targetShape, List<Offset> points) {
    if (points.length < 10) return false;
    if (targetShape == "Circle") return _isCircleSoft(points);
    if (targetShape == "V-shape") return _isVSoft(points);
    return false;
  }

  bool _isCircleSoft(List<Offset> points) {
    if (points.length < 10) return false;

    double avgX =
        points.map((p) => p.dx).reduce((a, b) => a + b) / points.length;
    double avgY =
        points.map((p) => p.dy).reduce((a, b) => a + b) / points.length;
    Offset center = Offset(avgX, avgY);
    List<double> distances = points.map((p) => (p - center).distance).toList();
    double avgRadius = distances.reduce((a, b) => a + b) / distances.length;
    if (avgRadius < 20) return false;
    double totalDeviation = distances
        .map((d) => (d - avgRadius).abs())
        .reduce((a, b) => a + b);
    double avgDeviation = totalDeviation / distances.length;
    return (avgDeviation / avgRadius) < 0.35;
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

    if (examQuestion.type == QuestionType.choice) {
      final q = examQuestion.data as ChoiceQuestion;
      if (selectedChoiceIndex == null) {
        _showSnack("Please choose an answer first");
        return;
      }
      if (selectedChoiceIndex == q.correctIndex) {
        score++;
      }
    } else if (examQuestion.type == QuestionType.drawing) {
      if (!drawingAnswered) {
        _showSnack("Please draw your answer first");
        return;
      }
      if (checkDrawingSoft(examQuestion.data.targetShape, drawnPoints)) score++;
    } else if (examQuestion.type == QuestionType.dragDrop) {
      final q = examQuestion.data as DragDropQuestion;

      bool allTargetsFilled = q.targets.every((target) {
        return dragAnswers.containsValue(target.id);
      });

      if (!allTargetsFilled) {
        _showSnack("من فضلك ضع الإجابة في مكانها أولاً");
        return;
      }

      bool isAllCorrect = true;
      for (var target in q.targets) {
        String? itemIdInThisTarget =
            dragAnswers.entries
                .where((e) => e.value == target.id)
                .map((e) => e.key)
                .firstOrNull;

        if (itemIdInThisTarget == null ||
            !target.acceptedItemIds.contains(itemIdInThisTarget)) {
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
      bool isCorrect = q.acceptedAnswers.any(
        (ans) => currentSpokenResult.contains(ans),
      );
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
    } else {
      _finishExam();
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _finishExam() async {
    double percentage = score / examQuestions.length;
    bool passed = percentage >= 0.50;

    int nextLevelToUnlock = 1;
    String unlockMessageText = "Keep practicing to unlock new levels!";
    if (passed) {
      if (widget.examId == "exam1") {
        nextLevelToUnlock = 2;
        unlockMessageText = "Level 1 & 2 are now UNLOCKED!";
        await ProgressManager.unlockUpTo(2);
      } else if (widget.examId == "exam2") {
        nextLevelToUnlock = 3;
        unlockMessageText = "Level 1, 2, & 3 are now UNLOCKED!";
        await ProgressManager.unlockUpTo(3);
      } else {
        unlockMessageText = "You passed the exam!";
      }
    }

    int stars = 0;
    if (percentage >= 0.85) {
      stars = 3;
    } else if (percentage >= 0.70) {
      stars = 2;
    } else if (percentage >= 0.50) {
      stars = 1;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 180,
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                  child: Image.asset(
                    passed ? 'assets/gif/finish.gif' : 'assets/gif/not-finish.gif',
                    fit: BoxFit.contain,
                  ),
                ),
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
                    Text(
                      passed ? "AMAZING JOB!" : "NICE TRY!",
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "You got $score / ${examQuestions.length}",
                      style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: passed ? Colors.green.shade50 : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: passed ? Colors.green.shade200 : Colors.grey.shade300),
                      ),
                      child: Text(
                        unlockMessageText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: passed ? AppColors.kidoGreen : AppColors.textGray,
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context, nextLevelToUnlock);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.kidoPink,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        child: const Text(
                          "DONE",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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
            : examQuestion.type == QuestionType.dragDrop
            ? (examQuestion.data as DragDropQuestion).questionText
            : (examQuestion.data as SpeakQuestion).questionText;

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
              if (examQuestion.type == QuestionType.choice &&
                  (examQuestion.data as ChoiceQuestion).sound != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: IconButton(
                    iconSize: config.localWidth * 0.15,
                    icon: const Icon(
                      Icons.play_circle_filled,
                      color: Colors.deepOrangeAccent,
                    ),
                    onPressed:
                        () => playAnimalSound(
                          (examQuestion.data as ChoiceQuestion).sound!,
                        ),
                  ),
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
                        : examQuestion.type == QuestionType.dragDrop
                        ? DragDropQuestionWidget(
                          key: ValueKey("dragDrop_$currentIndex"),
                          question: examQuestion.data,
                          isExamMode: true,
                          onAnswered: (answers) {
                            setState(() => dragAnswers = answers);
                          },
                        )
                        : SpeakQuestionWidget(
                          key: ValueKey("speak_$currentIndex"),
                          question: examQuestion.data,
                          onAnswered: (spokenText) {
                            setState(() => currentSpokenResult = spokenText);
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
