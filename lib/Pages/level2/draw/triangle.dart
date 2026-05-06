import 'package:flutter/material.dart';

import '../../../Widgets/content/level2/shapes.dart';
import '../../../data/level2/shapes.dart';

class TriangleDrawingPage extends StatelessWidget {
  const TriangleDrawingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseDrawingPage(
      shapeData: ShapeData.triangle,
      successGif: 'assets/images/drawing/triangle.gif',
      onNext: () => Navigator.pushNamed(context, '/home'),
    );
  }
}