import 'package:flutter/material.dart';

class FlyingBee extends StatelessWidget {
  final double value;
  final Offset start;
  final Offset end;
  final double width;
  final double height;

  const FlyingBee({
    super.key,
    required this.value,
    required this.start,
    required this.end,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: start.dx + (end.dx - start.dx) * value,
      top: start.dy + (end.dy - start.dy) * value,
      child: Image.asset(
        "assets/images/bee.png",
        height: height,
        width: width,
      ),
    );
  }
}