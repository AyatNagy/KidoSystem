// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
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

  late AnimationController _backgroundController;

  @override
  void initState() {
    super.initState();

    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
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

    _isProcessing = true;

    setState(() {
      _isPopped[index] = true;
      _poppedCount++;
    });

    // صوت الفرقعة
    await AudioService.playAndWait(fileName: 'colors/ballon_pop.mp3');

    await Future.delayed(const Duration(milliseconds: 250));

    // صوت اللون
    await AudioService.playAndWait(fileName: widget.colorTarget.introAudio);

    _isProcessing = false;

    // انتهاء المرحلة
    if (_poppedCount == 4) {
      await Future.delayed(const Duration(milliseconds: 900));

      if (mounted) {
        widget.onCompleted();
      }
    }
  }

  @override
  void dispose() {
    _backgroundController.dispose();
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
                  duration: const Duration(milliseconds: 450),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: FadeTransition(opacity: animation, child: child),
                    );
                  },
                  child:
                      popped
                          ? TweenAnimationBuilder<double>(
                            key: ValueKey('splash_$index'),
                            tween: Tween(begin: 0.6, end: 1),
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.elasticOut,
                            builder: (context, value, child) {
                              return Transform.scale(
                                scale: value,
                                child: child,
                              );
                            },
                            child: Image.asset(
                              'assets/images/${widget.colorTarget.splashImage}',
                              fit: BoxFit.contain,
                            ),
                          )
                          : TweenAnimationBuilder<double>(
                            key: ValueKey('balloon_$index'),
                            tween: Tween(begin: 0.95, end: 1),
                            duration: Duration(
                              milliseconds: 1500 + (index * 200),
                            ),
                            curve: Curves.easeInOut,
                            builder: (context, value, child) {
                              return Transform.scale(
                                scale: value,
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
      ],
    );
  }
}
