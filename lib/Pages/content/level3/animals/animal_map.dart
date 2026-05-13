import 'package:flutter/material.dart';
import 'package:kido/Models/level3/letters/letter_map.dart';
import 'package:kido/Pages/content/level3/animals/animals_face_game.dart';
import 'package:kido/Pages/content/level3/animals/animals_practice.dart';
import 'package:kido/Widgets/content/level3/discovery_widget.dart';
import 'package:kido/constants.dart';
import 'package:kido/Widgets/content/journey_map.dart';
import '../../../../data/content/level3/animals/animals_data.dart';
import '../../../../data/content/level3/animals/animals_journey.dart';

class AnimalMapPage extends StatefulWidget {

  const AnimalMapPage({super.key});

  @override
  State<AnimalMapPage> createState() => _AnimalMapPageState();
}

class _AnimalMapPageState extends State<AnimalMapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: JourneymapPage(
        journeyData:animalsJourney,
        backgroundColor: AppColors.kidoYellow,
        nodeButtonColor: AppColors.kidoColors[5],
        detailFlowBuilder: (item) {
          if(item.charName=='practice_test'){
            return AnimalsPracticePage();
          }else{
            return AnimalDetailsFlow(item:item);
          }
        }
      ),
    );
  }
}

class AnimalDetailsFlow extends StatelessWidget {
  final LetterJourney item;
  const AnimalDetailsFlow({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return DiscoveryPage(
        model: item.letterData,
        onNextPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => AnimalFaceGamePage(
                    intialIndex:animalsDiscovery.indexOf(item.letterData),
                    onGameComplete: () {
                      Navigator.pop(context);
                      Navigator.pop(context,true);
                    },
                  ),
            ),
            );
        },
    );
  }
}
