import 'package:flutter/material.dart';
import 'package:kido/Pages/content/level3/vegetables/vegetable_map_screen.dart';
import 'package:kido/Widgets/Animation/animated_3d_letter_a.dart';
import 'package:kido/Widgets/content/category_card.dart';
import 'package:kido/Widgets/Animation/threed_apple_painter.dart';
import 'package:kido/Widgets/Animation/threed_carrot_painter.dart';
import 'package:kido/Widgets/Animation/threed_colors_palette_painter.dart';
import 'package:kido/Widgets/Animation/threed_number1_painter.dart';
import 'package:kido/constants.dart';
import '../../../Widgets/Animation/animation_family_icon.dart';
import 'choose_letters.dart';
import 'family_members/BackgroundPage.dart';
import 'fruits/fruits_map.dart';
import 'numbers/choose_numbers.dart';
import 'package:kido/Pages/level3/animals/animal_map.dart';


class CategoryGrid extends StatelessWidget {
  const CategoryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 180,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: 0.85,
      ),
      children: [
        CategoryCard(
          gradient: AppColors.alphabetGrad,
          graphic: Center(child: AnimatedThreeDLetterA(size: 80)),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LanguageSelectionPage()),
            );
          },
        ),

        CategoryCard(
          gradient: AppColors.numbersGrad,
          graphic: Center(child: AnimatedThreeDNumberOne(size: 80)),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NumbersLanguageSelectionPage(),
              ),
            );
          },
        ),

        CategoryCard(
          gradient: AppColors.colorsGrad,
          graphic: Center(child: AnimatedColorsPalette(size: 80)),
          onTap: () {},
        ),

        CategoryCard(
          gradient: AppColors.puzzleGrad,
          graphic: Center(child: AnimatedCuteApple(size: 80)),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FruitsMapPage()),
            );
          },
        ),
        CategoryCard(
          gradient: AppColors.vegetablesGrad,
          graphic: Center(child: AnimatedCarrot(size: 80)),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => VegetableMapScreen()),
            );
          },
        ),
        CategoryCard(
          gradient: AppColors.puzzleGrad,
          graphic: Center(child: AnimatedFamilyIcon(size: 80)),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FamilyBackGround()),
            );
          },
        ),
        CategoryCard(
          gradient: AppColors.puzzleGrad,
          graphic: Center(child: AnimatedCuteApple(size: 80)),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AnimalMapPage()),
            );
          },
        ),
      ],
    );
  }
}