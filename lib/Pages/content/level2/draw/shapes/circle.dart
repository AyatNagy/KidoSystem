import 'package:flutter/material.dart';
import 'package:kido/Pages/content/level2/draw/shapes/square.dart';
import '../../../../../Widgets/content/level2/shapes.dart';
import '../../../../../data/content/level2/shapes.dart';

class CircleDrawingPage extends StatelessWidget {
  final String childName;
  final int childId;

  const CircleDrawingPage({
    super.key,
    required this.childName,
    required this.childId,
  });

  @override
  Widget build(BuildContext context) {
    return BaseDrawingPage(
      shapeData: ShapeData.circle,
      successGif: 'assets/images/drawing/circle.gif',
      childId: childId,
      onNext:
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      SquareDrawingPage(childName: childName, childId: childId),
            ),
          ),
      shapeName: 'circle',
    );
  }
}
