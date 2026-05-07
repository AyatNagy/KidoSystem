// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:kido/Pages/content/level2/category.dart';
import 'package:kido/constants.dart';
import '../../kid/exam_screen.dart';

class Level2Home extends StatelessWidget {
  final String childName;
  final String? avatarAsset;
  const Level2Home({super.key, required this.childName, this.avatarAsset});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double padding = constraints.maxWidth * 0.05;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: padding, vertical: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 25),
                  _buildDailyChallenge(constraints.maxWidth),
                  const SizedBox(height: 30),
                  _buildExamSection(context),
                  const SizedBox(height: 30),
                  const Text(
                    "Level 2 Categories",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Category2(),
                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.purpleMain.withOpacity(0.1),
                backgroundImage: avatarAsset != null ? AssetImage(avatarAsset!) : null,
                child: avatarAsset == null
                    ? const Icon(Icons.face_retouching_natural_rounded,
                    size: 35, color: AppColors.purpleMain)
                    : null,
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello, $childName!",
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Text(
                      "Ready for Level 2 challenges?",
                      style: TextStyle(fontSize: 13, color: AppColors.textGray),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Icon(Icons.notifications_active_rounded, color: AppColors.textGray),
      ],
    );
  }

  Widget _buildDailyChallenge(double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.purpleMain,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: AppColors.purpleMain.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Daily Challenge",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Complete tasks to earn big!",
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.purpleMain,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Let's Go"),
                ),
              ],
            ),
          ),
          const Expanded(
            flex: 1,
            child: Icon(Icons.extension_rounded, size: 60, color: Colors.white24),
          ),
        ],
      ),
    );
  }

  Widget _buildExamSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.tealAccent.shade700, Colors.teal.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
             Navigator.push(
               context,
               MaterialPageRoute(
                 builder: (context) => ExamSkeletonScreen(examId: 'exam2', childName: childName,),
               ),
             );
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Colors.white24,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.psychology_rounded,
                      color: Colors.white, size: 30),
                ),
                const SizedBox(width: 15),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Final Exam",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded,
                    color: Colors.white, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}