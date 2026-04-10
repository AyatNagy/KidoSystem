import 'package:flutter/material.dart';
import 'package:kido/Pages/CategoryGrid.dart';
import 'package:kido/constants.dart';

class Level3Home extends StatelessWidget {
  const Level3Home({super.key});
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
                      // *** تعديل هنا: إضافة شخصية كرتونية لطيفة (الأفاتار) ***
                      Container(
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.purpleMain.withOpacity(
                            0.1,
                          ), // خلفية أرجوانية خفيفة
                          border: Border.all(
                            color: AppColors.purpleMain.withOpacity(0.2),
                            width: 2,
                          ),
                        ),
                        // يمكنك استخدام Image.asset للشخصية الكرتونية
                        child: const Center(
                          child: Icon(
                            Icons.face_retouching_natural_rounded,
                            size: 35,
                            color: AppColors.purpleMain,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Hello, Ayat",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                          Text(
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
                  // أيقونة الإشعارات (اختياري)
                  const Icon(
                    Icons.notifications_active_rounded,
                    color: AppColors.textGray,
                  ),
                ],
              ),

              SizedBox(height: screenHeight * 0.04), // مسافة مرنة
              // 2. --- كارت التحدي اليومي (Daily Challenge Card) ---
              Container(
                width: screenWidth,
                padding: const EdgeInsets.all(25.0),
                decoration: BoxDecoration(
                  color: AppColors.purpleMain, // أرجواني سادة وقوي
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
                          // زر Let's Go
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
                    // *** تعديل هنا: إضافة قطعة بازل كرتونية (اختياري) لربط التصميم ***
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Opacity(
                          opacity: 0.2, // خفيفة جداً كخلفية
                          child: const Icon(
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

              SizedBox(height: screenHeight * 0.05), // مسافة مرنة
              // 3. --- عنوان التصنيفات ---
              const Text(
                "Categories",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),

              const SizedBox(height: 20),

              CategoryGrid(), // هذا هو المكون الذي يجمع كل الكروت المتحركة

              const SizedBox(height: 30), // مسافة سفلية
            ],
          ),
        ),
      ),
    );
  }
}
