// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kido/Models/size_lesson_data.dart';
import 'package:kido/Widgets/content/content_app_bar.dart';
import 'package:kido/enum/size_goal.dart';
import 'package:kido/services/audio_service.dart';
import 'package:lottie/lottie.dart'; // لا تنسي إضافة المكتبة

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
  String? selected;
  List<String> wrongSelections = [];
  Timer? hintTimer;
  Timer? startDelayTimer;
  late SizeLessonData data;

  late AnimationController stretchController;
  late Animation<double> stretchAnimation;

  // الإجابة الصحيحة دايماً بنعوض عنها بـ true
  bool get checkIsCorrect => true;

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
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && selected == null) {
        AudioService.play(fileName: data.questionAudio);
      }
    });

    startDelayTimer = Timer(const Duration(seconds: 5), () {
      if (mounted && !showSuccess) {
        setState(() => canAnimate = true);
        stretchController.repeat(reverse: true);
      }
    });

    startHintFlow();
  }

  @override
  void dispose() {
    hintTimer?.cancel();
    startDelayTimer?.cancel();
    AudioService.stop();
    stretchController.dispose();
    super.dispose();
  }

  void startHintFlow() {
    hintTimer = Timer.periodic(const Duration(seconds: 7), (timer) {
      if (selected == null) {
        AudioService.play(fileName: data.questionAudio);
      } else {
        timer.cancel();
      }
    });
  }

  // تعديل المسمى هنا ليكون أوضح (isCorrect بدل isFirst)
  void handleTap(bool isCorrect) async {
    if (isLocked) return;

    String currentKey = isCorrect ? "correct" : "wrong";
    if (wrongSelections.contains(currentKey)) return;

    setState(() {
      isLocked = true;
      selected = currentKey;
    });

    if (isCorrect == checkIsCorrect) {
      hintTimer?.cancel();
      startDelayTimer?.cancel();
      AudioService.stop();

      if (stretchController.isAnimating) {
        await stretchController.animateTo(
          0,
          duration: const Duration(milliseconds: 200),
        );
      }
      if (mounted) {
        setState(() => showSuccess = true);
      }
      //await AudioService.play(fileName: "talleffect.mp3");
      //await Future.delayed(const Duration(milliseconds: 1000));

      if (mounted) {
        setState(() => showSuccess = true);
        AudioService.play(fileName: "yaay.mp3");
      }
      await Future.delayed(const Duration(milliseconds: 2000));

      await AudioService.play(fileName: data.correctAudio);
      await Future.delayed(const Duration(milliseconds: 500));

      await Future.delayed(const Duration(seconds: 1));
      await AudioService.play(fileName: data.audio);
    } else {
      //AudioService.stop();
      //await AudioService.play(fileName: "wrong.wav");
      await Future.delayed(const Duration(seconds: 0));

      if (mounted) {
        setState(() {
          isLocked = false;
          wrongSelections.add(currentKey);
          selected = null;
        });
      }

      if (!stretchController.isAnimating && !showSuccess) {
        setState(() => canAnimate = true);
        stretchController.repeat(reverse: true);
      }
    }
  }

  Matrix4 _getStepTransform(double val) {
    double scaleX = 1.0;
    double scaleY = 1.0;
    double translateY = 0.0;

    switch (widget.goal) {
      case SizeGoal.longShort:
        scaleX = 1.0 - (0.2 * val);
        scaleY = 1.0 + (1.2 * val); // تأثير الطول القوي
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

  Widget buildItem({
    required String keyName,
    required String image,
    required bool isCorrect,
  }) {
    bool isActuallyCorrect = (isCorrect == checkIsCorrect);
    bool shouldBeFaded = wrongSelections.contains(keyName);

    return Expanded(
      child: GestureDetector(
        onTap: () => handleTap(isCorrect),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 400),
          opacity: shouldBeFaded ? 0.3 : 1.0,
          child: AnimatedBuilder(
            animation: stretchAnimation,
            builder: (context, child) {
              bool isAnimatingNow = canAnimate && isActuallyCorrect;

              return Stack(
                alignment: Alignment.center,
                children: [
                  if (isAnimatingNow)
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.yellowAccent.withOpacity(
                              0.5 * stretchAnimation.value,
                            ),
                            blurRadius: 40 * stretchAnimation.value,
                            spreadRadius: 15 * stretchAnimation.value,
                          ),
                        ],
                      ),
                    ),
                  Container(
                    transform:
                        isAnimatingNow
                            ? _getStepTransform(stretchAnimation.value)
                            : Matrix4.identity(),
                    transformAlignment: Alignment.center,
                    child: child,
                  ),
                ],
              );
            },
            child: Image.asset(
              image,
              height: isCorrect ? 300 : 150, // الحجم الطويل عند الاختيار
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
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
                ? _buildSuccessView() // هنا هيتم استدعاء شاشة النجاح
                : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // الصورة الخطأ على الشمال
                    buildItem(
                      keyName: "wrong",
                      image: data.secondImage,
                      isCorrect: false,
                    ),

                    // الصورة الصح على اليمين
                    buildItem(
                      keyName: "correct",
                      image: data.correctImage,
                      isCorrect: true,
                    ),
                  ],
                ),
      ),
    );
  }

  // --- التعديل الجوهري هنا ---
  Widget _buildSuccessView() {
    return Stack(
      children: [
        // لوتي أنيميشن في الخلفية كاحتفال
        Positioned.fill(
          child: Lottie.asset('assets/lottie/CONFETTI.json', fit: BoxFit.cover),
        ),
        // المحتوى الأصلي للنجاح (الصورة والنص)
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 1000),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Container(
                    transform: _getStepTransform(value),
                    transformAlignment: Alignment.center,
                    child: Image.asset(
                      data.correctImage,
                      height: 250,
                    ), // رجعت 350 كما في الأول
                  );
                },
              ),
              const SizedBox(height: 50),
              Text(
                data.title,
                style: const TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
