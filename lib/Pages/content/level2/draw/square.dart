import 'package:flutter/material.dart';
import 'package:kido/Pages/content/level2/draw/triangle.dart';
import '../../../../Widgets/content/level2/shapes.dart';
import '../../../../data/content/level2/shapes.dart';

class SquareDrawingPage extends StatelessWidget {
  const SquareDrawingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseDrawingPage(
      shapeData: ShapeData.square,
      successGif: 'assets/images/drawing/square.gif',
      onNext: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TriangleDrawingPage()),
        );
      },
      shapeName: 'square',
    );
  }
}
