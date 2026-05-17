import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kido/Models/level2/color_model.dart';
import 'package:kido/Models/exams/draganddrop_question.dart';
import 'package:kido/Models/dragable_item.dart';
import 'package:kido/Models/targets_item.dart';
import 'package:kido/Widgets/content/draganddrop.dart';
import 'package:kido/services/audio_service.dart';

class ColorMixingWidget extends StatefulWidget {
  final ColorGroup currentGroup;
  final VoidCallback onGameFinished;

  const ColorMixingWidget({
    super.key,
    required this.currentGroup,
    required this.onGameFinished,
  });

  @override
  State<ColorMixingWidget> createState() => _ColorMixingWidgetState();
}

class _ColorMixingWidgetState extends State<ColorMixingWidget> {
  late DragDropQuestion _mixingQuestion;

  bool _isInitialized = false;

  bool _showCelebration = false;

  late ColorTarget targetColor;

  @override
  void initState() {
    super.initState();

    _generateMixingQuestion();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _playCommand();
    });
  }

  Future<void> _playCommand() async {
    await AudioService.playAndWait(fileName: targetColor.mixingCommandAudio);
  }

  void _generateMixingQuestion() {
    // اختيار لون عشوائي من المجموعة
    targetColor =
        widget.currentGroup.colors[Random().nextInt(
          widget.currentGroup.colors.length,
        )];

    // باقي الألوان للتشتيت
    final otherColors =
        widget.currentGroup.colors
            .where((c) => c.id != targetColor.id)
            .toList();

    List<String> distractorImages = [];

    for (final color in otherColors) {
      distractorImages.addAll(color.targetImages);
    }

    final distractor1 =
        distractorImages.isNotEmpty ? distractorImages[0] : 'animals/cow.png';

    final distractor2 =
        distractorImages.length > 1 ? distractorImages[1] : 'animals/cow.png';

    final correctImage = targetColor.targetImages.first;

    _mixingQuestion = DragDropQuestion(
      questionAudio: targetColor.mixingCommandAudio,

      targets: [
        // كل الباسكتات
        for (int i = 0; i < widget.currentGroup.colors.length; i++)
          DragTargetZone(
            id: widget.currentGroup.colors[i].id,

            acceptedItemIds:
                widget.currentGroup.colors[i].id == targetColor.id
                    ? ['correct_item']
                    : [],

            position: Offset(0.10 + (i * 0.42), 0.62),

            size: const Size(0.30, 0.30),

            image: 'assets/images/${widget.currentGroup.colors[i].bucketImage}',
          ),
      ],

      items: [
        // العنصر الصح
        DragItem(
          id: 'correct_item',

          image: 'assets/images/$correctImage',

          startPosition: const Offset(0.08, 0.14),

          size: const Size(0.22, 0.22),
        ),

        // تشتيت
        DragItem(
          id: 'wrong_1',

          image: 'assets/images/$distractor1',

          startPosition: const Offset(0.40, 0.14),

          size: const Size(0.22, 0.22),
        ),

        // تشتيت
        DragItem(
          id: 'wrong_2',

          image: 'assets/images/$distractor2',

          startPosition: const Offset(0.72, 0.14),

          size: const Size(0.22, 0.22),
        ),
      ],
    );

    _isInitialized = true;
  }

  Future<void> _onAnswered(Map<String, String?> answers) async {
    if (!answers.containsKey('correct_item')) {
      return;
    }

    setState(() {
      _showCelebration = true;
    });

    // حطي هنا الـ celebration widget بتاعك
    // أو شغلي الكونفيتي اللي عندك

    await AudioService.playAndWait(fileName: "colors/level_complete.mp3");

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      widget.onGameFinished();
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
          key: const ValueKey('mixing_question'),

          question: _mixingQuestion,

          onAnswered: _onAnswered,

          onWrongDrop: () async {
            await AudioService.play(fileName: "colors/wrong_buzz.mp3");
          },
        ),

        // celebration overlay
        if (_showCelebration)
          // 👇 حطي هنا الـ widget
          // اللي عندك للاحتفال
          Container(color: Colors.white.withOpacity(0.25)),
      ],
    );
  }
}
