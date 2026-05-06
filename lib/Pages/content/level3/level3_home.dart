// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:kido/constants.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import 'category_grid.dart';

class Level3Home extends StatelessWidget {
  final String childName;
  final String? avatarAsset;

  const Level3Home({
    super.key,
    required this.childName,
    this.avatarAsset,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: config.isTablet ? 75 : 55,
                        height: config.isTablet ? 75 : 55,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.purpleMain.withOpacity(0.1),
                          border: Border.all(
                            color: AppColors.purpleMain.withOpacity(0.2),
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: avatarAsset != null
                              ? Image.asset(
                            avatarAsset!,
                            fit: BoxFit.cover,
                          )
                              : Center(
                            child: Icon(
                              Icons.face_retouching_natural_rounded,
                              size: config.isTablet ? 45 : 35,
                              color: AppColors.purpleMain,
                            ),
                          ),
                        ),
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
                              color: AppColors.textDark,
                            ),
                          ),
                          Text(
                            "Let's play, learn, and have fun!",
                            style: TextStyle(
                              fontSize: config.isTablet ? 18 : 14,
                              color: AppColors.textGray,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Icon(
                    Icons.notifications_active_rounded,
                    color: AppColors.textGray,
                    size: config.isTablet ? 30 : 24,
                  ),
                ],
              ),
              SizedBox(height: config.localHeight * 0.04),
              Container(
                width: config.localWidth,
                padding: EdgeInsets.all(config.isTablet ? 40.0 : 25.0),
                decoration: BoxDecoration(
                  color: AppColors.purpleMain,
                  borderRadius: BorderRadius.circular(config.isTablet ? 40 : 30),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.purpleMain.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Daily\nChallenge",
                            style: TextStyle(
                              fontSize: config.isTablet ? 36 : 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Complete today's quiz to\nearn 3 stars!",
                            style: TextStyle(
                              fontSize: config.isTablet ? 18 : 14,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.purpleMain,
                              padding: EdgeInsets.symmetric(
                                horizontal: config.isTablet ? 40 : 25,
                                vertical: config.isTablet ? 18 : 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 2,
                            ),
                            child: Text(
                              "Let's Go",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: config.isTablet ? 18 : 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Opacity(
                          opacity: 0.2,
                          child: Icon(
                            Icons.extension_rounded,
                            size: config.isTablet ? 120 : 80,
                            color: AppColors.bgColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: config.localHeight * 0.05),
              Text(
                "Categories",
                style: TextStyle(
                  fontSize: config.title,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 20),
              CategoryGrid(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}