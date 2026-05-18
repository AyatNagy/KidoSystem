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

  /// دالة التحكم في الانتقال بين الألوان والمراحل
  void _handleQuizCompleted() {
    if (!mounted) return;

    // لو لسه فيه ألوان تانية في الجروب مخلصتش، انقل للون اللي بعده من أول الـ Intro
    if (_currentColorIndex < widget.currentGroup.colors.length - 1) {
      setState(() {
        _currentColorIndex++;
        _currentStage = GameStage.intro; // يرجع يعيد السايكل للون الجديد
      });
    } else {
      // 💡 لما الألوان كلها تخلص تماماً.. يدخل فوراً على مرحلة الـ Mixing الشاملة للجروب
      setState(() {
        _currentStage = GameStage.mixing;
      });
    }
  }

  void _finishGame() {
    AudioService.stop();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // جلب بيانات اللون النشط حالياً بناءً على الاندكس
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
          // الـ الـ AnimatedSwitcher هيعتمد على الـ الـ Stage والـ Color الفعلي لتأمين ترانزيشن ناعم وبدون كراشات
          child: _buildCurrentStage(activeColor),
        ),
      ),
    );
  }

  Widget _buildCurrentStage(ColorTarget activeColor) {
    switch (_currentStage) {
      // 1️⃣ مرحلة الـ INTRO (التعريف باللون)
      case GameStage.intro:
        return ColorIntroWidget(
          key: ValueKey(
            'intro_${activeColor.id}',
          ), // يضمن مسح الأنيميشن القديم تماماً
          colorTarget: activeColor,
          onCompleted: () {
            if (!mounted) return;
            setState(() {
              _currentStage = GameStage.popping;
            });
          },
        );

      // 2️⃣ مرحلة الـ POPPING (فرقعة البلالين والـ Splash)
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

      // 3️⃣ مرحلة الـ QUIZ (تجميع عناصر اللون جوة الباسكت الخاص بيه)
      case GameStage.quiz:
        return ColorQuizStageWidget(
          key: ValueKey('quiz_${activeColor.id}'),
          colorTarget: activeColor,
          currentGroup: widget.currentGroup,
          onCompleted:
              _handleQuizCompleted, // هيفحص لو هينقل للون التالي أو للـ Mixing
        );

      // 4️⃣ مرحلة الـ MIXING (التصنيف والمكس النهائي للجروب كامل)
      case GameStage.mixing:
        return ColorMixingWidget(
          // هنا بنثبت المفتاح باسم الجروب لأنها شاشة ختامية موحدة للمجموعة
          key: ValueKey('mixing_final_${widget.currentGroup.groupName}'),
          currentGroup: widget.currentGroup,
          onGameFinished: _finishGame, // يقفل الشاشة ويرجع لبرة فوراً بنجاح
        );
    }
  }
}
