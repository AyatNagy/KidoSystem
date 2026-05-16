import 'package:flutter/material.dart';
import '../../../Widgets/content/level_home_base.dart';
import '../../../constants.dart';
import 'category.dart';

class Level2Home extends StatelessWidget {
  final String childName;
  final String? avatarAsset;
  final int childId;
  const Level2Home({
    super.key,
    required this.childName,
    this.avatarAsset,
    required this.childId,
  });

  @override
  Widget build(BuildContext context) {
    return LevelHomeBase(
      childName: childName,
      childId: childId,
      avatarAsset: avatarAsset,
      primaryColor: AppColors.purpleMain,
      dailyChallengeTitle: "Daily Challenge",
      dailyChallengeSubtitle: "Lines, Shapes, Sizes and Puzzle",
      examId: "post_level2",
      examIcon: Icons.psychology_rounded,
      examGradientColors: [AppColors.kidoGreen, AppColors.kidoColors[7]],
      categoryWidget: Category2(childName: childName, childId: childId),
    );
  }
}
