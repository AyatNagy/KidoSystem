import 'package:flutter/material.dart';
import 'package:kido/Pages/content/level2/draw/shapes/square.dart';
import '../../../../../Widgets/content/level2/shapes.dart';
import '../../../../../data/content/level2/shapes.dart';

class CircleDrawingPage extends StatelessWidget {
  final String childName; // ← ضيف
  final int childId; // ← ضيف

  const CircleDrawingPage({
    super.key,
    required this.childName, // ← ضيف
    required this.childId, // ← ضيف
  });

  @override
  Widget build(BuildContext context) {
    return BaseDrawingPage(
      shapeData: ShapeData.circle,
      successGif: 'assets/images/drawing/circle.gif',
      onNext:
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => SquareDrawingPage(
                    childName: childName, // ← ضيف
                    childId: childId, // ← ضيف
                  ),
            ),
          ),
      shapeName: 'circle',
    );
  }
}
