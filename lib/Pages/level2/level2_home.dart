// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:kido/constants.dart';
import 'category.dart';

class Level2Home extends StatelessWidget {
  final String childName;
  final String? avatarAsset;
  const Level2Home({super.key, required this.childName, this.avatarAsset});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.purpleMain.withOpacity(0.1),
                          border: Border.all(
                            color: AppColors.purpleMain.withOpacity(0.2),
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child:
                          avatarAsset != null
                              ? Image.asset(
                            avatarAsset!,
                            fit: BoxFit.cover,
                            width: 55,
                            height: 55,
                          )
                              : const Center(
                            child: Icon(
                              Icons.face_retouching_natural_rounded,
                              size: 35,
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
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                          const Text(
                            "Let's play, learn, and have fun!",
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textGray,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.notifications_active_rounded,
                    color: AppColors.textGray,
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.04),
              Container(
                width: screenWidth,
                padding: const EdgeInsets.all(25.0),
                decoration: BoxDecoration(
                  color: AppColors.purpleMain,
                  borderRadius: BorderRadius.circular(30),
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
                          const Text(
                            "Daily\nChallenge",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Complete today's quiz to\nearn 3 stars!",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.purpleMain,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 25,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 2,
                            ),
                            child: const Text(
                              "Let's Go",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      flex: 1,
                      child: Center(
                        child: Opacity(
                          opacity: 0.2,
                          child: Icon(
                            Icons.extension_rounded,
                            size: 80,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.05),

              const Text(
                "Categories",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 20),
              Category(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
