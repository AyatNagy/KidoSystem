import 'package:flutter/material.dart';
import 'package:kido/Models/size_lesson_data.dart';
import 'package:kido/Pages/content/sizes/size_practice_page.dart';
import 'package:kido/Widgets/content/content_app_bar.dart';
import 'package:kido/Widgets/Buttons/custom_app_button.dart';
import 'package:kido/Widgets/responsive_provider.dart';
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
  @override
  void dispose() {
    AudioService.stop();
    super.dispose();
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

      await Future.delayed(const Duration(milliseconds: 200));
      await AudioService.play(fileName: data.audio);

      // 3. 🛑 هنا السر: استني وقت كافي عشان الكلمة تخلص (مثلاً 1.5 ثانية)
      // لو الكلمة طويلة زودي الوقت ده
      await Future.delayed(const Duration(milliseconds: 1500));

      if (!mounted) return;

      // 4. طفي الأنيميشن
      setState(() => isFirstHighlighted = false);

      // 5. استراحة قصيرة بين كل مرة والتانية
      await Future.delayed(const Duration(milliseconds: 800));
    }

    if (!mounted) return;

    setState(() {
      isPlaying = false;
      showPracticeButton = true;
    });
  }

  Future<void> repeatAudio() async {
    if (isPlaying) return;

    setState(() {
      isPlaying = true; // نمنع الضغط المتكرر اللي بيبوظ الصوت
      isFirstHighlighted = true;
    });

    await AudioService.play(fileName: data.audio);

    // استني وقت الكلمة قبل ما تشيلي الـ Highlight وتسمحي بضغط جديد
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    setState(() {
      isPlaying = false;
      isFirstHighlighted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);
    double baseTranslate =
        config.isDesktop
            ? -100
            : config.isTablet
            ? -80
            : -50;
    double scaleX = 1.0;
    double scaleY = 1.0;
    double translateY = 0.0;

    if (isFirstHighlighted) {
      switch (widget.goal) {
        case SizeGoal.tall:
          scaleX = 0.85;
          scaleY = 1.6;
          translateY = baseTranslate;
          break;
        case SizeGoal.short:
          scaleX = 1.1;
          scaleY = 0.7;
          translateY = 20; // بيكبسها لتحت عشان تبان قصيرة
          break;
        case SizeGoal.fat:
          scaleX = 1.6;
          scaleY = 0.9;
          translateY = 5;
          break;
        case SizeGoal.thin:
          scaleX = 0.4;
          scaleY = 1.1;
          translateY = -5; // بيخليها رفيعة جداً
          break;
        case SizeGoal.big:
          scaleX = 1.5;
          scaleY = 1.5;
          translateY = -15;
          break;
        case SizeGoal.small:
          scaleX = 0.6;
          scaleY = 0.6;
          translateY = 0; // بيصغرها خالص
          break;
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ContentAppBar(title: data.title),
      body: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: Center(
                    child: GestureDetector(
                      onTap: repeatAudio,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 1200),
                        curve: Curves.easeInOutBack,
                        transform:
                            Matrix4.identity()
                              ..translate(0.0, translateY)
                              ..scale(scaleX, scaleY),
                        transformAlignment: Alignment.center,
                        child: Image.asset(
                          data.correctImage,
                          height: config.imageHeight(0.4), // 40% من الشاشة
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Opacity(
                      opacity: 0.6,
                      child: Image.asset(
                        data.secondImage,
                        height: config.imageHeight(0.2), // 20% من الشاشة
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (showPracticeButton)
            Padding(
              padding: config.pagePadding,
              child: CustomGradientButton(
                title: "يلا نلعب 🎮",
                onPressed: () {
                  AudioService.stop();
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
    );
  }
}
