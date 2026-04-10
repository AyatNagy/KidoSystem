import 'package:flutter/material.dart';

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = const Color(0xFFF1F8E9).withOpacity(0.5);
    var path = Path();
    path.moveTo(0, 50);
    path.quadraticBezierTo(size.width * 0.25, 0, size.width * 0.5, 30);
    path.quadraticBezierTo(size.width * 0.75, 60, size.width, 10);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}