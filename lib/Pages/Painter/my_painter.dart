import 'package:flutter/material.dart';

class MyPainter extends CustomPainter {
  final List<List<Offset>> points;
  final List<Color> colors;

  MyPainter(this.points, this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length; i++) {
      final paint = Paint()
        ..color = (i < colors.length ? colors[i] : Colors.red)
        ..strokeWidth = 18
        ..strokeCap = StrokeCap.round;
      for (int j = 0; j < points[i].length - 1; j++) {
        canvas.drawLine(points[i][j], points[i][j + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
