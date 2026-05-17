import 'package:flutter/material.dart';
import 'package:kido/Pages/content/level2/draw/shapes/triangle.dart';
import '../../../../../Widgets/content/level2/shapes.dart';
import '../../../../../data/content/level2/shapes.dart';

class SquareDrawingPage extends StatelessWidget {
  final String childName; // ← ضيف
  final int childId; // ← ضيف

  const SquareDrawingPage({
    super.key,
    required this.childName, // ← ضيف
    required this.childId, // ← ضيف
  });

  @override
  Widget build(BuildContext context) {
    return BaseDrawingPage(
      shapeData: ShapeData.square,
      successGif: 'assets/images/drawing/square.gif',
      onNext: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => TriangleDrawingPage(
                  childName: childName, // ← ضيف
                  childId: childId, // ← ضيف
                ),
          ),
        );
      },
      shapeName: 'square',
    );
  }
}
