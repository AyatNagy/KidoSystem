import 'package:flutter/material.dart';

class ToothbrushWidget extends StatelessWidget {
  const ToothbrushWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: const Size(28, 90), painter: _BrushPainter());
  }
}

class _BrushPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    paint.color = const Color(0xFF29B6F6);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.3,
          size.height * 0.3,
          size.width * 0.4,
          size.height * 0.65,
        ),
        const Radius.circular(6),
      ),
      paint,
    );

    final headRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height * 0.32),
      const Radius.circular(8),
    );
    paint.color = Colors.white;
    canvas.drawRRect(headRect, paint);

    paint
      ..color = const Color(0xFF29B6F6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawRRect(headRect, paint);

    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFF29B6F6);
    for (int i = 0; i < 5; i++) {
      final x = size.width * (0.1 + i * 0.19);
      canvas.drawLine(
        Offset(x, size.height * 0.02),
        Offset(x, size.height * 0.28),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_BrushPainter old) => false;
}
