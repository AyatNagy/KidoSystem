// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:kido/Models/level2/color_model.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import 'package:kido/services/audio_service.dart';

class ColorIntroWidget extends StatefulWidget {
  final ColorTarget colorTarget;
  final VoidCallback onCompleted;

  const ColorIntroWidget({
    super.key,
    required this.colorTarget,
    required this.onCompleted,
  });

  @override
  State<ColorIntroWidget> createState() => _ColorIntroWidgetState();
}

class _ColorIntroWidgetState extends State<ColorIntroWidget>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  late AnimationController _floatingController;
  late Animation<double> _floatingAnimation;

  @override
  void initState() {
    super.initState();

    // breathing animation
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.97, end: 1.03).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    // floating animation
    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);

    _floatingAnimation = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    _playSequence();
  }

  Future<void> _playSequence() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    AudioService.play(fileName: widget.colorTarget.introAudio);

    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    AudioService.play(fileName: widget.colorTarget.introAudio);

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      widget.onCompleted();
    }
  }

  Color _getGlowColor() {
    switch (widget.colorTarget.id) {
      case 'red':
        return Colors.red;

      case 'yellow':
        return Colors.amber;

      case 'blue':
        return Colors.lightBlue;

      case 'green':
        return Colors.green;

      default:
        return Colors.deepPurpleAccent;
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
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

        // back button
        Positioned(
          top: responsive.localHeight * 0.03,
          left: responsive.localWidth * 0.03,
          child: SafeArea(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.black87,
                ),
                onPressed: () {
                  AudioService.stop();
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ),

        // center image
        Center(
          child: AnimatedBuilder(
            animation: Listenable.merge([_scaleAnimation, _floatingAnimation]),
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _floatingAnimation.value),
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: glowColor.withOpacity(0.25),
                          blurRadius: 55,
                          spreadRadius: 8,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/${widget.colorTarget.colorImage}',
                      width:
                          responsive.localWidth *
                          (responsive.isTablet ? 0.32 : 0.62),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
