import 'package:flutter/material.dart';
import 'package:kido/Pages/content/level2/draw/circle.dart';
import 'package:kido/Pages/content/level2/draw/draw_line/rainy_cloud.dart';
import 'package:kido/Pages/content/level2/draw/draw_line/rocket_lesson.dart';
import 'package:kido/Pages/content/level2/draw/plus.dart';
import 'package:kido/Pages/content/level2/level2home.dart';
import 'package:kido/Pages/content/level2/puzzle_practice.dart';
import 'package:kido/Pages/content/level2/sizes/sizes_map_page.dart';
import 'package:kido/Widgets/content/category_card.dart';
import 'package:kido/constants.dart';
import 'package:kido/enum/size_goal.dart';
import '../../../Widgets/Animation/sorting_tower.dart';
import '../../../data/level2/puzzle_data.dart';
import 'sizes/size_intro_page.dart';
import 'draw/draw_line/octobus_and_star.dart';

class Category2 extends StatelessWidget {
  const Category2({super.key});

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
        //drawing line
        CategoryCard(
          gradient: AppColors.alphabetGrad,
          graphic: Center(
            child: Image.asset('assets/images/drawing/draw-line.gif'),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => OctobusAndStar(
                      onNext: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => RainyCloud(
                                  onNext: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => RocketLesson(
                                              onNext: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (
                                                          context,
                                                        ) => PlusDrawingPage(
                                                          onNext: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (
                                                                      context,
                                                                    ) => Level2Home(
                                                                      childName:
                                                                          'Habiba',
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
                          ),
                        );
                      },
                    ),
              ),
            );
          },
        ),

        //Big
        CategoryCard(
          gradient: AppColors.numbersGrad,
          graphic: Center(child: SortingTower()),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SizeIntroPage(goal: SizeGoal.big),
              ),
            );
          },
        ),

        //Small
        CategoryCard(
          gradient: AppColors.numbersGrad,
          graphic: Center(child: SortingTower()),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SizeIntroPage(goal: SizeGoal.small),
              ),
            );
          },
        ),

        //tall
        CategoryCard(
          gradient: AppColors.numbersGrad,
          graphic: Center(child: SortingTower()),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SizesMapPage()),
            );
          },
        ),

        //Short
        CategoryCard(
          gradient: AppColors.numbersGrad,
          graphic: Center(child: SortingTower()),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SizeIntroPage(goal: SizeGoal.short),
              ),
            );
          },
        ),

        //Thin
        CategoryCard(
          gradient: AppColors.numbersGrad,
          graphic: Center(child: SortingTower()),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SizeIntroPage(goal: SizeGoal.thin),
              ),
            );
          },
        ),

        //Shapes
        CategoryCard(
          gradient: [AppColors.bgColor, AppColors.bgColor],
          graphic: Center(child: Image.asset('assets/gif/shapes.gif')),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CircleDrawingPage()),
            );
          },
        ),

        //Puzzle
        CategoryCard(
          gradient: [AppColors.kidoPink, AppColors.bgColor],
          graphic: Center(child: Image.asset('assets/gif/puzzle.gif')),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PuzzlePracticeScreen(levels: appleLevels),
              ),
            );
          },
        ),
      ],
    );
  }
}
