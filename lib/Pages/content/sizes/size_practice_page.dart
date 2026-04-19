import 'dart:async';
import 'package:flutter/material.dart';
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

  bool hasWrongTapped = false;

  // 🎧 الصوت
  String get audioFileName => "where_tall.wav";

  Map<String, String> get assets {
    switch (widget.goal) {
      case SizeGoal.longShort:
        return {
          "first": "assets/images/sizes/tallcandel.png",
          "second": "assets/images/sizes/shortcandel.png",
        };
      case SizeGoal.thickThin:
        return {
          "first": "assets/images/sizes/thick.png",
          "second": "assets/images/sizes/thin.png",
        };
      case SizeGoal.bigSmall:
        return {
          "first": "assets/images/sizes/big.png",
          "second": "assets/images/sizes/small.png",
        };
    }
  }

  bool get isFirstCorrect => true;

  @override
  void initState() {
    super.initState();

    glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(parent: glowController, curve: Curves.easeInOut));

    // 🎯 بداية الدرس
    startHintFlow();
  }

  void startHintFlow() async {
    await Future.delayed(const Duration(seconds: 1));

    await AudioService.play(fileName: audioFileName);

    // ⏳ بعد 5 ثواني لو مفيش اختيار → نعيد التوجيه
    hintTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (selected == null) {
        await AudioService.play(fileName: audioFileName);
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

    bool correct = (isFirst == isFirstCorrect);

    setState(() {
      selected = isFirst ? "first" : "second";
    });

    if (correct) {
      setState(() {
        showSuccess = true;
      });

      await AudioService.play(fileName: "tall_correct.wav");
    } else {
      // ❌ غلط → يصغر ومبيرجعش يكبر
      hasWrongTapped = true;

      await AudioService.play(fileName: audioFileName);

      await Future.delayed(const Duration(milliseconds: 600));

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

    // ❌ الغلط يصغر ويفضل صغير
    if (selected == keyName && !isCorrect) {
      scale = 0.7;
    }

    // 🟢 الصح: يفضل يعمل glow طول الوقت + يتكلم مع الطفل
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
          curve: Curves.easeInOut,
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
    final data = assets;

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
                    child: Image.asset(data["first"]!),
                  )
                  : Row(
                    children: [
                      buildItem(
                        keyName: "first",
                        image: data["first"]!,
                        isFirst: true,
                      ),
                      buildItem(
                        keyName: "second",
                        image: data["second"]!,
                        isFirst: false,
                      ),
                    ],
                  ),
        ),
      ),
    );
  }
}
