import 'package:flutter/material.dart';
import '../../../Widgets/content/level_home_base.dart';
import '../../../constants.dart';
import 'category.dart';

class Level2Home extends StatelessWidget {
  final String childName;
  final String? avatarAsset;
  const Level2Home({super.key, required this.childName, this.avatarAsset});

  @override
  Widget build(BuildContext context) {
    return LevelHomeBase(
      childName: childName,
      avatarAsset: avatarAsset,
      primaryColor: AppColors.purpleMain,
      dailyChallengeTitle: "Daily Challenge",
      dailyChallengeSubtitle: "Lines, Shapes, Sizes and Puzzle",
      examId: "post_level2",
      examIcon: Icons.psychology_rounded,
      examGradientColors: [AppColors.kidoGreen, AppColors.kidoColors[7]],
      categoryWidget: const Category2(),
    );
  }
}