import 'package:flutter/material.dart';

class SizeComparisonItem extends StatelessWidget {
  final String imagePath;
  final bool isHighlighted;

  const SizeComparisonItem({
    super.key,
    required this.imagePath,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return AnimatedScale(
      scale: isHighlighted ? 1.2 : 1.0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      child: Image.asset(
        imagePath,
        height: screenHeight * 0.55,
        fit: BoxFit.contain,
      ),
    );
  }
}
