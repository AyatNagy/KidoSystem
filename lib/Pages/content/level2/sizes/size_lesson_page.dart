import 'package:flutter/material.dart';
import 'package:kido/Models/level2/size_model.dart';
import 'package:kido/Pages/content/level2/sizes/size_practice_page.dart';
import 'package:kido/Widgets/Buttons/next_button.dart';
import 'package:kido/Widgets/content/content_app_bar.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import 'package:kido/enum/size_goal.dart';
import 'package:kido/services/audio_service.dart';
import '../../../../data/content/level2/size/size_data.dart';

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
      await Future.delayed(const Duration(milliseconds: 1500));
      if (!mounted) return;
      setState(() => isFirstHighlighted = false);
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
      isPlaying = true;
      isFirstHighlighted = true;
    });
    await AudioService.play(fileName: data.audio);
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
          scaleX = 0.95;
          scaleY = 0.7;
          translateY = 10;
          break;
        case SizeGoal.fat:
          scaleX = 1.6;
          scaleY = 0.9;
          translateY = 5;
          break;
        case SizeGoal.thin:
          scaleX = 0.4;
          scaleY = 1.1;
          translateY = -5;
          break;
        case SizeGoal.big:
          scaleX = 1.5;
          scaleY = 1.5;
          translateY = -15;
          break;
        case SizeGoal.small:
          scaleX = 0.5;
          scaleY = 0.5;
          translateY = 0;
          break;
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F0),
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
                          height:
                              (widget.goal == SizeGoal.small ||
                                      widget.goal == SizeGoal.short)
                                  ? config.imageHeight(0.15)
                                  : config.imageHeight(0.4),
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
                        height: config.imageHeight(0.2),
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
              child: NextButton(
                color: Colors.orange,
                shadowColor: Colors.orangeAccent,
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
