import 'package:flutter/material.dart';
import 'package:kido/Pages/content/sizes/size_practice_page.dart';
import 'package:kido/Widgets/content/sizes/size_comparison_item.dart';
import 'package:kido/Widgets/custom_app_button.dart';
import 'package:kido/enum/size_goal.dart';
import 'package:kido/services/audio_service.dart';

class SizeLessonPage extends StatefulWidget {
  final SizeGoal goal;

  const SizeLessonPage({super.key, required this.goal});

  @override
  State<SizeLessonPage> createState() => _SizeLessonPageState();
}

class _SizeLessonPageState extends State<SizeLessonPage> {
  bool isFirstHighlighted = false;
  bool isPlaying = false;
  bool showPracticeButton = false;

  String get audioFileName {
    switch (widget.goal) {
      case SizeGoal.longShort:
        return "tall.wav";
      case SizeGoal.thickThin:
        return "thick.wav";
      case SizeGoal.bigSmall:
        return "big.wav";
    }
  }

  Map<String, String> get lessonAssets {
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

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 500), startLesson);
  }

  Future<void> startLesson() async {
    if (isPlaying) return;

    setState(() {
      isPlaying = true;
      showPracticeButton = false;
    });

    await Future.delayed(const Duration(seconds: 2));

    for (int i = 0; i < 3; i++) {
      if (!mounted) return;

      setState(() => isFirstHighlighted = true);

      await AudioService.play(fileName: audioFileName);

      setState(() => isFirstHighlighted = false);

      await Future.delayed(const Duration(seconds: 1));
    }

    if (!mounted) return;

    setState(() {
      isPlaying = false;
      showPracticeButton = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final assets = lessonAssets;

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text("تعلم الأحجام"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),

      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),

            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: SizeComparisonItem(
                        imagePath: assets["first"]!,
                        isHighlighted: isFirstHighlighted,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: SizeComparisonItem(
                        imagePath: assets["second"]!,
                        isHighlighted: false,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //عاملى مشاكل انت
            if (showPracticeButton)
              Padding(
                padding: const EdgeInsets.all(20),
                child: CustomGradientButton(
                  title: "يلا نلعب 🎮",
                  width: double.infinity,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SizePracticePage(goal: widget.goal),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
