import 'package:flutter/material.dart';
import 'package:kido/Pages/content/level2/level2home.dart';
import '../../../../Widgets/content/level2/shapes.dart';
import '../../../../data/content/level2/shapes.dart';

class TriangleDrawingPage extends StatelessWidget {
  final String childName;
  final int childId;

  const TriangleDrawingPage({
    super.key,
    required this.childName,
    required this.childId,
  });

  @override
  Widget build(BuildContext context) {
    return BaseDrawingPage(
      shapeData: ShapeData.triangle,
      successGif: 'assets/images/drawing/triangle.gif',
      onNext: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Level2Home(
              childName: childName,
              childId: childId,
            ),
          ),
        );
      },
      shapeName: 'triangle',
    );
  }
}
