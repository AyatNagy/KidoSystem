// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kido/Models/dragable_item.dart';
import 'package:kido/Models/exams/draganddrop_question.dart';
import 'package:kido/Models/level2/color_model.dart';
import 'package:kido/Models/targets_item.dart';
import 'package:kido/Widgets/content/level2/colors/color_draganddrop_widget.dart';
import 'package:kido/services/audio_service.dart';

class ColorQuizStageWidget extends StatefulWidget {
  final ColorTarget colorTarget;
  final ColorGroup currentGroup;
  final VoidCallback onCompleted;

  const ColorQuizStageWidget({
    super.key,
    required this.colorTarget,
    required this.currentGroup,
    required this.onCompleted,
  });

  @override
  State<ColorQuizStageWidget> createState() => _ColorQuizStageWidgetState();
}

class _ColorQuizStageWidgetState extends State<ColorQuizStageWidget>
    with SingleTickerProviderStateMixin {
  int _currentQuestionIndex = 0;

  List<DragDropQuestion> _quizQuestions = [];

  bool _isInitialized = false;

  bool _showHand = false;

  bool _childStartedDragging = false;

  bool _highlightCorrect = false;

  Timer? _repeatTimer;

  late AnimationController _pulseController;

  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _generateQuestions();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _playHelpSequence();
    });
  }

  @override
  void dispose() {
    _repeatTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _playHelpSequence() async {
    if (!mounted) return;

    setState(() {
      _showHand = true;
      _highlightCorrect = true;
    });

    _pulseController.repeat(reverse: true);

    await AudioService.playAndWait(
      fileName: _quizQuestions[_currentQuestionIndex].questionAudio,
    );

    if (!mounted) return;

    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      setState(() {
        _showHand = false;
        _highlightCorrect = false;
      });

      _pulseController.reset();
    }

    _startRepeatTimer();
  }

  void _startRepeatTimer() {
    _repeatTimer?.cancel();

    _repeatTimer = Timer(const Duration(seconds: 3), () async {
      if (!_childStartedDragging && mounted) {
        await _playHelpSequence();
      }
    });
  }

  void _generateQuestions() {
    final correctImages = widget.colorTarget.targetImages;

    final otherColors =
        widget.currentGroup.colors
            .where((c) => c.id != widget.colorTarget.id)
            .toList();

    List<String> allDistractors = [];

    for (final color in otherColors) {
      allDistractors.addAll(color.targetImages);
    }

    if (allDistractors.isEmpty) {
      allDistractors = ['animals/cow.png', 'animals/cat.png'];
    }

    List<DragDropQuestion> generatedQuestions = [];

    for (int i = 0; i < correctImages.length; i++) {
      final correctImg = correctImages[i];

      List<String> currentDistractors = List.from(allDistractors)..shuffle();

      final wrong1 = currentDistractors[0];

      final wrong2 =
          currentDistractors.length > 1
              ? currentDistractors[1]
              : currentDistractors[0];

      List<DragItem> items = [
        DragItem(
          id: 'correct_$i',
          image: 'assets/images/$correctImg',
          startPosition: Offset.zero,
          size: const Size(0.22, 0.22),
        ),

        DragItem(
          id: 'wrong_1_$i',
          image: 'assets/images/$wrong1',
          startPosition: Offset.zero,
          size: const Size(0.22, 0.22),
        ),

        DragItem(
          id: 'wrong_2_$i',
          image: 'assets/images/$wrong2',
          startPosition: Offset.zero,
          size: const Size(0.22, 0.22),
        ),
      ];

      items.shuffle();

      final List<Offset> positions = [
        const Offset(0.08, 0.14),
        const Offset(0.40, 0.14),
        const Offset(0.72, 0.14),
      ];

      for (int j = 0; j < items.length; j++) {
        items[j] = DragItem(
          id: items[j].id,
          image: items[j].image,
          startPosition: positions[j],
          size: items[j].size,
        );
      }

      generatedQuestions.add(
        DragDropQuestion(
          questionAudio: widget.colorTarget.questionAudio,

          targets: [
            DragTargetZone(
              id: 'basket_${widget.colorTarget.id}',

              acceptedItemIds: ['correct_$i'],

              position: const Offset(0.33, 0.60),

              size: const Size(0.34, 0.34),

              image: 'assets/images/${widget.colorTarget.bucketImage}',
            ),
          ],

          items: items,
        ),
      );
    }

    setState(() {
      _quizQuestions = generatedQuestions;
      _isInitialized = true;
    });
  }

  Future<void> _onItemAnswered(Map<String, String?> answers) async {
    bool hasCorrectAnswer = answers.keys.any(
      (key) => key.startsWith('correct_'),
    );

    if (!hasCorrectAnswer) return;

    _repeatTimer?.cancel();

    _pulseController.reset();

    setState(() {
      _showHand = false;
      _highlightCorrect = false;
    });

    await AudioService.playAndWait(fileName: "great_hero.mp3");

    await Future.delayed(const Duration(milliseconds: 400));

    if (_currentQuestionIndex < _quizQuestions.length - 1) {
      setState(() {
        _currentQuestionIndex++;

        _showHand = false;

        _highlightCorrect = false;

        _childStartedDragging = false;
      });

      await Future.delayed(const Duration(milliseconds: 300));

      _playHelpSequence();
    } else {
      widget.onCompleted();
    }
  }

  Future<void> _handleWrongAnswer() async {
    _repeatTimer?.cancel();

    _pulseController.reset();

    setState(() {
      _showHand = false;
      _highlightCorrect = false;
      _childStartedDragging = false;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    await _playHelpSequence();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized || _quizQuestions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final currentQuestion = _quizQuestions[_currentQuestionIndex];

    final correctItem = currentQuestion.items.firstWhere(
      (item) => item.id.startsWith('correct_'),
    );

    final correctItemPos = correctItem.startPosition;

    final basketTarget = currentQuestion.targets.first;

    final basketPos = basketTarget.position;

    final screenSize = MediaQuery.of(context).size;

    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color(0xffFCFCFC),
        ),

        ColorDragDropWidget(
          key: ValueKey('color_q_$_currentQuestionIndex'),

          question: currentQuestion,

          highlightCorrect: _highlightCorrect,

          onAnswered: _onItemAnswered,

          onWrongDrop: _handleWrongAnswer,

          onDragStart: () {
            _repeatTimer?.cancel();

            _pulseController.reset();

            setState(() {
              _childStartedDragging = true;

              _showHand = false;

              _highlightCorrect = false;
            });
          },
        ),

        if (_showHand)
          _AnimatedHandGuide(
            startX: correctItemPos.dx + 0.08,

            startY: correctItemPos.dy + 0.08,

            endX: basketPos.dx + 0.12,

            endY: basketPos.dy + 0.10,
          ),
      ],
    );
  }
}

