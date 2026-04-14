import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/services.dart';

class MysteryLottieBox extends StatefulWidget {
  const MysteryLottieBox({super.key});

  @override
  State<MysteryLottieBox> createState() => _MysteryLottieBoxState();
}

class _MysteryLottieBoxState extends State<MysteryLottieBox> with TickerProviderStateMixin {
  late final AnimationController _controller;
  bool _isOpened = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!_isOpened) {
      HapticFeedback.heavyImpact();
      _controller.forward();
      setState(() => _isOpened = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F9FF),
      body: Center(
        child: GestureDetector(
          onTap: _handleTap,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (_isOpened)
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Image.asset(
                          'assets/images/arabicLetters/letterأ.png',
                          height: 150
                      ),
                    );
                  },
                ),

              Lottie.asset(
                'assets/lottie/open box.json',
                controller: _controller,
                onLoaded: (composition) {
                  _controller.duration = composition.duration;
                },
                repeat: false,
                animate: false,
                height: 300,
              ),
            ],
          ),
        ),
      ),
    );
  }
}