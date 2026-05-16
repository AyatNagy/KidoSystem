import 'package:flutter/material.dart';
import '../../../Widgets/content/level_home_base.dart';
import '../../../constants.dart';
import 'category.dart';

class Level1Home extends StatelessWidget {
  final String childName;
  final String? avatarAsset;
  final int childId;
  const Level1Home({
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
      dailyChallengeTitle: "Daily Challenge",
      dailyChallengeSubtitle:
          "Counting, Sorting, PedBoard, Self-Care, feelings and senses",
      examId: "exam1",
      examIcon: Icons.toys,
      examGradientColors: [AppColors.kidoBlue, AppColors.kidoColors[1]],
      categoryWidget: Category(childName: childName, childId: childId),
    );
  }
}
