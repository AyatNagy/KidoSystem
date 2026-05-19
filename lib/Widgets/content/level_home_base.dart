// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:kido/constants.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import 'package:kido/l10n/l10n_extension.dart';
import '../../Pages/kid/exam_screen.dart';

class LevelHomeBase extends StatelessWidget {
  final String childName;
  final int childId;
  final String? avatarAsset;
  final String? levelTitle;
  final String dailyChallengeTitle;
  final String dailyChallengeSubtitle;
  final String examId;
  final List<Color> examGradientColors;
  final IconData examIcon;
  final Widget categoryWidget;
  final Color primaryColor;

  const LevelHomeBase({
    super.key,
    required this.childName,
    required this.childId,
    this.avatarAsset,
    this.levelTitle = "Categories",
    required this.dailyChallengeTitle,
    required this.dailyChallengeSubtitle,
    required this.examId,
    required this.examGradientColors,
    required this.examIcon,
    required this.categoryWidget,
    this.primaryColor = AppColors.purpleMain,
  });

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);
    final l10n = context.l10n;
    final displayTitle = levelTitle ?? l10n.categories;

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -40,
              right: -30,
              child: _buildBubbleBackground(160, primaryColor.withOpacity(0.07)),
            ),
            Positioned(
              top: config.localHeight * 0.35,
              left: -50,
              child: _buildBubbleBackground(120, AppColors.kidoPink.withOpacity(0.06)),
            ),

            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: config.localWidth * 0.05,
                vertical: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(config, l10n),
                  SizedBox(height: config.localHeight * 0.035),
                  _buildDailyChallenge(config),
                  SizedBox(height: config.localHeight * 0.03),
                  _buildExamSection(context, config, l10n),
                  SizedBox(height: config.localHeight * 0.04),
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 24,
                        decoration: BoxDecoration(
                          color: AppColors.kidoOrange,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        displayTitle,
                        style: TextStyle(
                          fontSize: config.title + 2,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textDark,
                          fontFamily: 'Fredoka',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  categoryWidget,
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBubbleBackground(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildHeader(dynamic config, dynamic l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: primaryColor.withOpacity(0.3), width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    )
                  ]
              ),
              child: CircleAvatar(
                radius: config.isTablet ? 38 : 28,
                backgroundColor: primaryColor.withOpacity(0.1),
                backgroundImage: avatarAsset != null ? AssetImage(avatarAsset!) : null,
                child: avatarAsset == null
                    ? Image.asset('assets/images/characters/boy.gif')
                    : null,
              ),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.helloChild(childName),
                  style: TextStyle(
                    fontSize: config.title,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textDark,
                    fontFamily: 'Fredoka',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.letsLearnFun,
                  style: TextStyle(
                    fontSize: config.isTablet ? 16 : 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textGray,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDailyChallenge(dynamic config) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(12),
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.35),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(12),
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(32),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -15,
              bottom: -15,
              child: Icon(
                Icons.extension_rounded,
                size: config.isTablet ? 110 : 85,
                color: Colors.white.withOpacity(0.15),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(config.isTablet ? 32.0 : 22.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dailyChallengeTitle,
                          style: TextStyle(
                            fontSize: config.isTablet ? 30 : 22,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            fontFamily: 'Fredoka',
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          dailyChallengeSubtitle,
                          style: TextStyle(
                            fontSize: config.isTablet ? 16 : 13,
                            color: Colors.white.withOpacity(0.85),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExamSection(BuildContext context, dynamic config, dynamic l10n) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: examGradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: (examGradientColors.first).withOpacity(0.3),
              blurRadius: 14,
              offset: const Offset(0, 8),
            )
          ]
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExamSkeletonScreen(
                examId: examId,
                childName: childName,
                childId: childId,
              ),
            ),
          ),
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(examIcon, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.finalExam,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: config.isTablet ? 22 : 17,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Fredoka',
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.finalExamSubtitle,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.75),
                          fontSize: config.isTablet ? 14 : 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}