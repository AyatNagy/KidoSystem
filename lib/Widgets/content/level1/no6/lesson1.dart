import 'package:flutter/material.dart';
import '../../../../data/level1/countToys.dart';

class ToyIcon extends StatelessWidget {
  final int index;
  final bool isDragging;
  final double size;

  const ToyIcon({
    required this.index,
    this.isDragging = false,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final pal = pals[index];
    return Material(
      color: Colors.transparent,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: pal['color'],
          borderRadius: BorderRadius.circular(size * 0.3),
          boxShadow: [
            if (isDragging)
              const BoxShadow(
                color: Colors.black26,
                blurRadius: 15,
                offset: Offset(0, 10),
              )
          ],
        ),
        child: Icon(
          pal['icon'],
          color: Colors.white,
          size: size * 0.6,
        ),
      ),
    );
  }
}