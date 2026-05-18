// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
  bool _showConfetti = false;

  late AnimationController _entranceController;
  late AnimationController _floatingController;
  late Animation<double> _floatingAnimation;
  Timer? _balloonTimer;

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _floatingAnimation = Tween<double>(begin: -4.0, end: 4.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    _entranceController.forward().then((_) async {
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        _startBalloonTimer();
      }
    });
  }

  void _startBalloonTimer() {
    _balloonTimer?.cancel();
    if (_poppedCount >= 4 || !mounted) return;

    _balloonTimer = Timer(const Duration(seconds: 2), () {
      _popNextBalloonAutomatically();
    });
  }

  void _popNextBalloonAutomatically() {
    if (_isProcessing || _poppedCount >= 4) return;

    for (int i = 0; i < _isPopped.length; i++) {
      if (!_isPopped[i]) {
        _popBalloon(i);
        break;
      }
    }
  }

  Future<void> _popBalloon(int index) async {
    if (_isPopped[index]) return;
    if (_isProcessing) return;

    _balloonTimer?.cancel();
    _isProcessing = true;

    setState(() {
      _isPopped[index] = true;
      _poppedCount++;
    });

    // 1️⃣ تشغيل صوت الفرقعة على الـ Player المنفصل (بدون await)
    AudioService.playEffect(fileName: 'colors/ballon_pop.mp3');

    // 2️⃣ انتظار بسيط عشان الفرقعة تبان قبل نطق اسم اللون
    await Future.delayed(const Duration(milliseconds: 300));

    // 3️⃣ نطق اسم اللون بالدالة الأساسية القديمة والانتظار حتى ينتهي
    await AudioService.playAndWait(fileName: widget.colorTarget.introAudio);

    _isProcessing = false;

    if (_poppedCount == 4) {
      setState(() {
        _showConfetti = true;
      });

      await AudioService.playAndWait(fileName: 'party_blower.mp3');
      await Future.delayed(const Duration(milliseconds: 1800));

      if (mounted) {
        widget.onCompleted();
      }
      return;
    }

    _startBalloonTimer();
  }

  @override
  void dispose() {
    _balloonTimer?.cancel();
    _entranceController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveProvider.of(context);

    return Stack(
      children: [
        // ⚪ تعديل الخلفية: شاشة بيضاء سادة تماماً وبدون أي تدرج ألوان أو توهج
        Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color(0xffFCFCFC),
        ),

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
                onTap: () {
                  _popBalloon(index);
                },
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
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
                              _floatingAnimation,
                            ]),
                            builder: (context, child) {
                              final double entranceValue =
                                  CurvedAnimation(
                                    parent: _entranceController,
                                    curve: Curves.easeOutCubic,
                                  ).value;

                              final double slideUp =
                                  (1.0 - entranceValue) * 600.0;
                              final double floatingY = _floatingAnimation.value;

                              return Transform.translate(
                                offset: Offset(0, slideUp + floatingY),
                                child: child,
                              );
                            },
                            // 🎈 تعديل البالونة: تم إزالة الـ BoxDecoration والـ BoxShadow تماماً من هنا لشيل الظل الأصفر
                            child: Image.asset(
                              'assets/images/${widget.colorTarget.balloonImage}',
                              fit: BoxFit.contain,
                            ),
                          ),
                ),
              );
            },
          ),
        ),

        if (_showConfetti)
          IgnorePointer(
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Lottie.asset(
                'assets/lottie/confetti.json',
                fit: BoxFit.cover,
                repeat: false,
              ),
            ),
          ),
      ],
    );
  }
}
