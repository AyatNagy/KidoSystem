import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kido/Models/sense_data.dart';
import 'package:kido/Pages/content/senses/sense_drag_practice_page.dart';
import 'package:kido/Widgets/content/level1/sense_face_view.dart';
import 'package:kido/Widgets/next_button.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import 'package:kido/data/sense_mapper.dart';
import 'package:kido/enum/sense_type.dart';
import 'package:kido/services/audio_service.dart';
import 'package:lottie/lottie.dart';

class SenseTapPracticeScreen extends StatefulWidget {
  final SenseType type;

  const SenseTapPracticeScreen({super.key, required this.type});

  @override
  State<SenseTapPracticeScreen> createState() => _SenseTapPracticeScreenState();
}

class _SenseTapPracticeScreenState extends State<SenseTapPracticeScreen> {
  late final SenseData data;

  bool isPlaying = false;
  bool showHint = false;
  bool isCompleted = false;
  bool showSuccessUI = false;
  bool showNextButton = false;

  Timer? timer;

  @override
  void initState() {
    super.initState();
    data = SenseMapper.get(widget.type);
    _start();
  }

  void _start() async {
    await AudioService.play(fileName: data.questionAudio);
    _startHintTimer();
  }

  void _startHintTimer() {
    timer?.cancel();
    timer = Timer(const Duration(seconds: 3), () {
      if (!mounted || isCompleted) return;
      _showHintWithVoice();
    });
  }

  void _showHintWithVoice() async {
    if (!mounted || isCompleted) return;

    setState(() => showHint = true);
    AudioService.play(fileName: data.questionAudio);

    await Future.delayed(const Duration(milliseconds: 1200));

    if (mounted && !isCompleted) {
      setState(() => showHint = false);
      _startHintTimer();
    }
  }

  Rect _getRect(double w, double h) {
    final x = w * data.leftFactor;
    final y = h * data.topFactor;
    final size = w * data.widthFactor;
    double extraWidth = size * 0.3;

    return Rect.fromLTWH(x - (extraWidth / 2), y, size + extraWidth, size);
  }

  void _onTap(TapDownDetails d, double w, double h) async {
    if (isCompleted) return;
    timer?.cancel();

    if (_getRect(w, h).contains(d.localPosition)) {
      // ✅ إجابة صحيحة
      setState(() {
        isCompleted = true;
        showHint = false;
        isPlaying = true;
        showSuccessUI = true;
      });

      await AudioService.play(fileName: "yaay.mp3");
      await Future.delayed(const Duration(milliseconds: 1500));
      await AudioService.play(fileName: data.audio);

      if (mounted) {
        setState(() {
          isPlaying = false;
          showNextButton = true;
        });
      }
    } else {
      // ❌ إجابة خاطئة
      _showHintWithVoice();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    AudioService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);
    final w = config.localWidth;
    final h = config.localHeight;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: w,
          height: h,
          child: Stack(
            children: [
              // الوجه الأساسي والتفاعل
              GestureDetector(
                onTapDown: (d) => _onTap(d, w, h),
                child: SenseFaceView(
                  data: data,
                  width: w,
                  height: h,
                  faceImage: data.faceWithoutFeature,
                  isPlaying: isPlaying || showHint,
                ),
              ),

              // طبقة الاحتفال (فقط الأنيميشن)
              if (showSuccessUI)
                Positioned.fill(
                  child: Lottie.asset(
                    'assets/lottie/CONFETTI.json',
                    fit: BoxFit.cover,
                    repeat: false, // يشتغل مرة واحدة عند النجاح
                  ),
                ),

              // زر التالي
              if (showNextButton)
                Positioned(
                  bottom: 40,
                  right: 40,
                  child: NextButton(
                    color: Colors.green,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => SenseDragPracticeScreen(type: widget.type),
                        ),
                      );
                    },
                  ),
                ),

              // زر الرجوع
              Positioned(
                top: 40,
                left: 20,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.grey),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
