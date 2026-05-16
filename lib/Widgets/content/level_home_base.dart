// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:kido/constants.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import '../../Pages/kid/exam_screen.dart';

class LevelHomeBase extends StatelessWidget {
  final String childName;
  final int childId; // ← ضيفناها
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
    required this.childId, // ← ضيفناها
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

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: config.localWidth * 0.05,
            vertical: 15.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(config),
              SizedBox(height: config.localHeight * 0.04),
              _buildDailyChallenge(config),
              SizedBox(height: config.localHeight * 0.04),
              _buildExamSection(context),
              SizedBox(height: config.localHeight * 0.04),
              Text(
                levelTitle!,
                style: TextStyle(
                  fontSize: config.title,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 20),
              categoryWidget,
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(dynamic config) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: config.isTablet ? 35 : 28,
              backgroundColor: primaryColor.withOpacity(0.1),
              backgroundImage:
                  avatarAsset != null ? AssetImage(avatarAsset!) : null,
              child:
                  avatarAsset == null
                      ? Image.asset('assets/images/characters/boy.gif')
                      : null,
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello, $childName!",
                  style: TextStyle(
                    fontSize: config.title,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textGray,
                    fontFamily: 'tinyKids',
                  ),
                ),
                Text(
                  "Let's learn and have fun!",
                  style: TextStyle(
                    fontSize: config.isTablet ? 18 : 14,
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
      padding: EdgeInsets.all(config.isTablet ? 35.0 : 22.0),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dailyChallengeTitle,
                  style: TextStyle(
                    fontSize: config.isTablet ? 32 : 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  dailyChallengeSubtitle,
                  style: TextStyle(
                    fontSize: config.isTablet ? 18 : 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.extension_rounded,
            size: config.isTablet ? 80 : 50,
            color: Colors.white24,
          ),
        ],
      ),
    );
  }

  Widget _buildExamSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: examGradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap:
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => ExamSkeletonScreen(
                        examId: examId,
                        childName: childName,
                        childId: childId, // ← ضيفناها
                      ),
                ),
              ),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white24,
                  child: Icon(examIcon, color: Colors.white),
                ),
                const SizedBox(width: 15),
                const Expanded(
                  child: Text(
                    "Final Exam",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
