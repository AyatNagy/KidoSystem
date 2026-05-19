import 'package:flutter/material.dart';
import 'package:kido/Pages/content/level3/animals/animal_map.dart';
import 'package:kido/Pages/content/level3/letters/ar_letters_map.dart';
import 'package:kido/Pages/content/level3/letters/letters_map.dart';
import 'package:kido/Pages/content/level3/numbers/numbers_map.dart';
import 'package:kido/Pages/content/level3/vegetables/vegetables_map.dart';
import 'package:kido/Widgets/content/category_card.dart';
import 'package:kido/constants.dart';
import 'package:kido/utils/category_progress.dart';
import 'family_members/background_page.dart';
import 'fruits/fruits_map.dart';

class CategoryGrid extends StatelessWidget {
  final int childId;

  const CategoryGrid({super.key, this.childId = 0});

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
            'assets/images/arabic_letters/lettersa_c.png',
            fit: BoxFit.cover,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ArLettersMapPage(childId: childId),
              ),
            );
          },
        ),
        CategoryCard(
          gradient: AppColors.alphabetGrad,
          graphic: Image.asset(
            'assets/images/letters/letterse_c.png',
            fit: BoxFit.cover,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LettersMapPage(childId: childId),
              ),
            );
          },
        ),
        CategoryCard(
          gradient: AppColors.numbersGrad,
          graphic: Image.asset(
            'assets/images/englishNumbers/nume_c.png',
            fit: BoxFit.cover,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NumbersMapPage(
                  isEnglish: true,
                  childId: childId,
                ),
              ),
            );
          },
        ),
        CategoryCard(
          gradient: AppColors.numbersGrad,
          graphic: Image.asset(
            'assets/images/arabicNumbers/numa_c.png',
            fit: BoxFit.cover,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NumbersMapPage(
                  isEnglish: false,
                  childId: childId,
                ),
              ),
            );
          },
        ),
        CategoryCard(
          gradient: AppColors.puzzleGrad,
          graphic: Image.asset(
            'assets/images/fruits/fruits_c.png',
            fit: BoxFit.cover,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FruitsMapPage(childId: childId),
              ),
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
              MaterialPageRoute(
                builder: (context) => VegetablesMapPage(childId: childId),
              ),
            );
          },
        ),
        CategoryCard(
          gradient: AppColors.puzzleGrad,
          graphic: Image.asset(
            'assets/images/family/family_c.png',
            fit: BoxFit.cover,
          ),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FamilyBackGround()),
            );
            await completeCategoryLessons(
              childId: childId,
              categoryName: 'Family',
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
              MaterialPageRoute(
                builder: (context) => AnimalMapPage(childId: childId),
              ),
            );
          },
        ),
      ],
    );
  }
}
