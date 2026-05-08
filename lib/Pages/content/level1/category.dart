import 'package:flutter/material.dart';
import 'package:kido/Pages/content/level1/senses/senses_map_page.dart';
import 'package:kido/Widgets/content/category_card.dart';
import 'package:kido/constants.dart';
import '../../../Widgets/Animation/counting.dart';
import '../../../Widgets/Animation/peg_board.dart';
import '../../../Widgets/Animation/senses.dart';
import '../../../Widgets/Animation/sorting_tower.dart';
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
import 'no6/stake_lesson.dart';

class Category extends StatelessWidget {
  const Category({super.key});

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
        //  COUNTING
        CategoryCard(
          gradient: AppColors.alphabetGrad,
          graphic: const Center(child: Counting()),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => MonkeyCountingPage(
                      onNext: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => BeeCountingPage(
                                  onNext: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => ToyRewardPage(
                                              onNext: () {
                                                Navigator.popUntil(
                                                  context,
                                                  (route) => route.isFirst,
                                                );
                                              },
                                            ),
                                      ),
                                    );
                                  },
                                ),
                          ),
                        );
                      },
                    ),
              ),
            );
          },
        ),

        // SORTING
        CategoryCard(
          gradient: AppColors.numbersGrad,
          graphic: const Center(child: SortingTower()),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => CubesLesson(
                      onNext: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => MovingCarPage(
                                  onNext: () {
                                    Navigator.popUntil(
                                      context,
                                      (route) => route.isFirst,
                                    );
                                  },
                                ),
                          ),
                        );
                      },
                    ),
              ),
            );
          },
        ),

        // PEGBOARD
        CategoryCard(
          gradient: AppColors.colorsGrad,
          graphic: const Center(child: PegboardLogo()),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => BunnyFeedingGame(
                      onNext: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => StakeDrag(
                                  onNext: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => StakesDrag(
                                              onNext: () {
                                                Navigator.popUntil(
                                                  context,
                                                  (route) => route.isFirst,
                                                );
                                              },
                                            ),
                                      ),
                                    );
                                  },
                                ),
                          ),
                        );
                      },
                    ),
              ),
            );
          },
        ),

        // SENSES
        CategoryCard(
          gradient: AppColors.fruitGrad,
          graphic: const Center(child: FiveSensesLogo()),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SensesMapPage()),
            );
          },
        ),

        // MATCHING
        CategoryCard(
          gradient: [AppColors.kidoColors[5], AppColors.kidoOrange],
          graphic: Center(child: Image.asset('assets/gif/match.gif')),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MatchingPracticePage(),
              ),
            );
          },
        ),

        // DRAWING
        CategoryCard(
          gradient: AppColors.puzzleGrad,
          graphic: Center(child: Image.asset('assets/images/drawing/draw.gif')),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Draw()),
            );
          },
        ),

        //SELF-CARE
        CategoryCard(
          gradient: AppColors.vegetablesGrad,
          graphic: Center(child: Image.asset('assets/gif/self-care.gif')),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CleaningMap()),
            );
          },
        ),

        // FEELINGS
        CategoryCard(
          gradient: [AppColors.kidoColors[6], AppColors.kidoRed],
          graphic: Center(child: Image.asset('assets/gif/feelings.gif')),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TreehouseLevels()),
            );
          },
        ),
      ],
    );
  }
}
