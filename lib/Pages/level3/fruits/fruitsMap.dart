import 'package:flutter/material.dart';
import 'package:kido/Pages/level3/fruits/pixelGame.dart';
import 'package:kido/constants.dart';
import '../../../Models/level3/letters/letterMap.dart';
import '../../../Widgets/content/level3/discoveryWidget.dart';
import '../../../Widgets/content/level3/fruits/basketGame.dart';
import '../../../Widgets/content/level3/fruits/treeGame.dart';
import '../../../Widgets/journeyMap.dart';
import '../../../data/level3/fruits/fruits_journey.dart';

class FruitsMapPage extends StatefulWidget {
  const FruitsMapPage({super.key});

  @override
  State<FruitsMapPage> createState() => _FruitsMapPageState();
}

class _FruitsMapPageState extends State<FruitsMapPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:JourneymapPage(
            journeyData: journeyFruits,
            backgroundColor: AppColors.kidoPink,
            nodeButtonColor: AppColors.kidoColors[3],
            detailFlowBuilder: (item) => FruitsDetailsFlow(item: item,)
        )
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
              builder: (context) => TreeDiscoveryPage(
                fruit: item.dragData,
                onNext: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FruitCollectorPage(
                        fruit: item.dragData,
                        onNext: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context)=>
                                  FruitGamePage(
                                    fruit: item.dragData,
                                    onComplete: () {
                                      Navigator.of(context)
                                        ..pop()..pop()..pop()..pop(true);
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
      );
  }
}