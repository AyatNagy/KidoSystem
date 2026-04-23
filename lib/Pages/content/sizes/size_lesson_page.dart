import 'package:flutter/material.dart';
import 'package:kido/Models/size_lesson_data.dart';
import 'package:kido/Pages/content/sizes/size_practice_page.dart';
import 'package:kido/Widgets/content/content_app_bar.dart';
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

  // 🛑 إيقاف الصوت لو الطفل خرج من الصفحة فجأة
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

      // 1. شغل الأنيميشن (Highlight)
      setState(() => isFirstHighlighted = true);

      // 2. ابدأ الصوت واستني ثانية بسيطة عشان التزامن البصري
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
    double scaleX = 1.0;
    double scaleY = 1.0;
    double translateY = 0.0;

    if (isFirstHighlighted) {
      switch (widget.goal) {
        case SizeGoal.longShort:
          scaleX = 0.85; // يرفع
          scaleY = 1.6; // يطول جداً
          translateY = -50; // يطلع لفوق عشان م يخبطش تحت
          break;
        case SizeGoal.thickThin:
          scaleX = 1.6; // يعرض جداً (سميك)
          scaleY = 0.9; // يقصر سنة عشان يبان "مكبب"
          translateY = 0;
          break;
        case SizeGoal.bigSmall:
          scaleX = 1.4; // يكبر عرض
          scaleY = 1.4; // يكبر طول
          translateY = -20;
          break;
      }
    }
    return Scaffold(
      backgroundColor: Colors.white, // خلفية بيضاء للتركيز
      appBar: ContentAppBar(title: data.title), // العنوان بيج وهادئ
      body: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 1. العنصر المستهدف (الذي يتم شرحه)
                Expanded(
                  flex: 3,
                  child: Center(
                    child: GestureDetector(
                      onTap: repeatAudio,
                      child: AnimatedContainer(
                        duration: const Duration(
                          milliseconds: 1200,
                        ), // زودنا الوقت عشان يبقى ناعم وسلس
                        curve:
                            Curves
                                .easeInOutBack, // الحركة تبقى أهدى وشكلها طفولي أكتر
                        transform:
                            Matrix4.identity()
                              ..translate(0.0, translateY)
                              ..scale(scaleX, scaleY),

                        transformAlignment: Alignment.center,
                        child: Image.asset(
                          data.correctImage,
                          height: 400, // حجم كبير وثابت من الأول
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),

                // 2. العنصر المقارن (الصغير / القصير / الرفيع)
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Opacity(
                      opacity: 0.6, // خليه باهت شوية عشان الطفل ميتشتتش
                      child: Image.asset(
                        data.secondImage,
                        height: 150, // دايماً صغير مقارنة بالتاني
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // زرار الانتقال للعب
          if (showPracticeButton)
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: CustomGradientButton(
                title: "يلا نلعب 🎮",
                onPressed: () {
                  // نوقف أي صوت قبل ما ننتقل للصفحة الجديدة
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
