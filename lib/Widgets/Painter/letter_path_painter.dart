import 'package:flutter/material.dart';

class LetterPathPainter extends CustomPainter {
  final Path path;
  final Color color;
  final double strokeWidth;

  const LetterPathPainter({
    required this.path,
    required this.color,
    this.strokeWidth = 28,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..color = color;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant LetterPathPainter oldDelegate) {
    return oldDelegate.path != path ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
