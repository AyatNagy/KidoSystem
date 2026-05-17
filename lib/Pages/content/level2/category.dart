import 'package:flutter/material.dart';
import 'package:kido/Pages/content/level2/draw/shapes/circle.dart';
import 'package:kido/Pages/content/level2/draw/draw_line/rainy_cloud.dart';
import 'package:kido/Pages/content/level2/draw/draw_line/rocket_lesson.dart';
import 'package:kido/Pages/content/level2/draw/plus.dart';
import 'package:kido/Pages/content/level2/level2home.dart';
import 'package:kido/Pages/content/level2/puzzle_practice.dart';
import 'package:kido/Pages/content/level2/sizes/sizes_map_page.dart';
import 'package:kido/Widgets/content/category_card.dart';
import 'package:kido/constants.dart';
import '../../../data/content/level2/puzzle_data.dart';
import 'draw/draw_line/octobus_and_star.dart';

class Category2 extends StatelessWidget {
  final String childName;
  final int childId;

  const Category2({super.key, required this.childName, required this.childId});

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
                                                                          childName,
                                                                      childId:
                                                                          childId,
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

        CategoryCard(
          gradient: AppColors.numbersGrad,
          graphic: Image.asset(
            'assets/images/sizes/size_cc.png',
            fit: BoxFit.cover,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SizesMapPage()),
            );
          },
        ),

        //Shapes
        CategoryCard(
          gradient: [AppColors.bgColor, AppColors.bgColor],
          graphic: Image.asset(
            'assets/images/sizes/shape_c.png',
            fit: BoxFit.cover,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => CircleDrawingPage(
                      childName: childName,
                      childId: childId,
                    ),
              ),
            );
          },
        ),

        //Puzzle
        CategoryCard(
          gradient: [AppColors.kidoPink, AppColors.bgColor],
          graphic: Image.asset(
            'assets/images/puzzle/puzzle_c.png',
            fit: BoxFit.cover,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => PuzzlePracticeScreen(
                      levels: allPuzzleLevels,
                      childName: childName,
                      childId: childId,
                    ),
              ),
            );
          },
        ),
      ],
    );
  }
}
