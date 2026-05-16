// ignore_for_file: deprecated_member_use
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kido/Pages/content/level2/level2home.dart';
import 'package:kido/Widgets/content/draganddrop.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import 'package:kido/enum/puzzle_flow.dart';
import 'package:kido/services/audio_service.dart';
import 'package:lottie/lottie.dart';
import '../../../data/content/level2/puzzle_data.dart';

class PuzzlePracticeScreen extends StatefulWidget {
  final List<PuzzleData> levels;
  final String childName;
  final int childId;

  const PuzzlePracticeScreen({
    super.key,
    required this.levels,
    required this.childName,
    required this.childId,
  });

  @override
  State<PuzzlePracticeScreen> createState() => _PuzzlePracticeScreenState();
}

class _PuzzlePracticeScreenState extends State<PuzzlePracticeScreen>
    with TickerProviderStateMixin {
  PuzzleStage stage = PuzzleStage.intro;
  bool isSuccess = false;
  bool showHint = false;
  int currentLevelIndex = 0;
  int currentItemIndex = 0;
  Timer? _idleTimer;

  late AnimationController _glowController;
  late Animation<double> _glowAnimation;
  late AnimationController _handController;
  late Animation<Offset> _handAnimation;

  PuzzleData get puzzleData => widget.levels[currentLevelIndex];

  @override
  void initState() {
    super.initState();
    _initAnimations();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startFullFlow());
  }

  void _initAnimations() {
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
    _prepareHand(0);
  }

  void _startFullFlow() async {
    if (!mounted) return;
    setState(() {
      stage = PuzzleStage.intro;
      isSuccess = false;
      currentItemIndex = 0;
    });

    AudioService.play(fileName: "look_full.mp3");
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;
    setState(() {
      stage = PuzzleStage.modeling;
    });

    AudioService.play(fileName: "watch_me.mp3");
    await Future.delayed(const Duration(seconds: 1));

    for (int i = 0; i < puzzleData.question.items.length; i++) {
      if (!mounted) return;

      setState(() {
        currentItemIndex = i;
      });

      _prepareHand(i);
      await _handController.forward(from: 0);
      await Future.delayed(const Duration(milliseconds: 500));
      _handController.reset();
    }
    _startInteraction();
  }

  void _startInteraction() async {
    if (!mounted) return;
    setState(() {
      stage = PuzzleStage.interaction;
      showHint = false;
      currentItemIndex = 0;
    });
    AudioService.play(fileName: "yalla_puzzle.mp3");

    _resetIdleTimer();
  }

  void _resetIdleTimer() {
    _idleTimer?.cancel();
    _idleTimer = Timer(const Duration(seconds: 5), () {
      if (isSuccess || !mounted || stage != PuzzleStage.interaction) return;
      setState(() {
        showHint = true;
      });
      _glowController.repeat(reverse: true);
      _handController.repeat();
      AudioService.play(fileName: "yalla_puzzle.mp3");
      _resetIdleTimer();
    });
  }

  void _prepareHand(int itemIndex) {
    if (itemIndex >= puzzleData.question.items.length) return;

    final item = puzzleData.question.items[itemIndex];
    final target = puzzleData.question.targets[itemIndex];

    _handAnimation = Tween<Offset>(
      begin: item.startPosition,
      end: target.position,
    ).animate(
      CurvedAnimation(parent: _handController, curve: Curves.easeInOut),
    );
  }

  void _stopUserAssistance() {
    _idleTimer?.cancel();
    _glowController.reset();
    _handController.stop();
    if (mounted) {
      setState(() => showHint = false);
    }
  }

  void _onAnswered(Map<String, String?> answers) async {
    if (answers.length != puzzleData.question.targets.length) return;

    _stopUserAssistance();
    setState(() => isSuccess = true);

    AudioService.play(fileName: "yaay.mp3");
    await Future.delayed(const Duration(seconds: 2));

    _goToNextLevel();
  }

  void _goToNextLevel() {
    if (currentLevelIndex < widget.levels.length - 1) {
      setState(() {
        currentLevelIndex++;
      });
      _startFullFlow();
    } else {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _idleTimer?.cancel();
    _glowController.stop();
    _handController.stop();
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

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              stage == PuzzleStage.intro
                  ? (puzzleData.fullImage ??
                      puzzleData.question.backgroundImage!)
                  : puzzleData.question.backgroundImage!,
            ),
          ),
          if (stage == PuzzleStage.modeling)
            AnimatedBuilder(
              animation: _handAnimation,
              builder: (_, __) {
                return Stack(
                  children: [
                    Positioned(
                      left: w * _handAnimation.value.dx,
                      top: h * _handAnimation.value.dy,
                      child: Image.asset(
                        puzzleData.question.items[currentItemIndex].image,
                        width: 80,
                      ),
                    ),
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
          if (stage == PuzzleStage.interaction)
            DragDropWidget(
              question: puzzleData.question,
              onAnswered: _onAnswered,
              onDragStart: _stopUserAssistance,
              onWrongDrop: () => _resetIdleTimer(),
            ),
          if (showHint && !isSuccess) ...[
            Positioned(
              left:
                  w *
                  puzzleData.question.items[currentItemIndex].startPosition.dx,
              top:
                  h *
                  puzzleData.question.items[currentItemIndex].startPosition.dy,
              child: AnimatedBuilder(
                animation: _glowAnimation,
                builder:
                    (context, child) => Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.yellow.withOpacity(
                              _glowAnimation.value,
                            ),
                            blurRadius: 30,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                    ),
              ),
            ),
            AnimatedBuilder(
              animation: _handAnimation,
              builder:
                  (_, __) => Positioned(
                    left: w * _handAnimation.value.dx,
                    top: h * _handAnimation.value.dy,
                    child: Image.asset(
                      "assets/images/animated_hand-Photoroom.png",
                      width: 60,
                    ),
                  ),
            ),
          ],
          if (isSuccess)
            Positioned.fill(
              child: Lottie.asset('assets/lottie/confetti.json', repeat: false),
            ),
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 30),
              onPressed: () async {
                _idleTimer?.cancel();
                _glowController.stop();
                _handController.stop();
                AudioService.stop();

                if (!mounted) return;
<<<<<<< Updated upstream
                Navigator.pop(context);
=======

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => Level2Home(
                          childName: widget.childName,
                          childId: widget.childId,
                        ),
                  ),
                );
>>>>>>> Stashed changes
              },
            ),
          ),
        ],
      ),
    );
  }
}
