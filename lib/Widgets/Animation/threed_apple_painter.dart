// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';

class ThreeDApplePainter extends CustomPainter {
  final Color primaryColor;
  final Color depthColor;
  final Color leafColor;
  final Color stemColor;

  ThreeDApplePainter({
    this.primaryColor = const Color(0xFFE57373),
    this.depthColor = const Color(0xFFC62828),
    this.leafColor = const Color(0xFF81C784),
    this.stemColor = const Color(0xFF8D6E63),
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
    pathDepth.moveTo(
      width * 0.5 + depthOffset,
      height * 0.15 + depthOffset,
    );
    pathDepth.cubicTo(
      width * 0.9 + depthOffset,
      height * 0.15 + depthOffset,
      width * 1.0 + depthOffset,
      height * 0.6 + depthOffset,
      width * 0.5 + depthOffset,
      height * 0.9 + depthOffset,
    );
    pathDepth.cubicTo(
      width * 0.0 + depthOffset,
      height * 0.6 + depthOffset,
      width * 0.1 + depthOffset,
      height * 0.15 + depthOffset,
      width * 0.5 + depthOffset,
      height * 0.15 + depthOffset,
    );
    pathDepth.close();
    canvas.drawPath(pathDepth, paintDepth);
    Path pathFront = Path();
    pathFront.moveTo(width * 0.5, height * 0.15);
    pathFront.cubicTo(
      width * 0.9,
      height * 0.15,
      width * 1.0,
      height * 0.6,
      width * 0.5,
      height * 0.9,
    );
    pathFront.cubicTo(
      width * 0.0,
      height * 0.6,
      width * 0.1,
      height * 0.15,
      width * 0.5,
      height * 0.15,
    );
    pathFront.close();
    canvas.drawPath(pathFront, paintFront);
    Paint paintStemFront =
    Paint()
      ..color = stemColor
      ..style = PaintingStyle.fill;
    Paint paintStemDepth =
    Paint()
      ..color = stemColor.withOpacity(0.7)
      ..style = PaintingStyle.fill;
    Path stemDepth = Path();
    stemDepth.moveTo(
      width * 0.48 + depthOffset,
      height * 0.0 + depthOffset,
    );
    stemDepth.lineTo(
      width * 0.52 + depthOffset,
      height * 0.0 + depthOffset,
    );
    stemDepth.lineTo(
      width * 0.50 + depthOffset,
      height * 0.2 + depthOffset,
    );
    stemDepth.close();
    canvas.drawPath(stemDepth, paintStemDepth);
    Path stemFront = Path();
    stemFront.moveTo(width * 0.48, height * 0.0);
    stemFront.lineTo(width * 0.52, height * 0.0);
    stemFront.lineTo(width * 0.50, height * 0.2);
    stemFront.close();
    canvas.drawPath(stemFront, paintStemFront);
    Paint paintLeafFront =
    Paint()
      ..color = leafColor
      ..style = PaintingStyle.fill;
    Paint paintLeafDepth =
    Paint()
      ..color = leafColor.withOpacity(0.7)
      ..style = PaintingStyle.fill;
    Path leafDepth = Path();
    leafDepth.moveTo(
      width * 0.50 + depthOffset,
      height * 0.1 + depthOffset,
    );
    leafDepth.cubicTo(
      width * 0.75 + depthOffset,
      height * 0.0 + depthOffset,
      width * 0.85 + depthOffset,
      height * 0.2 + depthOffset,
      width * 0.50 + depthOffset,
      height * 0.1 + depthOffset,
    );
    leafDepth.close();
    canvas.drawPath(leafDepth, paintLeafDepth);
    Path leafFront = Path();
    leafFront.moveTo(width * 0.50, height * 0.1);
    leafFront.cubicTo(
      width * 0.75,
      height * 0.0,
      width * 0.85,
      height * 0.2,
      width * 0.50,
      height * 0.1,
    );
    leafFront.close();
    canvas.drawPath(leafFront, paintLeafFront);
    Paint paintHighlight =
    Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(width * 0.3, height * 0.35),
      width * 0.08,
      paintHighlight,
    );
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AnimatedCuteApple extends StatefulWidget {
  final double size;

  const AnimatedCuteApple({super.key, this.size = 100});

  @override
  State<AnimatedCuteApple> createState() => _AnimatedCuteAppleState();
}

class _AnimatedCuteAppleState extends State<AnimatedCuteApple>
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
        double rotationAngle =
            (_animation.value - 0.5) * 0.1;

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
                  painter: ThreeDApplePainter(),
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