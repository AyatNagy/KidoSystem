import 'package:flutter/material.dart';

import '../../../Widgets/content/level2/shapes.dart';
import '../../../data/level2/shapes.dart';

class CircleDrawingPage extends StatelessWidget {
  const CircleDrawingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseDrawingPage(
      shapeData: ShapeData.circle,
      successGif: 'assets/images/drawing/circle.gif',
      onNext: () => Navigator.pushNamed(context, '/home'),
    );
  }
}