import 'package:flutter/material.dart';
import '../../../Widgets/content/level_home_base.dart';
import '../../../constants.dart';
import 'category_grid.dart';

class Level3Home extends StatelessWidget {
  final String childName;
  final String? avatarAsset;
  const Level3Home({super.key, required this.childName, this.avatarAsset});

  @override
  Widget build(BuildContext context) {
    return LevelHomeBase(
      childName: childName,
      avatarAsset: avatarAsset,
      dailyChallengeTitle: "Daily Challenge",
      dailyChallengeSubtitle: "Family, Letters, Numbers, Fruits, Vegetables and Animals",
      examId: "post_level3",
      examIcon: Icons.star,
      examGradientColors: [AppColors.kidoRed, AppColors.kidoOrange],
      categoryWidget: CategoryGrid(),
    );
  }
}