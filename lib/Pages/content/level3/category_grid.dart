import 'package:flutter/material.dart';
import 'package:kido/Pages/content/level3/animals/animal_map.dart';
import 'package:kido/Pages/content/level3/vegetables/vegetable_map_screen.dart';
import 'package:kido/Widgets/content/category_card.dart';
import 'package:kido/constants.dart';
import 'choose_letters.dart';
import 'family_members/BackgroundPage.dart';
import 'fruits/fruits_map.dart';
import 'numbers/choose_numbers.dart';

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
          graphic: Image.asset(
            'assets/images/letters/lettersE_c.png',
            fit: BoxFit.cover,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LanguageSelectionPage()),
            );
          },
        ),

        CategoryCard(
          gradient: AppColors.numbersGrad,
          graphic: Image.asset(
            'assets/images/englishNumbers/numE_c.png',
            fit: BoxFit.cover,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NumbersLanguageSelectionPage(),
              ),
            );
          },
        ),

        /*CategoryCard(
          gradient: AppColors.colorsGrad,
          graphic: Center(child: AnimatedColorsPalette(size: 80)),
          onTap: () {},
        ),
*/
        CategoryCard(
          gradient: AppColors.puzzleGrad,
          graphic: Image.asset(
            'assets/images/fruits/fruits_c.png',
            fit: BoxFit.cover,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FruitsMapPage()),
            );
          },
        ),
        CategoryCard(
          gradient: AppColors.vegetablesGrad,
          graphic: Image.asset(
            'assets/images/fruits/veg_c.png',
            fit: BoxFit.cover,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => VegetableMapScreen()),
            );
          },
        ),
        CategoryCard(
          gradient: AppColors.puzzleGrad,
          graphic: Image.asset(
            'assets/images/family/family_c.png',
            fit: BoxFit.cover,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FamilyBackGround()),
            );
          },
        ),
        CategoryCard(
          gradient: AppColors.puzzleGrad,
          graphic: Image.asset(
            'assets/images/animals/animals_c.png',
            fit: BoxFit.cover,
          ),
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
