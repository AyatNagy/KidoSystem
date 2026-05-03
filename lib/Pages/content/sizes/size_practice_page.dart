// ignore_for_file: deprecated_member_use
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kido/Models/size_lesson_data.dart';
import 'package:kido/Widgets/content/choise_item_widget.dart';
import 'package:kido/Widgets/content/content_app_bar.dart';
import 'package:kido/Widgets/content/success_overlay_widget.dart';
import 'package:kido/enum/size_goal.dart';
import 'package:kido/services/audio_service.dart';

class SizePracticePage extends StatefulWidget {
  final SizeGoal goal;

  const SizePracticePage({super.key, required this.goal});

  @override
  State<SizePracticePage> createState() => _SizePracticePageState();
}

class _SizePracticePageState extends State<SizePracticePage>
    with SingleTickerProviderStateMixin {
  bool showSuccess = false;
  bool isLocked = false;
  bool canAnimate = false;
  List<String> wrongSelections = [];
  Timer? hintTimer;
  Timer? startDelayTimer;
  late SizeLessonData data;

  late AnimationController stretchController;
  late Animation<double> stretchAnimation;

  @override
  void initState() {
    super.initState();
    data = SizeLessonMapper.get(widget.goal);

    stretchController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    stretchAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: stretchController, curve: Curves.easeInOut),
    );

    _setupInitialFlow();
  }

  void _setupInitialFlow() {
    // تشغيل صوت السؤال بعد ثانية
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && !showSuccess) {
        AudioService.play(fileName: data.questionAudio);
      }
    });

    // تأخير البدء في تحريك العنصر الصحيح (Hint)
    startDelayTimer = Timer(const Duration(seconds: 5), () {
      if (mounted && !showSuccess) {
        setState(() => canAnimate = true);
        stretchController.repeat(reverse: true);
      }
    });

    startHintFlow();
  }

  void startHintFlow() {
    hintTimer = Timer.periodic(const Duration(seconds: 7), (timer) {
      if (!showSuccess) {
        AudioService.play(fileName: data.questionAudio);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    hintTimer?.cancel();
    startDelayTimer?.cancel();
    AudioService.stop();
    stretchController.dispose();
    super.dispose();
  }

  void handleTap(bool isCorrect) async {
    if (isLocked) return;

    if (isCorrect) {
      setState(() => isLocked = true);
      hintTimer?.cancel();
      startDelayTimer?.cancel();
      AudioService.stop();

      // إيقاف الأنيميشن عند الضغط الصحيح
      if (stretchController.isAnimating) {
        await stretchController.animateTo(
          0,
          duration: const Duration(milliseconds: 200),
        );
      }

      if (mounted) {
        setState(() => showSuccess = true);
        AudioService.play(fileName: "yaay.mp3");
      }

      // تسلسل الأصوات بعد النجاح
      await Future.delayed(const Duration(milliseconds: 2000));
      await AudioService.play(fileName: data.correctAudio);
      await Future.delayed(const Duration(seconds: 1));
      await AudioService.play(fileName: data.audio);
    } else {
      // التعامل مع الإجابة الخاطئة
      if (mounted) {
        setState(() {
          if (!wrongSelections.contains("wrong")) {
            wrongSelections.add("wrong");
          }
        });
      }
    }
  }

  // ميثود لتحديد نوع التحريك بناءً على الهدف (طويل، تخين، كبير)
  Matrix4 _getStepTransform(double val) {
    double scaleX = 1.0;
    double scaleY = 1.0;
    double translateY = 0.0;

    switch (widget.goal) {
      case SizeGoal.longShort:
        scaleX = 1.0 - (0.2 * val);
        scaleY = 1.0 + (1.2 * val);
        translateY = -80 * val;
        break;
      case SizeGoal.thickThin:
        scaleX = 1.0 + (0.6 * val);
        scaleY = 1.0 - (0.1 * val);
        break;
      case SizeGoal.bigSmall:
        scaleX = 1.0 + (0.4 * val);
        scaleY = 1.0 + (0.4 * val);
        translateY = -20 * val;
        break;
    }
    return Matrix4.identity()
      ..translate(0.0, translateY)
      ..scale(scaleX, scaleY);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:
          showSuccess
              ? null
              : PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight),
                child: ContentAppBar(title: "فين الـ ${data.title}"),
              ),
      body: Center(
        child:
            showSuccess
                ? SuccessOverlay(
                  image: data.correctImage,
                  title: data.title,
                  transform: _getStepTransform(1.0), // الحالة النهائية للتحويل
                )
                : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // اختيار الصورة الخطأ
                    ChoiceItem(
                      image: data.secondImage,
                      isWrong: wrongSelections.contains("wrong"),
                      canAnimate: false,
                      animation: stretchAnimation,
                      onTap: () => handleTap(false),
                      transform: Matrix4.identity(),
                      height: 150,
                    ),

                    // اختيار الصورة الصح
                    ChoiceItem(
                      image: data.correctImage,
                      isWrong: false,
                      canAnimate: canAnimate,
                      animation: stretchAnimation,
                      onTap: () => handleTap(true),
                      transform: _getStepTransform(stretchAnimation.value),
                      height: 300,
                    ),
                  ],
                ),
      ),
    );
  }
}
