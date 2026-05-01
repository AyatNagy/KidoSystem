import 'package:flutter/material.dart';

class ThreeDCarrotPainter extends CustomPainter {
  final Color primaryColor;
  final Color depthColor;
  final Color leafColor;

  ThreeDCarrotPainter({
    this.primaryColor = const Color(0xFFFF9800),
    this.depthColor = const Color(0xFFE65100),
    this.leafColor = const Color(0xFF4CAF50),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    final double depthOffset = width * 0.07;

    final paintFront =
        Paint()
          ..color = primaryColor
          ..style = PaintingStyle.fill;
    final paintDepth =
        Paint()
          ..color = depthColor
          ..style = PaintingStyle.fill;
    final paintLeaf =
        Paint()
          ..color = leafColor
          ..style = PaintingStyle.fill;

    Path pathDepth = Path();
    pathDepth.moveTo(
      width * 0.3 + depthOffset,
      height * 0.2 + depthOffset,
    );
    pathDepth.lineTo(
      width * 0.7 + depthOffset,
      height * 0.2 + depthOffset,
    );
    pathDepth.lineTo(
      width * 0.5 + depthOffset,
      height * 0.9 + depthOffset,
    );
    pathDepth.close();
    canvas.drawPath(pathDepth, paintDepth);

    Path pathFront = Path();
    pathFront.moveTo(width * 0.3, height * 0.2);
    pathFront.lineTo(width * 0.7, height * 0.2);
    pathFront.quadraticBezierTo(
      width * 0.7,
      height * 0.3,
      width * 0.5,
      height * 0.9,
    );
    pathFront.quadraticBezierTo(
      width * 0.3,
      height * 0.3,
      width * 0.3,
      height * 0.2,
    );
    pathFront.close();
    canvas.drawPath(pathFront, paintFront);

    canvas.drawOval(
      Rect.fromLTWH(width * 0.5, height * 0.05, width * 0.15, height * 0.2),
      paintLeaf,
    );
    canvas.drawOval(
      Rect.fromLTWH(width * 0.35, height * 0.05, width * 0.15, height * 0.2),
      paintLeaf,
    );

    final paintLine =
        Paint()
          ..color = Colors.black26
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

    canvas.drawLine(
      Offset(width * 0.4, height * 0.4),
      Offset(width * 0.6, height * 0.42),
      paintLine,
    );
    canvas.drawLine(
      Offset(width * 0.45, height * 0.6),
      Offset(width * 0.55, height * 0.61),
      paintLine,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AnimatedCarrot extends StatefulWidget {
  final double size;
  const AnimatedCarrot({super.key, this.size = 100});

  @override
  State<AnimatedCarrot> createState() => _AnimatedCarrotState();
}

class _AnimatedCarrotState extends State<AnimatedCarrot>
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
      curve: Curves.easeInOutBack,
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
        double rotationAngle = (_animation.value - 0.5) * 0.15;

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
                child: CustomPaint(painter: ThreeDCarrotPainter()),
              ),
            ),
            const SizedBox(height: 5),
            Opacity(
              opacity: 0.15 - (_animation.value * 0.08),
              child: Transform.scale(
                scaleX: 1.0 - (_animation.value * 0.3),
                child: Container(
                  width: widget.size * 0.4,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    boxShadow: [BoxShadow(blurRadius: 8, spreadRadius: 1)],
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