class _AnimatedHandGuide extends StatefulWidget {
  final double startX;
  final double startY;
  final double endX;
  final double endY;

  const _AnimatedHandGuide({
    required this.startX,
    required this.startY,
    required this.endX,
    required this.endY,
  });

  @override
  State<_AnimatedHandGuide> createState() => _AnimatedHandGuideState();
}

class _AnimatedHandGuideState extends State<_AnimatedHandGuide>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _xAnimation;

  late Animation<double> _yAnimation;

  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();

    _xAnimation = Tween<double>(begin: widget.startX, end: widget.endX).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 0.8, curve: Curves.easeInOut),
      ),
    );

    _yAnimation = Tween<double>(begin: widget.startY, end: widget.endY).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 0.8, curve: Curves.easeInOut),
      ),
    );

    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.85), weight: 15),

      TweenSequenceItem(tween: Tween(begin: 0.85, end: 0.85), weight: 65),

      TweenSequenceItem(tween: Tween(begin: 0.85, end: 0.0), weight: 20),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Positioned(
      left: 0,
      top: 0,
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(
                size.width * _xAnimation.value,

                size.height * _yAnimation.value,
              ),
              child: Opacity(
                opacity: _opacityAnimation.value,
                child: Image.asset(
                  'assets/images/animated_hand-Photoroom.png',

                  width: size.width > 600 ? 120 : 80,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
