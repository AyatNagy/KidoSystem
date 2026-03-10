import 'package:flutter/material.dart';

class PageCurlPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white.withOpacity(0.95)
      ..style = PaintingStyle.fill;

    var path = Path();
    path.moveTo(size.width, size.height);
    path.lineTo(size.width - 60, size.height);
    path.quadraticBezierTo(
      size.width - 20,
      size.height - 20,
      size.width,
      size.height - 60,
    );
    path.close();

    canvas.drawShadow(path, Colors.black26, 6, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
