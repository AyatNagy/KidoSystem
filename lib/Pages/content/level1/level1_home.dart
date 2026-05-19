import 'package:flutter/material.dart';
import 'package:kido/l10n/l10n_extension.dart';
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
    final l10n = context.l10n;
    return LevelHomeBase(
      childName: childName,
      childId: childId,
      avatarAsset: avatarAsset,
      dailyChallengeTitle: l10n.dailyChallenge,
      dailyChallengeSubtitle: l10n.level1ChallengeSubtitle,
      examId: "post_level1",
      examIcon: Icons.toys,
      examGradientColors: [AppColors.kidoBlue, AppColors.kidoColors[1]],
      categoryWidget: Category(childName: childName, childId: childId),
    );
  }
}
