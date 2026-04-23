import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:kido/Models/letter_step.dart';

class TracingLetterData {
  final Path path;
  final List<LetterStep> steps;

  const TracingLetterData({required this.path, required this.steps});
}

class LetterRepository {
  static TracingLetterData build(String letter, {required Size canvasSize}) {
    final strokes = _normalizedStrokes(letter);
    if (strokes == null || strokes.isEmpty) {
      // Fallback: a simple vertical stroke.
      return _fromNormalizedStrokes([
        [const Offset(0.5, 0.1), const Offset(0.5, 0.9)],
      ], canvasSize: canvasSize);
    }
    return _fromNormalizedStrokes(strokes, canvasSize: canvasSize);
  }

  static TracingLetterData _fromNormalizedStrokes(
    List<List<Offset>> normalizedStrokes, {
    required Size canvasSize,
  }) {
    // Fit strokes into a nice inner rect.
    final pad = math.max(
      18.0,
      math.min(canvasSize.width, canvasSize.height) * 0.06,
    );
    final bounds = Rect.fromLTWH(
      pad,
      pad,
      math.max(1, canvasSize.width - pad * 2),
      math.max(1, canvasSize.height - pad * 2),
    );

    Offset tx(Offset p) => Offset(
      bounds.left + p.dx * bounds.width,
      bounds.top + p.dy * bounds.height,
    );

    final steps = <LetterStep>[];
    final path = Path();

    var stepNumber = 1;
    for (final stroke in normalizedStrokes) {
      final pts = stroke.map(tx).toList(growable: false);
      if (pts.length < 2) continue;
      steps.add(
        LetterStep(
          number: stepNumber++,
          startPoint: pts.first,
          endPoint: pts.last,
          guidePoints: pts,
        ),
      );

      path.moveTo(pts.first.dx, pts.first.dy);
      for (var i = 1; i < pts.length; i++) {
        path.lineTo(pts[i].dx, pts[i].dy);
      }
    }

    return TracingLetterData(path: path, steps: steps);
  }

  static List<Offset> _line(Offset a, Offset b, {int count = 10}) {
    return List.generate(count + 1, (i) {
      final t = i / count;
      return Offset(a.dx + (b.dx - a.dx) * t, a.dy + (b.dy - a.dy) * t);
    });
  }

  static List<Offset> _poly(List<Offset> points, {int perSegment = 6}) {
    if (points.length < 2) return points;
    final out = <Offset>[];
    for (var i = 0; i < points.length - 1; i++) {
      final seg = _line(points[i], points[i + 1], count: perSegment);
      if (out.isNotEmpty) out.removeLast();
      out.addAll(seg);
    }
    return out;
  }

