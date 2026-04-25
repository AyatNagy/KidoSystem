import 'package:flutter/material.dart';
import 'package:kido/Models/sense_data.dart';
import 'package:kido/Widgets/content/animated_feature.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import 'package:kido/data/sense_mapper.dart';
import 'package:kido/enum/sense_type.dart';
import 'package:kido/services/audio_service.dart';

class SenseLearningScreen extends StatefulWidget {
  final SenseType type;

  const SenseLearningScreen({super.key, required this.type});

  @override
  State<SenseLearningScreen> createState() => _SenseLearningScreenState();
}

class _SenseLearningScreenState extends State<SenseLearningScreen> {
  late final SenseData data;
  bool isStarted = false;
  bool isPlaying = false; // عشان نمنع تداخل الأصوات

  @override
  void initState() {
    super.initState();
    data = SenseMapper.get(widget.type);
  }

  void _startLesson() {
    setState(() {
      isStarted = true;
    });
    _playInitialLoop();
  }

  // اللوب اللي بتشتغل 5 مرات في البداية
  Future<void> _playInitialLoop() async {
    for (int i = 0; i < 5; i++) {
      if (!mounted) return;
      await _playSound();
      // استراحة بسيطة بين التكرارات
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  // دالة موحدة لتشغيل الصوت مع حماية من التداخل
  Future<void> _playSound() async {
    if (isPlaying) return; // لو الصوت شغال فعلاً، اخرج وما تعملش حاجة

    setState(() {
      isPlaying = true;
    });

    try {
      await AudioService.play(fileName: data.audio);
      // بننتظر وقت كافي للصوت يخلص (مثلاً 2-3 ثواني حسب طول ملفاتك)
      // أو ممكن نستخدم مستمع لحالة المشغل لو الـ Service بتدعم ده
      await Future.delayed(const Duration(seconds: 2));
    } finally {
      if (mounted) {
        setState(() {
          isPlaying = false;
        });
      }
    }
  }

  @override
  void dispose() {
    AudioService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: config.localWidth,
          height: config.localHeight,
          child: GestureDetector(
            // لو الدرس بدأ، أي دوسة على الشاشة تشغل الصوت تاني
            onTap: isStarted ? _playSound : null,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                // 1. صورة الوجه
                Positioned.fill(
                  child: Image.asset(
                    data.faceWithoutFeature,
                    fit: BoxFit.contain,
                  ),
                ),

                // 2. الحاسة المتحركة
                Positioned(
                  top: config.localHeight * data.topFactor,
                  left: config.localWidth * data.leftFactor,
                  child: AnimatedFeature(
                    image: data.featureImage,
                    width: config.localWidth * data.widthFactor,
                    isPlaying: isPlaying, // نمرر حالة الصوت هنا
                  ),
                ),

                // 3. طبقة البداية
                if (!isStarted)
                  GestureDetector(
                    onTap: _startLesson,
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.5),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.play_circle_fill,
                            size: 100,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "ابدأ الدرس",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
