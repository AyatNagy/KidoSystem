// ignore_for_file: deprecated_member_use

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:kido/Models/letter_step.dart';

class StepsPainter extends CustomPainter {
  final List<LetterStep> steps;
  final int currentStep;

  StepsPainter({required this.steps, required this.currentStep});

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < steps.length; i++) {
      final step = steps[i];
      final isDone = i < currentStep;
      final isActive = i == currentStep;

      final color =
          isDone
              ? Colors.redAccent.withOpacity(0.4)
              : isActive
              ? Colors.grey.shade500
              : Colors.grey.shade300;

      _drawDashedPath(canvas, step.guidePoints, color);
      _drawArrow(canvas, step.endPoint, step.guidePoints, color);
      _drawStartDot(canvas, step.startPoint, color, '${step.number}', isActive);
    }
  }

  void _drawDashedPath(Canvas canvas, List<Offset> points, Color color) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = 5
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke;

    bool draw = true;
    for (int i = 0; i < points.length - 1; i++) {
      if (draw) canvas.drawLine(points[i], points[i + 1], paint);
      draw = !draw;
    }
  }

  void _drawArrow(Canvas canvas, Offset tip, List<Offset> points, Color color) {
    if (points.length < 2) return;

    final last = points[points.length - 1];
    final prev = points[points.length - 2];
    final angle = math.atan2(last.dy - prev.dy, last.dx - prev.dx);

    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    final path =
        Path()
          ..moveTo(tip.dx + 16 * math.cos(angle), tip.dy + 16 * math.sin(angle))
          ..lineTo(
            tip.dx + 7 * math.cos(angle + 2.4),
            tip.dy + 7 * math.sin(angle + 2.4),
          )
          ..lineTo(
            tip.dx + 7 * math.cos(angle - 2.4),
            tip.dy + 7 * math.sin(angle - 2.4),
          )
          ..close();
    canvas.drawPath(path, paint);
  }

  void _drawStartDot(
    Canvas canvas,
    Offset center,
    Color color,
    String label,
    bool isActive,
  ) {
    // الدائرة
    canvas.drawCircle(
      center,
      14,
      Paint()..color = isActive ? Colors.grey.shade600 : color,
    );

    // الرقم
    final tp = TextPainter(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant StepsPainter old) =>
      old.currentStep != currentStep;
}
