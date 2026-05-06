import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:kido/Models/level3/letter_step.dart';

class LetterData {
  static Map<String, List<LetterStep>> steps = {
    // Arabic (isolated) - Alef: "ا"
    // Note: coordinates are tuned for the current canvas in LetterTracePage.
    'ا': [
      LetterStep(
        number: 1,
        startPoint: const Offset(180, 90),
        endPoint: const Offset(180, 410),
        guidePoints: _interpolate(
          const Offset(180, 90),
          const Offset(180, 410),
          count: 10,
        ),
      ),
    ],
    'A': [
      LetterStep(
        number: 1,
        startPoint: const Offset(180, 100),
        endPoint: const Offset(100, 400),
        guidePoints: _interpolate(
          const Offset(180, 100),
          const Offset(100, 400),
          count: 8,
        ),
      ),
      LetterStep(
        number: 2,
        startPoint: const Offset(180, 100),
        endPoint: const Offset(260, 400),
        guidePoints: _interpolate(
          const Offset(180, 100),
          const Offset(260, 400),
          count: 8,
        ),
      ),
      LetterStep(
        number: 3,
        startPoint: const Offset(130, 280),
        endPoint: const Offset(230, 280),
        guidePoints: _interpolate(
          const Offset(130, 280),
          const Offset(230, 280),
          count: 5,
        ),
      ),
    ],
    'B': [
      LetterStep(
        number: 1,
        startPoint: const Offset(130, 100),
        endPoint: const Offset(130, 400),
        guidePoints: _interpolate(
          const Offset(130, 100),
          const Offset(130, 400),
          count: 8,
        ),
      ),
      LetterStep(
        number: 2,
        startPoint: const Offset(130, 100),
        endPoint: const Offset(130, 250),
        guidePoints: _arcPoints(
          center: const Offset(170, 175),
          radius: 75,
          startAngle: -math.pi,
          endAngle: 0,
          count: 8,
        ),
      ),
      LetterStep(
        number: 3,
        startPoint: const Offset(130, 250),
        endPoint: const Offset(130, 400),
        guidePoints: _arcPoints(
          center: const Offset(180, 325),
          radius: 85,
          startAngle: -math.pi,
          endAngle: 0,
          count: 8,
        ),
      ),
    ],
    'C': [
      LetterStep(
        number: 1,
        startPoint: const Offset(270, 150),
        endPoint: const Offset(270, 350),
        guidePoints: _arcPoints(
          center: const Offset(180, 250),
          radius: 120,
          startAngle: -0.8,
          endAngle: math.pi + 0.8,
          count: 12,
        ),
      ),
    ],
    'D': [
      LetterStep(
        number: 1,
        startPoint: const Offset(140, 100),
        endPoint: const Offset(140, 400),
        guidePoints: _interpolate(
          const Offset(140, 100),
          const Offset(140, 400),
          count: 8,
        ),
      ),
      LetterStep(
        number: 2,
        startPoint: const Offset(140, 100),
        endPoint: const Offset(140, 400),
        guidePoints: _arcPoints(
          center: const Offset(140, 250),
          radius: 130,
          startAngle: -math.pi / 2,
          endAngle: math.pi / 2,
          count: 10,
        ),
      ),
    ],
    'E': [
      LetterStep(
        number: 1,
        startPoint: const Offset(140, 100),
        endPoint: const Offset(140, 400),
        guidePoints: _interpolate(
          const Offset(140, 100),
          const Offset(140, 400),
          count: 8,
        ),
      ),
      LetterStep(
        number: 2,
        startPoint: const Offset(140, 100),
        endPoint: const Offset(250, 100),
        guidePoints: _interpolate(
          const Offset(140, 100),
          const Offset(250, 100),
          count: 5,
        ),
      ),
      LetterStep(
        number: 3,
        startPoint: const Offset(140, 250),
        endPoint: const Offset(230, 250),
        guidePoints: _interpolate(
          const Offset(140, 250),
          const Offset(230, 250),
          count: 5,
        ),
      ),
    ],
  };

  static List<Offset> _interpolate(Offset a, Offset b, {int count = 6}) {
    return List.generate(count + 1, (i) {
      final t = i / count;
      return Offset(a.dx + (b.dx - a.dx) * t, a.dy + (b.dy - a.dy) * t);
    });
  }

  static List<Offset> _arcPoints({
    required Offset center,
    required double radius,
    required double startAngle,
    required double endAngle,
    int count = 8,
  }) {
    return List.generate(count + 1, (i) {
      final angle = startAngle + (endAngle - startAngle) * i / count;
      return Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
    });
  }
}
