import 'package:flutter/material.dart';
import 'package:kido/Pages/content/level2/draw/square.dart';
import '../../../../Widgets/content/level2/shapes.dart';
import '../../../../data/level2/shapes.dart';

class CircleDrawingPage extends StatelessWidget {
  const CircleDrawingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseDrawingPage(
      shapeData: ShapeData.circle,
      successGif: 'assets/images/drawing/circle.gif',
      onNext: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context)=>SquareDrawingPage())
      ),
    );
  }
}