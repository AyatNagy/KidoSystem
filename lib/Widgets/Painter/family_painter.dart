// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class FamilyPainter extends CustomPainter {
  final Color primaryColor;
  final Color detailColor;

  FamilyPainter({
    this.primaryColor = const Color(0xFF64B5F6),
    this.detailColor = const Color(0xFF1976D2),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    final double depthOffset = width * 0.08;

    final paintFront =
        Paint()
          ..color = primaryColor
          ..style = PaintingStyle.fill;

    final paintDepth =
        Paint()
          ..color = detailColor
          ..style = PaintingStyle.fill;

    Path pathDepth = Path();
    pathDepth.moveTo(
      width * 0.35 + depthOffset,
      height * 0.15 + depthOffset,
    );
    pathDepth.quadraticBezierTo(
      width * 0.5 + depthOffset,
      height * 0.05 + depthOffset,
      width * 0.65 + depthOffset,
      height * 0.15 + depthOffset,
    );
    pathDepth.lineTo(
      width * 0.65 + depthOffset,
      height * 0.5 + depthOffset,
    );
    pathDepth.lineTo(
      width * 0.35 + depthOffset,
      height * 0.5 + depthOffset,
    );
    pathDepth.close();
    pathDepth.moveTo(
      width * 0.55 + depthOffset,
      height * 0.45 + depthOffset,
    );
    pathDepth.quadraticBezierTo(
      width * 0.65 + depthOffset,
      height * 0.35 + depthOffset,
      width * 0.75 + depthOffset,
      height * 0.45 + depthOffset,
    );
    pathDepth.lineTo(
      width * 0.75 + depthOffset,
      height * 0.75 + depthOffset,
    );
    pathDepth.lineTo(
      width * 0.55 + depthOffset,
      height * 0.75 + depthOffset,
    );
    pathDepth.close();
    canvas.drawPath(pathDepth, paintDepth);
    Path pathFront = Path();
    pathFront.moveTo(width * 0.35, height * 0.15);
    pathFront.quadraticBezierTo(
      width * 0.5,
      height * 0.05,
      width * 0.65,
      height * 0.15,
    );
    pathFront.lineTo(width * 0.65, height * 0.5);
    pathFront.quadraticBezierTo(
      width * 0.5,
      height * 0.6,
      width * 0.35,
      height * 0.5,
    );
    pathFront.close();
    pathFront.moveTo(width * 0.55, height * 0.45);
    pathFront.quadraticBezierTo(
      width * 0.65,
      height * 0.35,
      width * 0.75,
      height * 0.45,
    );
    pathFront.lineTo(width * 0.75, height * 0.75);
    pathFront.quadraticBezierTo(
      width * 0.65,
      height * 0.85,
      width * 0.55,
      height * 0.75,
    );
    pathFront.close();
    canvas.drawPath(pathFront, paintFront);
    Paint paintDetail =
        Paint()
          ..color = detailColor.withOpacity(0.3)
          ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(width * 0.45, height * 0.3),
      width * 0.06,
      paintDetail,
    );
    canvas.drawCircle(
      Offset(width * 0.65, height * 0.55),
      width * 0.05,
      paintDetail,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}