import 'package:flutter/material.dart';
import 'package:kido/Models/size_lesson_data.dart';
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

  late SizeLessonData data;

  @override
  void initState() {
    super.initState();

    data = SizeLessonMapper.get(widget.goal);

    startLesson();
  }

  Future<void> startLesson() async {
    if (isPlaying) return;

    setState(() {
      isPlaying = true;
      showPracticeButton = false;
    });

    for (int i = 0; i < 3; i++) {
      if (!mounted) return;

      setState(() => isFirstHighlighted = true);

      await Future.delayed(const Duration(milliseconds: 300));

      await AudioService.play(fileName: data.audio);

      setState(() => isFirstHighlighted = false);

      await Future.delayed(const Duration(seconds: 1));
    }

    if (!mounted) return;

    setState(() {
      isPlaying = false;
      showPracticeButton = true;
    });
  }

  // 👇 دي المهمة الجديدة (إعادة الصوت لما الطفل يدوس)
  Future<void> repeatAudio() async {
    if (isPlaying) return;

    setState(() {
      isPlaying = true;
      isFirstHighlighted = true;
    });

    await AudioService.play(fileName: data.audio);

    if (!mounted) return;

    setState(() {
      isPlaying = false;
      isFirstHighlighted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      child: GestureDetector(
                        onTap: repeatAudio, // 👈 هنا
                        child: SizeComparisonItem(
                          imagePath: data.firstImage,
                          isHighlighted: isFirstHighlighted,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: SizeComparisonItem(
                        imagePath: data.secondImage,
                        isHighlighted: false,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 👇 زرار البراكتس
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
