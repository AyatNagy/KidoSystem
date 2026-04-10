// ... استيرادات ملف الـ CategoryCard والملفات الأخرى ...
import 'package:flutter/material.dart';
import 'package:kido/Widgets/AnimatedThreeDLetterA.dart';
import 'package:kido/Widgets/CategoryCard.dart';
import 'package:kido/Widgets/FamilyPainter.dart';
import 'package:kido/Widgets/ThreeDApplePainter.dart';
import 'package:kido/Widgets/ThreeDCarrotPainter.dart';
import 'package:kido/Widgets/ThreeDColorsPalettePainter.dart';
import 'package:kido/Widgets/ThreeDNumberOnePainter.dart';
import 'package:kido/constants.dart';

class CategoryGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true, // مهم جداً
      physics:
          const NeverScrollableScrollPhysics(), // بيخلي التمرير للملف الكبير كله
      // ... الإعدادات الـ Responsive السابقة ...
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 180,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: 0.85,
      ),
      children: [
        // كارد الأبجدية (استخدمي AnimatedThreeDLetterA هنا)
        CategoryCard(
          title: "Alphabets",
          gradient: AppColors.alphabetGrad,
          graphic: Center(child: AnimatedThreeDLetterA(size: 80)),
          onTap: () {},
        ),

        // كارد الأرقام (استخدمي AnimatedThreeDNumberOne هنا)
        CategoryCard(
          title: "Numbers",
          gradient: AppColors.numbersGrad,
          graphic: Center(child: AnimatedThreeDNumberOne(size: 80)),
          onTap: () {},
        ),

        // كارد الألوان (استخدمي AnimatedColorsPalette هنا)
        CategoryCard(
          title: "Colors",
          gradient: AppColors.colorsGrad,
          graphic: Center(child: AnimatedColorsPalette(size: 80)),
          onTap: () {},
        ),

        // *** التعديل هنا: إضافة كارد الفاكهة ***
        // كارد الفاكهة (الآن مع التفاحة المتحركة واللطيفة)
        CategoryCard(
          title: "Fruit",
          gradient:
              AppColors
                  .puzzleGrad, // يمكنك استخدام أي تدرج لوني مناسب (مثلاً أزرق فاتح مثل البازل)
          graphic: Center(
            child: AnimatedCuteApple(size: 80), // التفاحة الآن تطفو وتميل!
          ),
          onTap: () {},
        ),
        CategoryCard(
          title: "Vegetables",
          gradient: AppColors.vegetablesGrad,
          graphic: Center(
            child: AnimatedCarrot(size: 80), // تم استخدام Widget متحرك
          ),
          onTap: () {},
        ),
        CategoryCard(
          title: "Family",
          gradient:
              AppColors
                  .puzzleGrad, // يمكنك استخدام أي تدرج لوني مناسب (مثلاً أزرق فاتح مثل البازل)
          graphic: Center(
            child: AnimatedFamilyIcon(size: 80), // العائلة الآن تطفو وتميل!
          ),
          onTap: () {},
        ),
        // ... باقي الكروت ...
      ],
    );
  }
}
