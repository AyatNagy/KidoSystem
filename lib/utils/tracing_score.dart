import 'package:flutter/material.dart';

class TracingScore {
  /// بيحسب عدد النجوم بناءً على نسبة التغطية (0.0 → 1.0)
  static int calculateStars(double coverageRatio) {
    if (coverageRatio >= 0.85) return 3;
    if (coverageRatio >= 0.55) return 2;
    if (coverageRatio > 0.0) return 1;
    return 0;
  }

  /// بيحسب كام نقطة من مسار الحرف اتغطت بالرسم
  static double calculateCoverage({
    required List<Offset> pathPoints,
    required List<List<Offset>> drawn,
    double threshold = 30.0,
  }) {
    if (pathPoints.isEmpty) return 0.0;

    int hit = 0;
    for (final target in pathPoints) {
      bool found = false;
      for (final stroke in drawn) {
        for (final p in stroke) {
          if ((p - target).distance <= threshold) {
            found = true;
            break;
          }
        }
        if (found) break;
      }
      if (found) hit++;
    }
    return hit / pathPoints.length;
  }
}
