// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../Widgets/responsive_provider.dart';
import '../../../constants.dart';

class Counting extends StatefulWidget {
  final double sizeMultiplier;
  const Counting({super.key, this.sizeMultiplier = 0.4});

  @override
  State<Counting> createState() => _CountingState();
}

class _CountingState extends State<Counting>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _blockAnimations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _blockAnimations = List.generate(3, (index) {
      double start = index * 0.25;
      double end = start + 0.35;
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, math.min(end, 1.0), curve: Curves.elasticOut),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveProvider.of(context);
    final double logoSize = responsive.imageWidth(widget.sizeMultiplier);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          width: logoSize,
          height: logoSize,
          child: CustomPaint(
            painter: CreativeCountingPainter(
              progress1: _blockAnimations[0].value,
              progress2: _blockAnimations[1].value,
              progress3: _blockAnimations[2].value,
              colors: [
                AppColors.kidoRed,
                AppColors.kidoOrange,
                AppColors.kidoGreen
              ],
            ),
          ),
        );
      },
    );
  }
}

class CreativeCountingPainter extends CustomPainter {
  final double progress1, progress2, progress3;
  final List<Color> colors;

  CreativeCountingPainter({
    required this.progress1,
    required this.progress2,
    required this.progress3,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double unit = size.width / 5;

    _drawShadowBase(canvas, size, unit);

    _drawSmartBlock(canvas, Offset(unit * 1.5, size.height - (unit * 1.5 * progress1)), unit, colors[0], progress1, "1");
    _drawSmartBlock(canvas, Offset(unit * 2.5, size.height - (unit * 1.5 * progress2)), unit, colors[1], progress2, "2");
    _drawSmartBlock(canvas, Offset(unit * 3.5, size.height - (unit * 1.5 * progress3)), unit, colors[2], progress3, "3");
  }

  void _drawShadowBase(Canvas canvas, Size size, double unit) {
    final shadowPaint = Paint()
      ..color = Colors.black12
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(size.width / 2, size.height - 10), width: size.width * 0.8, height: 20),
      shadowPaint,
    );
  }

  void _drawSmartBlock(Canvas canvas, Offset position, double size, Color color, double animValue, String label) {
    if (animValue <= 0.1) return;

    final paintMain = Paint()..color = color;
    final double cornerRadius = size * 0.2;

    if (animValue > 0.8) {
      final glowPaint = Paint()
        ..color = color.withOpacity(0.3 * animValue)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, size * 0.5);
      canvas.drawCircle(Offset(position.dx + size / 2, position.dy - size / 2), size * 0.8, glowPaint);
    }

    RRect outerRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(position.dx, position.dy - size, size, size),
      Radius.circular(cornerRadius),
    );

    canvas.drawRRect(outerRect.shift(const Offset(3, 3)), Paint()..color = Colors.black12);
    canvas.drawRRect(outerRect, paintMain);

    if (animValue > 0.6) {
      _drawFace(canvas, position, size, animValue);
    }
    _drawNumber(canvas, position, size, label, animValue);
  }

  void _drawFace(Canvas canvas, Offset pos, double size, double anim) {
    final eyePaint = Paint()..color = Colors.white;
    final pupilPaint = Paint()..color = Colors.black87;
    final mouthPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    double eyeSize = size * 0.12;
    double faceAlpha = (anim - 0.6) * 2.5;

    canvas.drawCircle(Offset(pos.dx + size * 0.3, pos.dy - size * 0.65), eyeSize, eyePaint..color = Colors.white.withOpacity(faceAlpha));
    canvas.drawCircle(Offset(pos.dx + size * 0.7, pos.dy - size * 0.65), eyeSize, eyePaint);

    canvas.drawCircle(Offset(pos.dx + size * 0.3, pos.dy - size * 0.65), eyeSize * 0.5, pupilPaint..color = Colors.black.withOpacity(faceAlpha));
    canvas.drawCircle(Offset(pos.dx + size * 0.7, pos.dy - size * 0.65), eyeSize * 0.5, pupilPaint);

    var mouthPath = Path();
    mouthPath.addArc(
      Rect.fromCenter(center: Offset(pos.dx + size * 0.5, pos.dy - size * 0.4), width: size * 0.3, height: size * 0.2),
      0, math.pi,
    );
    canvas.drawPath(mouthPath, mouthPaint..color = Colors.black87.withOpacity(faceAlpha));
  }

  void _drawNumber(Canvas canvas, Offset pos, double size, String label, double anim) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          fontSize: size * 0.4,
          fontWeight: FontWeight.bold,
          color: Colors.white.withOpacity(anim),
          shadows: const [Shadow(blurRadius: 5, color: Colors.black26, offset: Offset(2, 2))],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, Offset(pos.dx + (size - textPainter.width) / 2, pos.dy - size - textPainter.height - 5));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}