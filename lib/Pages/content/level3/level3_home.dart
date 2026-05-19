import 'package:flutter/material.dart';
import 'package:kido/l10n/l10n_extension.dart';
import '../../../Widgets/content/level_home_base.dart';
import '../../../constants.dart';
import 'category_grid.dart';

class Level3Home extends StatelessWidget {
  final String childName;
  final int childId;
  final String? avatarAsset;
  const Level3Home({super.key, required this.childName, required this.childId, this.avatarAsset});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return LevelHomeBase(
      childName: childName,
      childId: childId,
      avatarAsset: avatarAsset,
      dailyChallengeTitle: l10n.dailyChallenge,
      dailyChallengeSubtitle: l10n.level3ChallengeSubtitle,
      examId: "post_level3",
      examIcon: Icons.star,
      examGradientColors: [AppColors.kidoRed, AppColors.kidoOrange],
      categoryWidget: CategoryGrid(childId: childId),
    );
  }
}