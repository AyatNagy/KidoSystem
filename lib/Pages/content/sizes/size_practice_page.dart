import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kido/Models/size_lesson_data.dart';
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

  String? selected;

  late AnimationController glowController;
  late Animation<double> glowAnimation;

  Timer? hintTimer;

  late SizeLessonData data;

  bool isAudioPlaying = false;

  /// 🧠 Queue عشان نمنع تداخل الصوت
  Future<void> audioQueue = Future.value();

  bool get isFirstCorrect => true;

  @override
  void initState() {
    super.initState();

    data = SizeLessonMapper.get(widget.goal);

    glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(parent: glowController, curve: Curves.easeInOut));

    startHintFlow();
  }

  /// 🎧 تشغيل صوت بدون تداخل (Queue)
  Future<void> playSequential(String fileName) {
    audioQueue = audioQueue.then((_) async {
      isAudioPlaying = true;
      await AudioService.play(fileName: fileName);
      isAudioPlaying = false;
    });

    return audioQueue;
  }

  void startHintFlow() async {
    await Future.delayed(const Duration(seconds: 1));

    await playSequential(data.questionAudio);

    hintTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (selected == null) {
        playSequential(data.questionAudio);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    glowController.dispose();
    hintTimer?.cancel();
    super.dispose();
  }

  void handleTap(bool isFirst) async {
    if (isLocked) return;

    isLocked = true;
    hintTimer?.cancel();

    bool correct = (isFirst == isFirstCorrect);

    // 👇 التسجيل الفوري بدون أي انتظار للصوت
    setState(() {
      selected = isFirst ? "first" : "second";
    });

    if (correct) {
      setState(() {
        showSuccess = true;
      });

      await playSequential(data.audio);
    } else {
      await playSequential(data.questionAudio);

      await Future.delayed(const Duration(milliseconds: 400));

      setState(() {
        isLocked = false;
      });
    }
  }

  Widget buildItem({
    required String keyName,
    required String image,
    required bool isFirst,
  }) {
    bool isCorrect = isFirstCorrect == isFirst;

    double scale = 1.0;

    if (selected == keyName && !isCorrect) {
      scale = 0.7;
    }

    bool shouldGlow = isCorrect && (selected == null || !showSuccess);

    Widget imageWidget = AnimatedBuilder(
      animation: glowAnimation,
      builder: (context, child) {
        double glow = shouldGlow ? glowAnimation.value : 0;

        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              if (shouldGlow)
                BoxShadow(
                  color: Colors.yellow.withOpacity(glow),
                  blurRadius: 30,
                  spreadRadius: 6,
                ),
            ],
          ),
          child: child,
        );
      },
      child: Image.asset(image),
    );

    return Expanded(
      child: Center(
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 500),
          child: GestureDetector(
            onTap: () => handleTap(isFirst),
            child: imageWidget,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dataLocal = data;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("اختبر نفسك"),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child:
              showSuccess
                  ? AnimatedScale(
                    scale: 1.7,
                    duration: const Duration(milliseconds: 700),
                    curve: Curves.elasticOut,
                    child: Image.asset(dataLocal.firstImage),
                  )
                  : Row(
                    children: [
                      buildItem(
                        keyName: "first",
                        image: dataLocal.firstImage,
                        isFirst: true,
                      ),
                      buildItem(
                        keyName: "second",
                        image: dataLocal.secondImage,
                        isFirst: false,
                      ),
                    ],
                  ),
        ),
      ),
    );
  }
}