  /// Normalized strokes in 0..1 space.
  /// Each stroke is a polyline in writing order.
  static List<List<Offset>>? _normalizedStrokes(String letter) {
    // Arabic (isolated) Alef: ا
    if (letter == 'ا') {
      return [
        _line(const Offset(0.52, 0.10), const Offset(0.52, 0.90), count: 14),
      ];
    }

    switch (letter.toUpperCase()) {
      case 'A':
        return [
          _poly(const [Offset(0.50, 0.12), Offset(0.18, 0.90)]),
          _poly(const [Offset(0.50, 0.12), Offset(0.82, 0.90)]),
          _poly(const [
            // Cross bar positioned to touch both legs.
            Offset(0.295, 0.62),
            Offset(0.705, 0.62),
          ]),
        ];
      case 'B':
        return [
          _poly(const [Offset(0.26, 0.12), Offset(0.26, 0.90)]),
          _poly(const [
            Offset(0.26, 0.12),
            Offset(0.65, 0.20),
            Offset(0.62, 0.46),
            Offset(0.26, 0.50),
          ]),
          _poly(const [
            Offset(0.26, 0.50),
            Offset(0.70, 0.58),
            Offset(0.66, 0.88),
            Offset(0.26, 0.90),
          ]),
        ];
      case 'C':
        return [
          _poly(const [
            Offset(0.78, 0.22),
            Offset(0.62, 0.12),
            Offset(0.34, 0.18),
            Offset(0.22, 0.50),
            Offset(0.34, 0.82),
            Offset(0.62, 0.88),
            Offset(0.78, 0.78),
          ]),
        ];
      case 'D':
        return [
          _poly(const [Offset(0.30, 0.12), Offset(0.30, 0.90)]),
          _poly(const [
            Offset(0.30, 0.12),
            Offset(0.74, 0.26),
            Offset(0.74, 0.76),
            Offset(0.30, 0.90),
          ]),
        ];
      case 'E':
        return [
          _poly(const [Offset(0.30, 0.12), Offset(0.30, 0.90)]),
          _poly(const [Offset(0.30, 0.12), Offset(0.78, 0.12)]),
          _poly(const [Offset(0.30, 0.50), Offset(0.70, 0.50)]),
          _poly(const [Offset(0.30, 0.90), Offset(0.80, 0.90)]),
        ];
      case 'F':
        return [
          _poly(const [Offset(0.30, 0.12), Offset(0.30, 0.90)]),
          _poly(const [Offset(0.30, 0.12), Offset(0.80, 0.12)]),
          _poly(const [Offset(0.30, 0.50), Offset(0.68, 0.50)]),
        ];
      case 'G':
        return [
          _poly(const [
            Offset(0.78, 0.26),
            Offset(0.62, 0.12),
            Offset(0.34, 0.18),
            Offset(0.22, 0.50),
            Offset(0.34, 0.82),
            Offset(0.62, 0.88),
            Offset(0.80, 0.70),
            Offset(0.58, 0.70),
          ]),
        ];
      case 'H':
        return [
          _poly(const [Offset(0.28, 0.12), Offset(0.28, 0.90)]),
          _poly(const [Offset(0.72, 0.12), Offset(0.72, 0.90)]),
          _poly(const [Offset(0.28, 0.52), Offset(0.72, 0.52)]),
        ];
      case 'I':
        return [
          _poly(const [Offset(0.36, 0.12), Offset(0.64, 0.12)]),
          _poly(const [Offset(0.50, 0.12), Offset(0.50, 0.90)]),
          _poly(const [Offset(0.36, 0.90), Offset(0.64, 0.90)]),
        ];
      case 'J':
        return [
          _poly(const [Offset(0.36, 0.12), Offset(0.70, 0.12)]),
          _poly(const [
            Offset(0.62, 0.12),
            Offset(0.62, 0.78),
            Offset(0.52, 0.90),
            Offset(0.32, 0.82),
          ]),
        ];
      case 'K':
        return [
          _poly(const [Offset(0.30, 0.12), Offset(0.30, 0.90)]),
          _poly(const [Offset(0.74, 0.12), Offset(0.32, 0.56)]),
          _poly(const [Offset(0.36, 0.52), Offset(0.78, 0.90)]),
        ];
      case 'L':
        return [
          _poly(const [Offset(0.30, 0.12), Offset(0.30, 0.90)]),
          _poly(const [Offset(0.30, 0.90), Offset(0.80, 0.90)]),
        ];
      case 'M':
        return [
          _poly(const [Offset(0.20, 0.90), Offset(0.20, 0.12)]),
          _poly(const [Offset(0.20, 0.12), Offset(0.50, 0.55)]),
          _poly(const [Offset(0.50, 0.55), Offset(0.80, 0.12)]),
          _poly(const [Offset(0.80, 0.12), Offset(0.80, 0.90)]),
        ];
      case 'N':
        return [
          _poly(const [Offset(0.25, 0.90), Offset(0.25, 0.12)]),
          _poly(const [Offset(0.25, 0.12), Offset(0.75, 0.90)]),
          _poly(const [Offset(0.75, 0.90), Offset(0.75, 0.12)]),
        ];
      case 'O':
        return [
          _poly(const [
            Offset(0.50, 0.12),
            Offset(0.30, 0.18),
            Offset(0.22, 0.50),
            Offset(0.30, 0.82),
            Offset(0.50, 0.90),
            Offset(0.70, 0.82),
            Offset(0.78, 0.50),
            Offset(0.70, 0.18),
            Offset(0.50, 0.12),
          ]),
        ];
      case 'P':
        return [
          _poly(const [Offset(0.30, 0.90), Offset(0.30, 0.12)]),
          _poly(const [
            Offset(0.30, 0.12),
            Offset(0.76, 0.20),
            Offset(0.70, 0.46),
            Offset(0.30, 0.50),
          ]),
        ];
      case 'Q':
        return [
          _poly(const [
            Offset(0.50, 0.12),
            Offset(0.30, 0.18),
            Offset(0.22, 0.50),
            Offset(0.30, 0.82),
            Offset(0.50, 0.90),
            Offset(0.70, 0.82),
            Offset(0.78, 0.50),
            Offset(0.70, 0.18),
            Offset(0.50, 0.12),
          ]),
          _poly(const [Offset(0.60, 0.74), Offset(0.80, 0.92)]),
        ];
      case 'R':
        return [
          _poly(const [Offset(0.30, 0.90), Offset(0.30, 0.12)]),
          _poly(const [
            Offset(0.30, 0.12),
            Offset(0.76, 0.20),
            Offset(0.70, 0.46),
            Offset(0.30, 0.52),
          ]),
          _poly(const [Offset(0.32, 0.52), Offset(0.80, 0.90)]),
        ];
      case 'S':
        return [
          _poly(const [
            Offset(0.76, 0.20),
            Offset(0.62, 0.10),
            Offset(0.34, 0.18),
            Offset(0.40, 0.42),
            Offset(0.66, 0.56),
            Offset(0.60, 0.86),
            Offset(0.34, 0.90),
            Offset(0.22, 0.80),
          ]),
        ];
      case 'T':
        return [
          _poly(const [Offset(0.20, 0.12), Offset(0.80, 0.12)]),
          _poly(const [Offset(0.50, 0.12), Offset(0.50, 0.90)]),
        ];
      case 'U':
        return [
          _poly(const [
            Offset(0.26, 0.12),
            Offset(0.26, 0.70),
            Offset(0.50, 0.90),
            Offset(0.74, 0.70),
            Offset(0.74, 0.12),
          ]),
        ];
      case 'V':
        return [
          _poly(const [Offset(0.20, 0.12), Offset(0.50, 0.90)]),
          _poly(const [Offset(0.50, 0.90), Offset(0.80, 0.12)]),
        ];
      case 'W':
        return [
          _poly(const [Offset(0.16, 0.12), Offset(0.32, 0.90)]),
          _poly(const [Offset(0.32, 0.90), Offset(0.50, 0.40)]),
          _poly(const [Offset(0.50, 0.40), Offset(0.68, 0.90)]),
          _poly(const [Offset(0.68, 0.90), Offset(0.84, 0.12)]),
        ];
      case 'X':
        return [
          _poly(const [Offset(0.22, 0.12), Offset(0.78, 0.90)]),
          _poly(const [Offset(0.78, 0.12), Offset(0.22, 0.90)]),
        ];
      case 'Y':
        return [
          _poly(const [Offset(0.22, 0.12), Offset(0.50, 0.50)]),
          _poly(const [Offset(0.78, 0.12), Offset(0.50, 0.50)]),
          _poly(const [Offset(0.50, 0.50), Offset(0.50, 0.90)]),
        ];
      case 'Z':
        return [
          _poly(const [Offset(0.22, 0.12), Offset(0.78, 0.12)]),
          _poly(const [Offset(0.78, 0.12), Offset(0.22, 0.90)]),
          _poly(const [Offset(0.22, 0.90), Offset(0.78, 0.90)]),
        ];
    }
    return null;
  }
}
