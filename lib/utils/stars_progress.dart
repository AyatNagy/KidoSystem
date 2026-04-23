import 'package:flutter/material.dart';
import 'package:kido/Widgets/star3d.dart';

class StarProgressWidget extends StatelessWidget {
  final int filledStars;
  final int totalStars;

  const StarProgressWidget({
    super.key,
    required this.filledStars,
    required this.totalStars,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalStars, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Star3DWidget(filled: index < filledStars),
        );
      }),
    );
  }
}
