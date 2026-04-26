import 'package:flutter/material.dart';

class BeeCountingData {
  static List<Offset> beeCount(double width, double height) {
    return [
      Offset(width * 0.40, height * 0.15),
      Offset(width * 0.45, height * 0.12),
      Offset(width * 0.55, height * 0.15),
      Offset(width * 0.42, height * 0.22),
      Offset(width * 0.50, height * 0.20),
      Offset(width * 0.58, height * 0.22),
      Offset(width * 0.50, height * 0.28),
    ];
  }
  static List<Offset> bearPositions(double sw, double sh) {
    return [
      Offset(sw * 0.25, sh * 0.70),
      Offset(sw * 0.50, sh * 0.70),
      Offset(sw * 0.75, sh * 0.70),
    ];
  }
}