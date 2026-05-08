import 'package:flutter/material.dart';
import 'package:kido/Models/level3/letters/letter_map.dart';
import 'package:kido/Pages/content/level1/senses/sense_learning_page.dart';
import 'package:kido/data/level1/senses/senses_journy.dart';
import 'package:kido/enum/sense_type.dart';
import '../../../../Widgets/content/journey_map.dart';

class SensesMapPage extends StatelessWidget {
  const SensesMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: JourneymapPage(
        journeyData: sensesJourney,
        backgroundColor: Colors.blueAccent,
        nodeButtonColor: Colors.white,
        detailFlowBuilder: (item) {
          return SensesDetailsFlow(item: item);
        },
      ),
    );
  }
}

class SensesDetailsFlow extends StatelessWidget {
  final LetterJourney item;
  const SensesDetailsFlow({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final type = _getTypeFromCharName(item.charName!);

    return SenseLearningScreen(type: type);
  }

  SenseType _getTypeFromCharName(String name) {
    switch (name) {
      case 'eyes':
        return SenseType.eyes;
      case 'nose':
        return SenseType.nose;
      case 'mouth':
        return SenseType.mouth;
      case 'ears':
        return SenseType.ears;
      default:
        return SenseType.eyes;
    }
  }
}
