import 'package:flutter/material.dart';
import 'package:kido/Pages/content/level2/draw/shapes/triangle.dart';
import '../../../../../Widgets/content/level2/shapes.dart';
import '../../../../../data/content/level2/shapes.dart';

class SquareDrawingPage extends StatelessWidget {
  final String childName;
  final int childId;

  const SquareDrawingPage({
    super.key,
    required this.childName,
    required this.childId,
  });

  @override
  Widget build(BuildContext context) {
    return BaseDrawingPage(
      shapeData: ShapeData.square,
      successGif: 'assets/images/drawing/square.gif',
      childId: childId,
      onNext: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    TriangleDrawingPage(childName: childName, childId: childId),
          ),
        );
      },
      shapeName: 'square',
    );
  }
}
