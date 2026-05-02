import 'package:flutter/material.dart';
import 'dart:math' as math;
class NumberAnimatedHand extends StatefulWidget {
  final List<Offset> pathPoints;
  final BoxConstraints constraints;
  final Offset Function(Offset, BoxConstraints) pxConverter;

  const NumberAnimatedHand({
    super.key,
    required this.pathPoints,
    required this.constraints,
    required this.pxConverter,
  });

  @override
  State<NumberAnimatedHand> createState() => NumberAnimatedHandState();
}

class NumberAnimatedHandState extends State<NumberAnimatedHand> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation <double> opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    
    opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.7), weight: 10), // Fade in
      TweenSequenceItem(tween: ConstantTween(0.7), weight: 80),         // Stay visible
      TweenSequenceItem(tween: Tween(begin: 0.7, end: 0.0), weight: 10), // Fade out
    ]).animate(_controller);

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Offset> pixelPoints = widget.pathPoints
        .map((p) => widget.pxConverter(p, widget.constraints))
        .toList();

    if (pixelPoints.isEmpty) return const SizedBox.shrink();
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        final index = (t * (pixelPoints.length - 1)).clamp(0.0, pixelPoints.length - 1.001);
        final i = index.floor();
        final frac = index - i;
        final pos = Offset.lerp(pixelPoints[i], pixelPoints[i + 1], frac)!;
        final next = pixelPoints[(i + 1).clamp(0, pixelPoints.length - 1)];
        final angle = math.atan2(next.dy - pixelPoints[i].dy, next.dx - pixelPoints[i].dx);

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: pos.dx - 15, 
              top: pos.dy - 5,
              child: Transform.rotate(
                angle: angle + (math.pi / 2), 
                child: Opacity(
                  opacity: 1,
                  child: Image.asset(
                    'assets/images/animated_hand-Photoroom.png',
                    width: 65,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
