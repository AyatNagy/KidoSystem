// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../Widgets/responsive_provider.dart';
import '../../../constants.dart';

class SortingTower extends StatefulWidget {
  final double sizeMultiplier;
  const SortingTower({super.key, this.sizeMultiplier = 0.4});

  @override
  State<SortingTower> createState() => _SortingTowerState();
}

class _SortingTowerState extends State<SortingTower>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _stackAnimations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _stackAnimations = List.generate(3, (index) {
      double start = index * 0.25;
      double end = start + 0.3;
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, math.min(end, 1.0), curve: Curves.bounceOut),
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
          height: logoSize * 1.8,
          child: CustomPaint(
            painter: SortingTowerPainter(
              progress1: _stackAnimations[0].value,
              progress2: _stackAnimations[1].value,
              progress3: _stackAnimations[2].value,
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

class SortingTowerPainter extends CustomPainter {
  final double progress1, progress2, progress3;
  final List<Color> colors;

  SortingTowerPainter({
    required this.progress1,
    required this.progress2,
    required this.progress3,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double baseUnit = size.width * 0.55;
    final double midUnit = size.width * 0.42;
    final double topUnit = size.width * 0.30;
    final double totalTowerHeight = baseUnit + midUnit + topUnit;
    final double centerX = size.width / 2;
    final double baseY = (size.height / 2) + (totalTowerHeight / 2);
    _drawStackedBlock(
        canvas,
        Offset(centerX - (baseUnit / 2), baseY - (baseUnit * progress1)),
        baseUnit,
        colors[0],
        progress1
    );

    if (progress1 > 0.8) {
      double targetY = baseY - baseUnit;
      _drawStackedBlock(
          canvas,
          Offset(centerX - (midUnit / 2), targetY - (midUnit * (progress2 - 1).abs())),
          midUnit,
          colors[1],
          progress2
      );
    }

    if (progress2 > 0.8) {
      double targetY = baseY - baseUnit - midUnit;
      _drawStackedBlock(
          canvas,
          Offset(centerX - (topUnit / 2), targetY - (topUnit * (progress3 - 1).abs())),
          topUnit,
          colors[2],
          progress3
      );
    }
  }

  void _drawStackedBlock(Canvas canvas, Offset position, double size, Color color, double anim) {
    if (anim <= 0.05) return;

    final paintMain = Paint()..color = color;
    final double cornerRadius = size * 0.18;

    RRect blockRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(position.dx, position.dy - size, size, size),
      Radius.circular(cornerRadius),
    );

    canvas.drawRRect(blockRect.shift(const Offset(0, 4)), Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8));

    canvas.drawRRect(blockRect, paintMain);

    if (anim > 0.7) {
      _drawCuteFace(canvas, position, size, anim);
    }

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(position.dx + size * 0.15, position.dy - size * 0.85, size * 0.3, size * 0.08),
        Radius.circular(size * 0.05),
      ),
      Paint()..color = Colors.white.withOpacity(0.2),
    );
  }

  void _drawCuteFace(Canvas canvas, Offset pos, double size, double anim) {
    final eyePaint = Paint()..color = Colors.black87;
    final mouthPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = size * 0.04
      ..strokeCap = StrokeCap.round;

    double eyeSpacing = size * 0.22;
    double eyeY = pos.dy - size * 0.6;
    double faceAlpha = (anim - 0.7) * 3.3;

    canvas.drawCircle(Offset(pos.dx + size / 2 - eyeSpacing, eyeY), size * 0.06, eyePaint..color = Colors.black.withOpacity(faceAlpha.clamp(0, 1)));
    canvas.drawCircle(Offset(pos.dx + size / 2 + eyeSpacing, eyeY), size * 0.06, eyePaint);

    var mouthPath = Path();
    mouthPath.addArc(
      Rect.fromCenter(center: Offset(pos.dx + size / 2, pos.dy - size * 0.35), width: size * 0.25, height: size * 0.15),
      0, math.pi,
    );
    canvas.drawPath(mouthPath, mouthPaint..color = Colors.black87.withOpacity(faceAlpha.clamp(0, 1)));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}