// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../Widgets/responsive_provider.dart';
import '../../../constants.dart';

class PegboardLogo extends StatefulWidget {
  final double sizeMultiplier;
  const PegboardLogo({super.key, this.sizeMultiplier = 0.4});

  @override
  State<PegboardLogo> createState() => _PegboardLogoState();
}

class _PegboardLogoState extends State<PegboardLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _pegAnimations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _pegAnimations = List.generate(3, (index) {
      double start = index * 0.25;
      double end = start + 0.35;
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
          height: logoSize,
          child: CustomPaint(
            painter: PegboardPainter(
              progress1: _pegAnimations[0].value,
              progress2: _pegAnimations[1].value,
              progress3: _pegAnimations[2].value,
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

class PegboardPainter extends CustomPainter {
  final double progress1, progress2, progress3;
  final List<Color> colors;

  PegboardPainter({
    required this.progress1,
    required this.progress2,
    required this.progress3,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double boardHeight = size.height * 0.4;
    final double boardWidth = size.width * 0.9;
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final boardPaint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    final boardRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(centerX, centerY + 20), width: boardWidth, height: boardHeight),
      const Radius.circular(20),
    );
    canvas.drawRRect(boardRect, boardPaint);
    final double holeSize = size.width * 0.18;
    final List<double> holeXPositions = [
      centerX - (boardWidth * 0.3),
      centerX,
      centerX + (boardWidth * 0.3),
    ];

    for (var xPos in holeXPositions) {
      _drawHole(canvas, Offset(xPos, centerY + 20), holeSize);
    }
    _drawPeg(canvas, Offset(holeXPositions[0], centerY + 20), holeSize, colors[0], progress1);
    _drawPeg(canvas, Offset(holeXPositions[1], centerY + 20), holeSize, colors[1], progress2);
    _drawPeg(canvas, Offset(holeXPositions[2], centerY + 20), holeSize, colors[2], progress3);
  }

  void _drawHole(Canvas canvas, Offset pos, double size) {
    final holePaint = Paint()..color = Colors.black.withOpacity(0.2);
    canvas.drawCircle(pos, size * 0.5, holePaint);
    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(pos, size * 0.5, borderPaint);
  }

  void _drawPeg(Canvas canvas, Offset holePos, double size, Color color, double anim) {
    if (anim <= 0.05) return;
    double startY = holePos.dy - (size * 3);
    double currentY = startY + ((holePos.dy - startY) * anim);
    final pegPaint = Paint()..color = color;
    canvas.drawCircle(Offset(holePos.dx, currentY), size * 0.45, pegPaint);
    final shinePaint = Paint()..color = Colors.white.withOpacity(0.2);
    canvas.drawCircle(Offset(holePos.dx - size * 0.15, currentY - size * 0.15), size * 0.1, shinePaint);

    if (anim > 0.8) {
      _drawPegFace(canvas, Offset(holePos.dx, currentY), size, anim);
    }
  }

  void _drawPegFace(Canvas canvas, Offset pos, double size, double anim) {
    final facePaint = Paint()..color = Colors.black87;
    double opacity = (anim - 0.8) * 5;
    canvas.drawCircle(Offset(pos.dx - size * 0.15, pos.dy), size * 0.05, facePaint..color = Colors.black.withOpacity(opacity.clamp(0, 1)));
    canvas.drawCircle(Offset(pos.dx + size * 0.15, pos.dy), size * 0.05, facePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}