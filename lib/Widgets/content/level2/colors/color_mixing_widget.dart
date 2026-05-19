import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kido/Models/dragable_item.dart';
import 'package:kido/Models/exams/draganddrop_question.dart';
import 'package:kido/Models/level2/color_model.dart';
import 'package:kido/Models/targets_item.dart';
import 'package:kido/Widgets/content/level2/colors/color_draganddrop_widget.dart';
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
    final random = Random();

    // اختيار لون عشوائي
    targetColor =
        widget.currentGroup.colors[random.nextInt(
          widget.currentGroup.colors.length,
        )];

    // الألوان الأخرى
    final otherColors =
        widget.currentGroup.colors
            .where((c) => c.id != targetColor.id)
            .toList();

    // تجميع المشتتات
    List<String> distractorImages = [];

    for (final color in otherColors) {
      distractorImages.addAll(color.targetImages);
    }

    if (distractorImages.isEmpty) {
      distractorImages = ['animals/cow.png', 'animals/cat.png'];
    }

    distractorImages.shuffle();

    final distractor1 = distractorImages[0];

    final distractor2 =
        distractorImages.length > 1 ? distractorImages[1] : distractorImages[0];

    // الصورة الصح
    final correctImage =
        targetColor.targetImages[random.nextInt(
          targetColor.targetImages.length,
        )];

    // الباسكتات
    List<DragTargetZone> targets = [];

    int totalColors = widget.currentGroup.colors.length;

    for (int i = 0; i < totalColors; i++) {
      final colorInfo = widget.currentGroup.colors[i];

      List<String> acceptedIds = [];

      if (colorInfo.id == targetColor.id) {
        acceptedIds.add('correct_item');
      }

      double dxPosition =
          totalColors == 2
              ? (0.15 + (i * 0.40))
              : (0.05 + (i * (0.90 / totalColors)));

      targets.add(
        DragTargetZone(
          id: 'basket_${colorInfo.id}',

          acceptedItemIds: acceptedIds,

          position: Offset(dxPosition, 0.62),

          size: const Size(0.28, 0.28),

          image: 'assets/images/${colorInfo.bucketImage}',
        ),
      );
    }

    // العناصر
    List<DragItem> items = [
      DragItem(
        id: 'correct_item',

        image: 'assets/images/$correctImage',

        startPosition: Offset.zero,

        size: const Size(0.22, 0.22),
      ),

      DragItem(
        id: 'wrong_1',

        image: 'assets/images/$distractor1',

        startPosition: Offset.zero,

        size: const Size(0.22, 0.22),
      ),

      DragItem(
        id: 'wrong_2',

        image: 'assets/images/$distractor2',

        startPosition: Offset.zero,

        size: const Size(0.22, 0.22),
      ),
    ];

    items.shuffle();

    final List<Offset> itemPositions = [
      const Offset(0.08, 0.14),

      const Offset(0.40, 0.14),

      const Offset(0.72, 0.14),
    ];

    for (int i = 0; i < items.length; i++) {
      items[i] = DragItem(
        id: items[i].id,

        image: items[i].image,

        startPosition: itemPositions[i],

        size: items[i].size,
      );
    }

    setState(() {
      _mixingQuestion = DragDropQuestion(
        questionAudio: targetColor.mixingCommandAudio,

        targets: targets,

        items: items,
      );

      _isInitialized = true;
    });
  }

  Future<void> _onAnswered(Map<String, String?> answers) async {
    bool correctPlaced = false;

    answers.forEach((itemId, targetId) {
      if (itemId == 'correct_item' && targetId == 'basket_${targetColor.id}') {
        correctPlaced = true;
      }
    });

    if (!correctPlaced) return;

    setState(() {
      _showCelebration = true;
    });

    await AudioService.playAndWait(fileName: "colors/level_complete.mp3");

    await Future.delayed(const Duration(seconds: 1));

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
        Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color(0xffFCFCFC),
        ),

        ColorDragDropWidget(
          key: const ValueKey('mixing_question_key'),

          question: _mixingQuestion,

          highlightCorrect: false,

          onAnswered: _onAnswered,

          onWrongDrop: () async {
            await AudioService.playEffect(fileName: "colors/wrong_buzz.mp3");
          },
        ),

        if (_showCelebration)
          Container(
            color: Colors.black.withOpacity(0.3),

            child: const Center(
              child: Card(
                color: Colors.white,

                child: Padding(
                  padding: EdgeInsets.all(24),

                  child: Text(
                    "ممتاز! 🎉",

                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
