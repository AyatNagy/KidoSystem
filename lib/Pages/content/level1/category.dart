import 'package:flutter/material.dart';
import 'package:kido/Pages/content/level1/senses/senses_map_page.dart';
import '../../../Widgets/Animation/senses.dart';
import '../../../Widgets/content/category_card.dart';
import '../../../constants.dart';
import '../feelings/feelings_levels.dart';
import 'Self_cleaning/cleaning_map.dart';
import 'draw.dart';
import 'matching_practice_page.dart';
import 'no1/banana_count.dart';
import 'no1/bees_count.dart';
import 'no1/toys_count.dart';
import 'no3/cubes.dart';
import 'no3/moving_car.dart';
import 'no6/carrot.dart';
import 'no6/lesson1.dart';

class Category extends StatelessWidget {
  final String childName; // ← ضيف
  final int childId; // ← ضيف

  const Category({
    super.key,
    required this.childName, // ← ضيف
    required this.childId, // ← ضيف
  });

  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 180,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: 0.85,
      ),
      children: [
        // 1. COUNTING
        CategoryCard(
          gradient: AppColors.alphabetGrad,
          graphic: Center(
            child: Image.asset(
              'assets/images/level1/counting.gif',
              fit: BoxFit.cover,
            ),
          ),
          onTap: () async {
            final navigator = Navigator.of(context);
            await navigator.push(
              MaterialPageRoute(
                builder:
                    (context) => MonkeyCountingPage(
                      onNext: () => Navigator.pop(context),
                    ),
              ),
            );
            await navigator.push(
              MaterialPageRoute(
                builder:
                    (context) =>
                        BeeCountingPage(onNext: () => Navigator.pop(context)),
              ),
            );
            await navigator.push(
              MaterialPageRoute(
                builder:
                    (context) =>
                        ToyRewardPage(onNext: () => Navigator.pop(context)),
              ),
            );
          },
        ),

        // 2. SORTING
        CategoryCard(
          gradient: AppColors.numbersGrad,
          graphic: Center(
            child: Image.asset(
              'assets/images/level1/sort.png',
              fit: BoxFit.cover,
            ),
          ),
          onTap: () async {
            final navigator = Navigator.of(context);
            await navigator.push(
              MaterialPageRoute(
                builder:
                    (context) => CubesLesson(
                      onNext: () => Navigator.pop(context),
                      childName: childName,
                      childId: childId,
                    ),
              ),
            );
            await navigator.push(
              MaterialPageRoute(
                builder:
                    (context) => MovingCarPage(
                      onNext: () => Navigator.pop(context),
                      childName: childName, // ← ضيف
                      childId: childId, // ← ضيف
                    ),
              ),
            );
          },
        ),

        // 3. PEGBOARD
        CategoryCard(
          gradient: AppColors.colorsGrad,
          graphic: Center(
            child: Image.asset(
              'assets/images/level1/sticks-c.png',
              fit: BoxFit.cover,
            ),
          ),
          onTap: () async {
            final navigator = Navigator.of(context);
            await navigator.push(
              MaterialPageRoute(
                builder:
                    (context) =>
                        BunnyFeedingGame(onNext: () => Navigator.pop(context)),
              ),
            );
            await navigator.push(
              MaterialPageRoute(
                builder:
                    (context) =>
                        StakesDrag(onNext: () => Navigator.pop(context)),
              ),
            );
          },
        ),

        // SENSES
        CategoryCard(
          gradient: AppColors.fruitGrad,
          graphic: const Center(child: FiveSensesLogo()),
          onTap:
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SensesMapPage()),
              ),
        ),

        // MATCHING
        CategoryCard(
          gradient: [AppColors.kidoColors[5], AppColors.kidoOrange],
          graphic: Center(child: Image.asset('assets/gif/match.gif')),
          onTap:
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MatchingPracticePage(),
                ),
              ),
        ),

        // DRAWING
        CategoryCard(
          gradient: AppColors.puzzleGrad,
          graphic: Center(child: Image.asset('assets/images/drawing/draw.gif')),
          onTap:
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Draw()),
              ),
        ),

        // SELF-CARE
        CategoryCard(
          gradient: AppColors.vegetablesGrad,
          graphic: Center(child: Image.asset('assets/gif/self-care.gif')),
          onTap:
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CleaningMap()),
              ),
        ),

        // FEELINGS
        CategoryCard(
          gradient: [AppColors.kidoColors[6], AppColors.kidoRed],
          graphic: Center(child: Image.asset('assets/gif/feelings.gif')),
          onTap:
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TreehouseLevels(),
                ),
              ),
        ),
      ],
    );
  }
}
