// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../Widgets/responsive_provider.dart';
import '../../../constants.dart';

class FiveSensesLogo extends StatefulWidget {
  final double sizeMultiplier;
  const FiveSensesLogo({super.key, this.sizeMultiplier = 0.4});

  @override
  State<FiveSensesLogo> createState() => _FiveSensesLogoState();
}

class _FiveSensesLogoState extends State<FiveSensesLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _senseAnimations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    _senseAnimations = List.generate(5, (index) {
      double start = index * 0.15;
      double end = start + 0.25;
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, math.min(end, 1.0), curve: Curves.bounceInOut),
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
            painter: SensesPainter(
              animations: _senseAnimations.map((a) => a.value).toList(),
              colors: [
                AppColors.kidoRed,
                AppColors.kidoOrange,
                AppColors.kidoGreen,
                AppColors.kidoBlue,
                AppColors.purpleMain,
              ],
            ),
          ),
        );
      },
    );
  }
}

class SensesPainter extends CustomPainter {
  final List<double> animations;
  final List<Color> colors;

  SensesPainter({required this.animations, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double headRadius = size.width * 0.22;

    final headPaint = Paint()
      ..color = Colors.white.withOpacity(0.12)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(centerX, centerY), headRadius, headPaint);
    _drawSimpleFace(canvas, Offset(centerX, centerY), headRadius);
    final double orbitRadius = headRadius * 1.8;
    final List<IconData> senseIcons = [
      Icons.visibility,
      Icons.hearing,
      Icons.spa,
      Icons.touch_app,
      Icons.sentiment_satisfied_alt,
    ];

    for (int i = 0; i < 5; i++) {
      double angle = (i * (360 / 5) - 90) * (math.pi / 180);
      double x = centerX + orbitRadius * math.cos(angle);
      double y = centerY + orbitRadius * math.sin(angle);

      _drawSenseBubble(
          canvas,
          Offset(x, y),
          headRadius * 0.5,
          colors[i],
          animations[i],
          senseIcons[i]
      );
    }
  }

  void _drawSimpleFace(Canvas canvas, Offset center, double radius) {
    final paint = Paint()..color = Colors.white.withOpacity(0.5);
    canvas.drawCircle(Offset(center.dx - radius * 0.3, center.dy - radius * 0.1), radius * 0.08, paint);
    canvas.drawCircle(Offset(center.dx + radius * 0.3, center.dy - radius * 0.1), radius * 0.08, paint);

    final mouthPaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius * 0.4), 0.2, math.pi - 0.4, false, mouthPaint);
  }

  void _drawSenseBubble(Canvas canvas, Offset pos, double radius, Color color, double anim, IconData icon) {
    if (anim <= 0.05) return;

    double currentRadius = radius * anim;
    final bubblePaint = Paint()
      ..color = color.withOpacity(0.9)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, (1 - anim) * 5 + 1);
    canvas.drawCircle(pos, currentRadius, bubblePaint);
    canvas.drawCircle(
        Offset(pos.dx - currentRadius * 0.3, pos.dy - currentRadius * 0.3),
        currentRadius * 0.2,
        Paint()..color = Colors.white.withOpacity(0.3 * anim)
    );
    if (anim > 0.5) {
      TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);
      textPainter.text = TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: currentRadius * 1.2,
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
          color: Colors.white.withOpacity(anim),
        ),
      );
      textPainter.layout();
      textPainter.paint(
          canvas,
          Offset(pos.dx - textPainter.width / 2, pos.dy - textPainter.height / 2)
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}