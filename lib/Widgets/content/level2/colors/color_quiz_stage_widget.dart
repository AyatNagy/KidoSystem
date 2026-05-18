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

class _ColorQuizStageWidgetState extends State<ColorQuizStageWidget> {
  int _currentQuestionIndex = 0;
  List<DragDropQuestion> _quizQuestions = [];
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
    if (_quizQuestions.isNotEmpty &&
        _currentQuestionIndex < _quizQuestions.length) {
      await AudioService.playAndWait(
        fileName: _quizQuestions[_currentQuestionIndex].questionAudio,
      );
    }
  }

  void _generateQuestions() {
    final correctImages = widget.colorTarget.targetImages;

    // تجميع كل صور التشتيت من الألوان الأخرى في المجموعة
    final otherColors =
        widget.currentGroup.colors
            .where((c) => c.id != widget.colorTarget.id)
            .toList();

    List<String> allDistractors = [];
    for (final color in otherColors) {
      allDistractors.addAll(color.targetImages);
    }

    // لو مفيش مشتتات كفاية بنحط صور احتياطية
    if (allDistractors.isEmpty) {
      allDistractors = ['animals/cow.png', 'animals/cat.png'];
    }

    List<DragDropQuestion> generatedQuestions = [];

    // توليد سؤال لكل صورة صحيحة متاحة للون الحالي
    for (int i = 0; i < correctImages.length; i++) {
      final correctImg = correctImages[i];

      // اختيار مشتتات عشوائية ومختلفة في كل سؤال
      List<String> currentDistractors = List.from(allDistractors)..shuffle();
      final wrong1 = currentDistractors[0];
      final wrong2 =
          currentDistractors.length > 1
              ? currentDistractors[1]
              : currentDistractors[0];

      // تجهيز العناصر الثلاثة (1 صح و 2 غلط)
      List<DragItem> items = [
        DragItem(
          id: 'correct_$i',
          image: 'assets/images/$correctImg',
          startPosition: Offset.zero, // هيتم توزيعها عشوائياً بالأسفل
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

      // خلط (Shuffle) العناصر عشان مكان الإجابة الصح يتغير في كل سؤال
      items.shuffle();

      // إعادة تعيين الـ Positions الأفقية بناءً على الترتيب العشوائي الجديد
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
    setState(() {
      _showHand = false;
    });

    await AudioService.playAndWait(fileName: "colors/correct_bell.mp3");
    await Future.delayed(const Duration(milliseconds: 400));

    if (_currentQuestionIndex < _quizQuestions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _showHand = true;
      });
      await Future.delayed(const Duration(milliseconds: 300));
      _playQuestionAudio();
    } else {
      widget.onCompleted();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized || _quizQuestions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // تحديد مكان اليد بناءً على أول عنصر في السؤال الحالي (أياً كان نوعه لتبسيط التوجيه البصري)
    final firstItemPos =
        _quizQuestions[_currentQuestionIndex].items.first.startPosition;

    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color(0xffFCFCFC),
        ),
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
        if (_showHand)
          _AnimatedHandGuide(
            startX: firstItemPos.dx + 0.05,
            startY: firstItemPos.dy + 0.05,
          ),
      ],
    );
  }
}

// تعديل اليد المساعدة لتستقبل إحداثيات ديناميكية متوافقة مع الأجهزة
class _AnimatedHandGuide extends StatefulWidget {
  final double startX;
  final double startY;
  const _AnimatedHandGuide({required this.startX, required this.startY});

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
      end: 15,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Positioned(
            left: size.width * widget.startX,
            top: (size.height * widget.startY) + _animation.value,
            child: Opacity(
              opacity: 0.85,
              child: Image.asset(
                'assets/images/animated_hand-Photoroom.png',
                width: size.isTablet ? 120 : 80, // دعم نسبي للتابلت
              ),
            ),
          );
        },
      ),
    );
  }
}

extension on Size {
  bool get isTablet => width > 600;
}
