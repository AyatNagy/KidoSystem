// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';

class KidoStakePainter extends CustomPainter {
  final Color color;
  final bool isFront;
  final bool isHovering;
  KidoStakePainter({required this.color, required this.isFront, required this.isHovering});

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final bottomY = size.height;
    final stakeWidth = isHovering ? 18.0 : 14.0;
    final stakeHeight = size.height * 0.82;

    if (!isFront) {
      final paint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withOpacity(0.6), color],
        ).createShader(Rect.fromLTWH(centerX - stakeWidth/2, bottomY - stakeHeight, stakeWidth, stakeHeight));

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(centerX - (stakeWidth / 2), bottomY - stakeHeight, stakeWidth, stakeHeight),
          const Radius.circular(10),
        ),
        paint,
      );
      canvas.drawCircle(
        Offset(centerX, bottomY - stakeHeight),
        stakeWidth * 0.7,
        Paint()..color = color,
      );
      canvas.drawCircle(
        Offset(centerX - 2, bottomY - stakeHeight - 2),
        stakeWidth * 0.2,
        Paint()..color = Colors.white.withOpacity(0.4),
      );
    } else {
      final paint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withOpacity(0.8), color],
        ).createShader(Rect.fromLTWH(centerX - stakeWidth/2, bottomY - 50, stakeWidth, 50));
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(centerX - (stakeWidth / 2), bottomY - 45, stakeWidth, 45),
          const Radius.circular(5),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}