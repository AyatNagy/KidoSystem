import 'package:flutter/material.dart';
import 'package:kido/Models/level2/color_model.dart';
import 'package:kido/Widgets/content/level2/colors/color_intro_widget.dart';
import 'package:kido/Widgets/content/level2/colors/color_mixing_widget.dart';
import 'package:kido/Widgets/content/level2/colors/color_popping_widget.dart';
import 'package:kido/Widgets/content/level2/colors/color_quiz_stage_widget.dart';
import 'package:kido/enum/color_flow.dart';
import 'package:kido/services/audio_service.dart';

class ColorGameScreen extends StatefulWidget {
  final ColorGroup currentGroup;

  const ColorGameScreen({super.key, required this.currentGroup});

  @override
  State<ColorGameScreen> createState() => _ColorGameScreenState();
}

class _ColorGameScreenState extends State<ColorGameScreen> {
  int _currentColorIndex = 0;

  GameStage _currentStage = GameStage.intro;

  @override
  void dispose() {
    AudioService.stop();

    super.dispose();
  }

  void _goToNextColorOrFinish() {
    // لو لسه فيه ألوان تانية
    if (_currentColorIndex < widget.currentGroup.colors.length - 1) {
      setState(() {
        _currentColorIndex++;

        _currentStage = GameStage.intro;
      });
    } else {
      // انتهاء الجروب بالكامل
      AudioService.stop();

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorTarget activeColor =
        widget.currentGroup.colors[_currentColorIndex];

    return Scaffold(
      backgroundColor: const Color(0xffFCFCFC),

      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),

          transitionBuilder: (child, animation) {
            return FadeTransition(opacity: animation, child: child);
          },

          child: _buildCurrentStage(activeColor),
        ),
      ),
    );
  }

  Widget _buildCurrentStage(ColorTarget activeColor) {
    switch (_currentStage) {
      // INTRO
      case GameStage.intro:
        return ColorIntroWidget(
          // الـ key ده مهم جداً عشان الفلوتر يعرف إن الشاشة اتغيرت
          key: ValueKey('intro_${activeColor.id}'),
          colorTarget: activeColor,
          onCompleted: () {
            if (!mounted) return;
            setState(() {
              _currentStage = GameStage.popping; // هينقل هنا فوراً
            });
          },
        );

      // POPPING
      case GameStage.popping:
        return ColorPoppingWidget(
          key: ValueKey('popping_${activeColor.id}'),

          colorTarget: activeColor,

          onCompleted: () {
            if (!mounted) return;

            setState(() {
              _currentStage = GameStage.quiz;
            });
          },
        );

      // QUIZ
      case GameStage.quiz:
        return ColorQuizStageWidget(
          key: ValueKey('quiz_${activeColor.id}'),

          colorTarget: activeColor,

          currentGroup: widget.currentGroup,

          onCompleted: () {
            if (!mounted) return;

            setState(() {
              _currentStage = GameStage.mixing;
            });
          },
        );

      // MIXING
      case GameStage.mixing:
        return ColorMixingWidget(
          key: ValueKey('mixing_${activeColor.id}'),

          currentGroup: widget.currentGroup,

          onGameFinished: _goToNextColorOrFinish,
        );
    }
  }
}
