import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kido/Widgets/content/draganddrop.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import 'package:kido/data/level2/puzzel_data.dart';
import 'package:kido/enum/puzzel_flow.dart';
import 'package:kido/services/audio_service.dart';
import 'package:lottie/lottie.dart';

class PuzzlePracticeScreen extends StatefulWidget {
  final PuzzleData puzzleData;

  const PuzzlePracticeScreen({super.key, required this.puzzleData});

  @override
  State<PuzzlePracticeScreen> createState() => _PuzzlePracticeScreenState();
}

class _PuzzlePracticeScreenState extends State<PuzzlePracticeScreen>
    with TickerProviderStateMixin {
  late final PuzzleData puzzleData;

  PuzzleStage stage = PuzzleStage.intro;

  bool isSuccess = false;
  bool showHint = false;

  Timer? _idleTimer;

  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  late AnimationController _handController;
  late Animation<Offset> _handAnimation;

  @override
  void initState() {
    super.initState();

    puzzleData = widget.puzzleData;

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _glowAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _handController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _prepareHand();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startIntro();
    });
  }

  // 🟢 1. عرض الصورة الكاملة
  void _startIntro() async {
    setState(() => stage = PuzzleStage.intro);

    await AudioService.play(fileName: "look_full.mp3");

    await Future.delayed(const Duration(seconds: 3));

    _startModeling();
  }

  // 🟡 2. عرض عملي (الهاند يركب القطعة)
  void _startModeling() async {
    setState(() => stage = PuzzleStage.modeling);

    await AudioService.play(fileName: "watch_me.mp3");

    _handController.forward(from: 0);

    await Future.delayed(const Duration(seconds: 2));

    _startGuided();
  }

  // 🟠 3. Guided
  void _startGuided() {
    setState(() => stage = PuzzleStage.guided);

    _runSystem();
    _handController.repeat();
  }

  // 🔴 4. Practice
  void _startPractice() {
    setState(() => stage = PuzzleStage.practice);

    _runSystem();
  }

  // 💡 system
  void _runSystem({bool hint = false}) async {
    if (isSuccess || !mounted) return;

    _stopAll();

    if (hint && stage != PuzzleStage.intro && stage != PuzzleStage.modeling) {
      setState(() => showHint = true);
      _glowController.repeat(reverse: true);
    }

    _startIdle();
  }

  void _stopAll() {
    _idleTimer?.cancel();
    _glowController.reset();
    _handController.stop();
    AudioService.stop();

    if (mounted) setState(() => showHint = false);
  }

  void _startIdle() {
    if (stage == PuzzleStage.intro || stage == PuzzleStage.modeling) return;

    _idleTimer?.cancel();
    _idleTimer = Timer(const Duration(seconds: 7), () async {
      await AudioService.play(fileName: "yalla_puzzle.mp3");
      _runSystem(hint: true);
    });
  }

  // ✅ نجاح
  void _onAnswered(Map<String, String?> answers) async {
    if (answers.length != puzzleData.question.targets.length) return;
    if (isSuccess) return;

    _stopAll();
    setState(() => isSuccess = true);

    await AudioService.play(fileName: "yaay.mp3");

    await Future.delayed(const Duration(seconds: 2));

    if (stage == PuzzleStage.guided) {
      _startPractice();
    } else {
      Navigator.pop(context);
    }
  }

  void _onDragStart() {
    if (stage == PuzzleStage.intro || stage == PuzzleStage.modeling) return;
    _stopAll();
  }

  void _onWrong() {
    if (stage == PuzzleStage.intro || stage == PuzzleStage.modeling) return;
    _runSystem(hint: true);
  }

  // 🖐️ hand animation
  void _prepareHand() {
    final item = puzzleData.question.items.first;
    final target = puzzleData.question.targets.first;

    _handAnimation = Tween<Offset>(
      begin: item.startPosition,
      end: target.position,
    ).animate(
      CurvedAnimation(parent: _handController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _idleTimer?.cancel();
    _glowController.dispose();
    _handController.dispose();
    AudioService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);
    final w = config.localWidth;
    final h = config.localHeight;

    final firstItem = puzzleData.question.items.first;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 🟢 Intro (الصورة الكاملة)
          if (stage == PuzzleStage.intro)
            Center(
              child: Image.asset(
                puzzleData.fullImage ?? puzzleData.question.backgroundImage!,
              ),
            )
          // 🟡 Modeling (الهاند بيركب القطعة)
          else if (stage == PuzzleStage.modeling)
            Stack(
              children: [
                Center(
                  child: Image.asset(puzzleData.question.backgroundImage!),
                ),

                AnimatedBuilder(
                  animation: _handAnimation,
                  builder: (_, __) {
                    return Stack(
                      children: [
                        // القطعة بتتحرك
                        Positioned(
                          left: w * _handAnimation.value.dx,
                          top: h * _handAnimation.value.dy,
                          child: Image.asset(firstItem.image, width: 80),
                        ),

                        // الهاند
                        Positioned(
                          left: w * _handAnimation.value.dx,
                          top: h * _handAnimation.value.dy,
                          child: Image.asset(
                            "assets/images/animated_hand-Photoroom.png",
                            width: 60,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            )
          // 🟠 Guided + 🔴 Practice
          else
            DragDropWidget(
              question: puzzleData.question,
              onAnswered: _onAnswered,
              onDragStart: _onDragStart,
              onWrongDrop: _onWrong,
            ),

          // 💡 Hint
          if (showHint && !isSuccess)
            Positioned(
              left: w * firstItem.startPosition.dx,
              top: h * firstItem.startPosition.dy,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.yellow.withOpacity(_glowAnimation.value),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
              ),
            ),

          // 🖐️ Guided hand
          if (stage == PuzzleStage.guided && !isSuccess)
            AnimatedBuilder(
              animation: _handAnimation,
              builder: (_, __) {
                return Positioned(
                  left: w * _handAnimation.value.dx,
                  top: h * _handAnimation.value.dy,
                  child: Image.asset(
                    "assets/images/animated_hand-Photoroom.png",
                    width: 60,
                  ),
                );
              },
            ),

          // 🎉 success
          if (isSuccess)
            Positioned.fill(
              child: Lottie.asset('assets/lottie/CONFETTI.json', repeat: false),
            ),

          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
