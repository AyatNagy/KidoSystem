import 'package:flutter/material.dart';
import 'package:kido/Widgets/content/category_card.dart';
import 'package:kido/constants.dart';
import '../../../Widgets/Animation/counting.dart';
import '../../../Widgets/Animation/peg_board.dart';
import '../../../Widgets/Animation/senses.dart';
import '../../../Widgets/Animation/sorting_tower.dart';
import '../../../enum/sense_type.dart';
import 'draw.dart';
import '../senses/sense_learning_page.dart';
import 'level1_home.dart';
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
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 180,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: 0.85,
      ),
      children: [
        CategoryCard(
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
                                builder: (context) => ToyRewardPage(
                                  onNext:() {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Level1Home(childName: 'hab',)
                                        )
                                    );
                                }
                              )
                              )
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
          graphic: Center(child: SortingTower()),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CubesLesson(
                    onNext: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MovingCarPage()
                          )
                      );
                    }
                  )
              )
            );
          },
        ),

        CategoryCard(
          gradient: AppColors.colorsGrad,
          graphic: Center(child: PegboardLogo()),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BunnyFeedingGame(
                      onNext: (){
                        Navigator.push(
                          context,
                            MaterialPageRoute(
                                builder: (context) => StakeDrag(
                                  onNext: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => StakesDrag(
                                              onNext: (){
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => Level1Home(childName: 'hab',)
                                                    )
                                                );
                                              }
                                            )
                                        )
                                    );
                                  }
                                )
                            )
                        );
                      }
                    )
                )
            );
          },
        ),

        CategoryCard(
          gradient: AppColors.fruitGrad,
          graphic: Center(child: FiveSensesLogo()),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SenseLearningScreen(type: SenseType.eyes,)
                )
            );
          },
        ),

        //matching
        CategoryCard(
          gradient: AppColors.fruitGrad,
          graphic: Center(child: FiveSensesLogo()),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SenseLearningScreen(type: SenseType.eyes,)
                )
            );
          },
        ),

        CategoryCard(
          gradient: AppColors.puzzleGrad,
          graphic: Center(child: Image.asset('assets/images/drawing/draw.gif')),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Draw()
                )
            );
          },
        ),
      ],
    );
  }
}
