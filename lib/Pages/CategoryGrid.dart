import 'package:flutter/material.dart';
import 'package:kido/Widgets/AnimatedThreeDLetterA.dart';
import 'package:kido/Widgets/CategoryCard.dart';
import 'package:kido/Widgets/FamilyPainter.dart';
import 'package:kido/Widgets/ThreeDApplePainter.dart';
import 'package:kido/Widgets/ThreeDCarrotPainter.dart';
import 'package:kido/Widgets/ThreeDColorsPalettePainter.dart';
import 'package:kido/Widgets/ThreeDNumberOnePainter.dart';
import 'package:kido/constants.dart';

import 'level3/choose_letters.dart';
import 'level3/fruits/fruitsMap.dart';

class CategoryGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      physics:
          const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 180,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: 0.85,
      ),
      children: [
        CategoryCard(
          title: "Alphabets",
          gradient: AppColors.alphabetGrad,
          graphic: Center(child: AnimatedThreeDLetterA(size: 80)),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LanguageSelectionPage()
                )
            );
          },
        ),

        CategoryCard(
          title: "Numbers",
          gradient: AppColors.numbersGrad,
          graphic: Center(child: AnimatedThreeDNumberOne(size: 80)),
          onTap: () {},
        ),

        CategoryCard(
          title: "Colors",
          gradient: AppColors.colorsGrad,
          graphic: Center(child: AnimatedColorsPalette(size: 80)),
          onTap: () {},
        ),

        CategoryCard(
          title: "Fruit",
          gradient:
              AppColors.puzzleGrad,
          graphic: Center(
            child: AnimatedCuteApple(size: 80),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FruitsMapPage()
                )
            );
          },
        ),
        CategoryCard(
          title: "Vegetables",
          gradient: AppColors.vegetablesGrad,
          graphic: Center(
            child: AnimatedCarrot(size: 80),
          ),
          onTap: () {},
        ),
        CategoryCard(
          title: "Family",
          gradient:
              AppColors.puzzleGrad,
          graphic: Center(
            child: AnimatedFamilyIcon(size: 80),
          ),
          onTap: () {},
        ),
      ],
    );
  }
}
