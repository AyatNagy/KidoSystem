// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // استيراد مكتبة الـ Lottie لعرض ملف الجيسون
import 'package:kido/Models/level2/color_model.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import 'package:kido/services/audio_service.dart';

class ColorPoppingWidget extends StatefulWidget {
  final ColorTarget colorTarget;
  final VoidCallback onCompleted;

  const ColorPoppingWidget({
    super.key,
    required this.colorTarget,
    required this.onCompleted,
  });

  @override
  State<ColorPoppingWidget> createState() => _ColorPoppingWidgetState();
}

class _ColorPoppingWidgetState extends State<ColorPoppingWidget>
    with TickerProviderStateMixin {
  final List<bool> _isPopped = [false, false, false, false];
  int _poppedCount = 0;
  bool _isProcessing = false;
  bool _showConfetti = false; // متغيّر للتحكم في ظهور أنيميشن الاحتفال الجيسون

  late AnimationController _backgroundController;

  // أنيميشن طيران ودخول البلالين من تحت الشاشة لفوق
  late AnimationController _entranceController;

  // أنيميشن الاهتزاز الخفيف للبلالين وهي واقفة مكانها
  late AnimationController _floatingController;

  Timer? _autoPopTimer;

  @override
  void initState() {
    super.initState();

    // 1. أنيميشن الخلفية
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    // 2. أنيميشن طيران البلالين من تحت لفوق عند البداية
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // 3. أنيميشن الاهتزاز اللطيف (Floating) للبلالين وهي واقفة
    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // تشغيل أنيميشن الطيران فوراً، وبدء تايمر الـ 3 ثوانٍ لما البلالين تستقر
    _entranceController.forward().then((_) {
      _startAutoPopTimer();
    });
  }

  // بدء عداد الـ 3 ثوانٍ للمساعدة التلقائية
  void _startAutoPopTimer() {
    _autoPopTimer?.cancel();
    if (_poppedCount >= 4) return;

    _autoPopTimer = Timer(const Duration(seconds: 3), () {
      _popNextBalloonAutomatically();
    });
  }

  // فرقعة البالونة التالية تلقائياً لو الطفل اتأخر
  void _popNextBalloonAutomatically() {
    for (int i = 0; i < _isPopped.length; i++) {
      if (!_isPopped[i]) {
        _popBalloon(i);
        break;
      }
    }
  }

  Color _getGlowColor() {
    switch (widget.colorTarget.id) {
      case 'red':
        return Colors.redAccent;
      case 'yellow':
        return Colors.amber;
      case 'blue':
        return Colors.lightBlueAccent;
      case 'green':
        return Colors.greenAccent;
      default:
        return Colors.deepPurpleAccent;
    }
  }

  Future<void> _popBalloon(int index) async {
    if (_isPopped[index]) return;
    if (_isProcessing) return;

    // بنوقف التايمر مؤقتاً علشان الأصوات والفرقعة ما يدخلوش في بعض
    _autoPopTimer?.cancel();
    _isProcessing = true;

    setState(() {
      _isPopped[index] = true;
      _poppedCount++;
    });

    // 1. تشغيل صوت الفرقعة
    await AudioService.playAndWait(fileName: 'colors/ballon_pop.mp3');

    await Future.delayed(const Duration(milliseconds: 50));

    // 2. تشغيل صوت اسم اللون المظبوط
    await AudioService.playAndWait(fileName: widget.colorTarget.introAudio);

    _isProcessing = false;

    // التحقق من انتهاء المرحلة (كل البلالين اتفرقعت)
    if (_poppedCount == 4) {
      // إظهار أنيميشن الاحتفال (الكونفيتي) في الـ Stack
      setState(() {
        _showConfetti = true;
      });

      // 🎉 تشغيل صوت زمارة الاحتفال فوراً مع ظهور الكونفيتي
      await AudioService.playAndWait(fileName: 'party_blower.mp3');

      // وقت إضافي علشان الطفل يستمتع بالكونفيتي والاحتفال قبل النقل للمرحلة الجاية
      await Future.delayed(const Duration(milliseconds: 1800));

      if (mounted) {
        widget.onCompleted();
      }
    } else {
      // لو لسه فيه بلالين، بنشغل التايمر تاني للبالونة اللي بعدها
      _startAutoPopTimer();
    }
  }

  @override
  void dispose() {
    _autoPopTimer?.cancel();
    _backgroundController.dispose();
    _entranceController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveProvider.of(context);
    final glowColor = _getGlowColor();

    return Stack(
      children: [
        // background
        Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color(0xffFCFCFC),
        ),

        // animated glow
        AnimatedBuilder(
          animation: _backgroundController,
          builder: (context, child) {
            return Opacity(
              opacity: 0.08,
              child: Center(
                child: Container(
                  width:
                      responsive.localWidth *
                      (0.55 + (_backgroundController.value * 0.1)),
                  height:
                      responsive.localWidth *
                      (0.55 + (_backgroundController.value * 0.1)),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: glowColor,
                  ),
                ),
              ),
            );
          },
        ),

        // balloons grid
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.localWidth * 0.08,
            vertical: responsive.localHeight * 0.06,
          ),
          child: GridView.builder(
            itemCount: 4,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: responsive.localWidth * 0.06,
              mainAxisSpacing: responsive.localHeight * 0.04,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              final popped = _isPopped[index];

              return GestureDetector(
                onTap: () => _popBalloon(index),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: FadeTransition(opacity: animation, child: child),
                    );
                  },
                  child:
                      popped
                          ? Image.asset(
                            'assets/images/${widget.colorTarget.splashImage}',
                            key: ValueKey('splash_$index'),
                            fit: BoxFit.contain,
                          )
                          : AnimatedBuilder(
                            key: ValueKey('balloon_$index'),
                            animation: Listenable.merge([
                              _entranceController,
                              _floatingController,
                            ]),
                            builder: (context, child) {
                              // 1. حركة الطيران من تحت لفوق عند فتح الشاشة
                              final double entranceValue =
                                  CurvedAnimation(
                                    parent: _entranceController,
                                    curve: Curves.easeOutBack,
                                  ).value;
                              final double slideUp =
                                  (1.0 - entranceValue) * 500.0;

                              // 2. حركة الاهتزاز (الطفو) الخفيفة والبلونة واقفة مكانها
                              final double direction =
                                  (index % 2 == 0) ? 1.0 : -1.0;
                              final double floatingY =
                                  math.sin(
                                    _floatingController.value * math.pi * 2,
                                  ) *
                                  7.0 *
                                  direction;

                              return Transform.translate(
                                offset: Offset(0, slideUp + floatingY),
                                child: child,
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: glowColor.withOpacity(0.22),
                                    blurRadius: 25,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                'assets/images/${widget.colorTarget.balloonImage}',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                ),
              );
            },
          ),
        ),

        // طبقة الاحتفال بالـ JSON (تظهر فوق كل العناصر مغطية الشاشة بالكامل)
        if (_showConfetti)
          IgnorePointer(
            // تمنع تفاعل الطفل مع الشاشة وقت الاحتفال لمنع أي ضغطات غريبة
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Lottie.asset(
                'assets/images/confetti.json', // غيري المسار هنا للاسم والملف المظبوط عندك
                fit: BoxFit.cover,
                repeat: false, // يشتغل مرة واحدة بس مع الزمارة
              ),
            ),
          ),
      ],
    );
  }
}
