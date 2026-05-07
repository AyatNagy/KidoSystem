import 'package:flutter/material.dart';

import '../Painter/family_painter.dart';

class AnimatedFamilyIcon extends StatefulWidget {
  final double size;

  const AnimatedFamilyIcon({super.key, this.size = 100});

  @override
  State<AnimatedFamilyIcon> createState() => _AnimatedFamilyIconState();
}

class _AnimatedFamilyIconState extends State<AnimatedFamilyIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _animation = CurvedAnimation(
      parent: _controller,
      curve:
      Curves.easeInOutBack,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        double verticalOffset = _animation.value * -15.0;
        double rotationAngle = (_animation.value - 0.5) * 0.1;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform(
              alignment: Alignment.center,
              transform:
              Matrix4.identity()
                ..translate(0.0, verticalOffset)
                ..rotateZ(rotationAngle),
              child: SizedBox(
                width: widget.size,
                height: widget.size,
                child: CustomPaint(
                  painter: FamilyPainter(),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Opacity(
              opacity: 0.15 - (_animation.value * 0.08),
              child: Transform.scale(
                scaleX: 1.0 - (_animation.value * 0.25),
                child: Container(
                  width: widget.size * 0.35,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(blurRadius: 8, spreadRadius: 2),
                    ],
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
