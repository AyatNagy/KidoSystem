import 'package:flutter/material.dart';

class RoadLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, size.height / 2),
          Offset(startX + 40, size.height / 2), paint);
      startX += 80;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}