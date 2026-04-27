import 'package:flutter/material.dart';
import 'package:kido/Pages/level1/no3/moving_car.dart';
import 'package:kido/Pages/level1/no6/lesson1.dart';
import 'package:kido/Widgets/category_card.dart';
import 'package:kido/constants.dart';
import '../../Widgets/Animation/counting.dart';
import '../../Widgets/Animation/peg_board.dart';
import '../../Widgets/Animation/senses.dart';
import '../../Widgets/Animation/sorting_tower.dart';
import 'no1/banana_count.dart';
import 'no1/bees_count.dart';
import 'no1/toys_count.dart';

class Category extends StatelessWidget {
  const Category({super.key});

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
          title: "Counting",
          gradient: AppColors.alphabetGrad,
          graphic: Center(child: Counting()),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MonkeyCountingPage(
                  onNext: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BeeCountingPage(
                          onNext: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ToyRewardPage(),
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
          title: "Sorting",
          gradient: AppColors.numbersGrad,
          graphic: Center(child: SortingTower()),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MovingCarPage()
              )
            );
          },
        ),

        CategoryCard(
          title: "PegBoard",
          gradient: AppColors.colorsGrad,
          graphic: Center(child: PegboardLogo()),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => StakesDrag()
                )
            );
          },
        ),

        CategoryCard(
          title: "Senses",
          gradient: AppColors.puzzleGrad,
          graphic: Center(child: FiveSensesLogo()),
          onTap: () {},
        ),
      ],
    );
  }
}
