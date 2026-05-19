import 'package:flutter/material.dart';
import 'package:kido/Pages/content/level3/fruits/pixel_game.dart';
import 'package:kido/constants.dart';
import '../../../../Models/level3/letters/letter_map.dart';
import '../../../../Widgets/content/level3/discovery_widget.dart';
import '../../../../Widgets/content/level3/fruits/basket_game.dart';
import '../../../../Widgets/content/level3/fruits/tree_game.dart';
import '../../../../Widgets/content/journey_map.dart';
import '../../../../data/content/level3/fruits/fruits_journey.dart';
import 'package:kido/utils/category_progress.dart';
import 'package:kido/utils/journey_navigation.dart';

class FruitsMapPage extends StatefulWidget {
  final int childId;

  const FruitsMapPage({super.key, this.childId = 0});

  @override
  State<FruitsMapPage> createState() => _FruitsMapPageState();
}

class _FruitsMapPageState extends State<FruitsMapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: JourneymapPage(
        childId: widget.childId,
        resolveLessonId: (_, index) =>
            lessonIdByCategoryIndex('Fruits', index),
        journeyData: journeyFruits,
        backgroundColor: AppColors.kidoPink,
        nodeButtonColor: AppColors.kidoColors[3],
        detailFlowBuilder: (item) => FruitsDetailsFlow(item: item),
      ),
    );
  }
}

class FruitsDetailsFlow extends StatelessWidget {
  final LetterJourney item;
  const FruitsDetailsFlow({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DiscoveryPage(
        model: item.letterData,
        onNextPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => TreeDiscoveryPage(
                    fruit: item.dragData,
                    onNext: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => FruitCollectorPage(
                                fruit: item.dragData,
                                onNext: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => FruitGamePage(
                                            fruit: item.dragData,
                                            onComplete: () {
                                              finishJourneyNode(
                                                context,
                                                screensAboveMap: 3,
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
    );
  }
}
