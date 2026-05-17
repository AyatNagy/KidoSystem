import 'package:flutter/material.dart';
import 'package:kido/Models/dragable_item.dart';
import 'package:kido/Models/exams/draganddrop_question.dart';
import 'package:kido/Models/level2/color_model.dart';
import 'package:kido/Models/targets_item.dart';
import 'package:kido/Widgets/content/draganddrop.dart';
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
    with TickerProviderStateMixin {
  int _currentQuestionIndex = 0;

  late List<DragDropQuestion> _quizQuestions;

  bool _isInitialized = false;

  bool _showHand = true;

  @override
  void initState() {
    super.initState();

    _generateQuestions();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _playQuestionAudio();
    });
  }

  Future<void> _playQuestionAudio() async {
    await AudioService.playAndWait(
      fileName: _quizQuestions[_currentQuestionIndex].questionAudio,
    );
  }

  void _generateQuestions() {
    // الصور الصح الخاصة باللون الحالي
    final correctItems = widget.colorTarget.targetImages;

    // باقي الألوان للتشتيت
    final otherColors =
        widget.currentGroup.colors
            .where((c) => c.id != widget.colorTarget.id)
            .toList();

    List<String> distractorImages = [];

    for (final color in otherColors) {
      distractorImages.addAll(color.targetImages);
    }

    final wrong1 =
        distractorImages.isNotEmpty ? distractorImages[0] : 'animals/cow.png';

    final wrong2 =
        distractorImages.length > 1 ? distractorImages[1] : 'animals/cow.png';

    _quizQuestions = [
      // السؤال الأول
      DragDropQuestion(
        questionAudio: widget.colorTarget.questionAudio,

        targets: [
          DragTargetZone(
            id: 'single_basket',
            acceptedItemIds: ['correct_1'],
            position: const Offset(0.33, 0.60),
            size: const Size(0.34, 0.34),
            image: 'assets/images/${widget.colorTarget.bucketImage}',
          ),
        ],

        items: [
          // الصح
          DragItem(
            id: 'correct_1',
            image: 'assets/images/${correctItems[0]}',
            startPosition: const Offset(0.08, 0.14),
            size: const Size(0.22, 0.22),
          ),

          // تشتيت
          DragItem(
            id: 'wrong_1',
            image: 'assets/images/$wrong1',
            startPosition: const Offset(0.40, 0.14),
            size: const Size(0.22, 0.22),
          ),

          // تشتيت
          DragItem(
            id: 'wrong_2',
            image: 'assets/images/$wrong2',
            startPosition: const Offset(0.72, 0.14),
            size: const Size(0.22, 0.22),
          ),
        ],
      ),

      // السؤال الثاني
      DragDropQuestion(
        questionAudio: widget.colorTarget.questionAudio,

        targets: [
          DragTargetZone(
            id: 'single_basket',
            acceptedItemIds: ['correct_2'],
            position: const Offset(0.33, 0.60),
            size: const Size(0.34, 0.34),
            image: 'assets/images/${widget.colorTarget.bucketImage}',
          ),
        ],

        items: [
          DragItem(
            id: 'wrong_1',
            image: 'assets/images/$wrong1',
            startPosition: const Offset(0.08, 0.14),
            size: const Size(0.22, 0.22),
          ),

          DragItem(
            id: 'correct_2',
            image: 'assets/images/${correctItems[1]}',
            startPosition: const Offset(0.40, 0.14),
            size: const Size(0.22, 0.22),
          ),

          DragItem(
            id: 'wrong_2',
            image: 'assets/images/$wrong2',
            startPosition: const Offset(0.72, 0.14),
            size: const Size(0.22, 0.22),
          ),
        ],
      ),

      // السؤال الثالث
      DragDropQuestion(
        questionAudio: widget.colorTarget.questionAudio,

        targets: [
          DragTargetZone(
            id: 'single_basket',
            acceptedItemIds: ['correct_3'],
            position: const Offset(0.33, 0.60),
            size: const Size(0.34, 0.34),
            image: 'assets/images/${widget.colorTarget.bucketImage}',
          ),
        ],

        items: [
          DragItem(
            id: 'wrong_1',
            image: 'assets/images/$wrong1',
            startPosition: const Offset(0.08, 0.14),
            size: const Size(0.22, 0.22),
          ),

          DragItem(
            id: 'wrong_2',
            image: 'assets/images/$wrong2',
            startPosition: const Offset(0.40, 0.14),
            size: const Size(0.22, 0.22),
          ),

          DragItem(
            id: 'correct_3',
            image: 'assets/images/${correctItems[2]}',
            startPosition: const Offset(0.72, 0.14),
            size: const Size(0.22, 0.22),
          ),
        ],
      ),
    ];

    _isInitialized = true;
  }

  Future<void> _onItemAnswered(Map<String, String?> answers) async {
    setState(() {
      _showHand = false;
    });

    await AudioService.playAndWait(fileName: "colors/correct_bell.mp3");

    await Future.delayed(const Duration(milliseconds: 700));

    if (_currentQuestionIndex < 2) {
      setState(() {
        _currentQuestionIndex++;
        _showHand = true;
      });

      await Future.delayed(const Duration(milliseconds: 500));

      _playQuestionAudio();
    } else {
      widget.onCompleted();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        // background
        Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color(0xffFCFCFC),
        ),

        // drag drop
        DragDropWidget(
          key: ValueKey('color_q_$_currentQuestionIndex'),

          question: _quizQuestions[_currentQuestionIndex],

          onAnswered: _onItemAnswered,

          onWrongDrop: () async {
            await AudioService.play(fileName: "colors/wrong_buzz.mp3");
          },

          onDragStart: () {
            if (_showHand) {
              setState(() {
                _showHand = false;
              });
            }
          },
        ),

        // animated hand
        if (_showHand) const _AnimatedHandGuide(),
      ],
    );
  }
}

class _AnimatedHandGuide extends StatefulWidget {
  const _AnimatedHandGuide();

  @override
  State<_AnimatedHandGuide> createState() => _AnimatedHandGuideState();
}

class _AnimatedHandGuideState extends State<_AnimatedHandGuide>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0,
      end: 18,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Positioned(
            left: MediaQuery.of(context).size.width * 0.18,
            top: MediaQuery.of(context).size.height * 0.26 + _animation.value,

            child: Opacity(
              opacity: 0.85,
              child: Image.asset(
                'assets/images/animated_hand-Photoroom.png',
                width: 90,
              ),
            ),
          );
        },
      ),
    );
  }
}
