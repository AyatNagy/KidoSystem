import 'package:flutter/material.dart';

import '../../../../Widgets/content/level2/shapes.dart';
import '../../../../data/level2/shapes.dart';

class SquareDrawingPage extends StatelessWidget {
  const SquareDrawingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseDrawingPage(
      shapeData: ShapeData.square,
      successGif: 'assets/images/drawing/square.gif',
      onNext: () => Navigator.pushNamed(context, '/nextShape'),
    );
  }
}