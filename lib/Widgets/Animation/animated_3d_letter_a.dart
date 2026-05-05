import 'package:flutter/material.dart';

class ThreeDLetterAPainter extends CustomPainter {
  final Color primaryColor;
  final Color depthColor;

  ThreeDLetterAPainter({
    this.primaryColor = const Color(0xFFFFD54F),
    this.depthColor = const Color(0xFFFBC02D),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    final double depthOffset = width * 0.08;

    final paintFront =
        Paint()
          ..color = primaryColor
          ..style = PaintingStyle.fill;
    final paintDepth =
        Paint()
          ..color = depthColor
          ..style = PaintingStyle.fill;

    Path pathDepth = Path();
    pathDepth.moveTo(width * 0.15 + depthOffset, height * 0.9 + depthOffset);
    pathDepth.lineTo(width * 0.45 + depthOffset, height * 0.1 + depthOffset);
    pathDepth.lineTo(width * 0.55 + depthOffset, height * 0.1 + depthOffset);
    pathDepth.lineTo(width * 0.85 + depthOffset, height * 0.9 + depthOffset);
    pathDepth.close();
    canvas.drawPath(pathDepth, paintDepth);

    Path pathFront = Path();
    pathFront.moveTo(width * 0.15, height * 0.9);
    pathFront.lineTo(width * 0.45, height * 0.1);
    pathFront.lineTo(width * 0.55, height * 0.1);
    pathFront.lineTo(width * 0.85, height * 0.9);
    pathFront.lineTo(width * 0.70, height * 0.9);
    pathFront.lineTo(width * 0.50, height * 0.35);
    pathFront.lineTo(width * 0.30, height * 0.9);
    pathFront.close();

    pathFront.moveTo(width * 0.37, height * 0.65);
    pathFront.lineTo(width * 0.63, height * 0.65);
    pathFront.lineTo(width * 0.59, height * 0.55);
    pathFront.lineTo(width * 0.41, height * 0.55);
    pathFront.close();

    canvas.drawPath(pathFront, paintFront);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AnimatedThreeDLetterA extends StatefulWidget {
  final double size;

  const AnimatedThreeDLetterA({super.key, this.size = 100});

  @override
  State<AnimatedThreeDLetterA> createState() => _AnimatedThreeDLetterAState();
}

class _AnimatedThreeDLetterAState extends State<AnimatedThreeDLetterA>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
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
        double rotationAngle = (_animation.value - 0.5) * 0.2;

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
                   painter: ThreeDLetterAPainter(),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Opacity(
              opacity: 0.2 - (_animation.value * 0.1),
              child: Transform.scale(
                scaleX: 1.0 - (_animation.value * 0.3),
                child: Container(
                  width: widget.size * 0.5,
                  height: 5,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    boxShadow: [BoxShadow(blurRadius: 10, spreadRadius: 2)],
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
